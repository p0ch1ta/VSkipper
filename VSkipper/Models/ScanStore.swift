//  Created by p0ch1ta on 29/05/2023 for project VSkipper

import Foundation
import ChromaSwift

//@MainActor
class ScanStore: ObservableObject {

    @Published var playlistPath: String = APP.Placeholder.emptyPlaylistPath {
        didSet {
            do {
                try loadSamples()
            } catch {
                print(error)
            }
        }
    }

    @Published var currentIteration = 0
    @Published var currentFilename = ""
    @Published var currentSampleName = ""
    @Published var currentSimilarity = ""
    @Published var totalFiles = 0
    @Published var filesProcessed = 0
    @Published var savesPath: String = ""

    var samples: [Sample] = []
    var configEntries = [ConfigEntry]()

    func loadSamples() throws {
        samples = try SampleService.shared.getSamples()
        samples = samples.filter({ $0.targetPlaylistPath == playlistPath })
    }

    func getStatus() -> ScanStatus {
        if totalFiles == 0 {
            return .idle
        } else if filesProcessed == totalFiles {
            return .done
        } else {
            return .processing
        }
    }

    func scanPlaylist() async throws {
        configEntries = [ConfigEntry]()

        if playlistPath == APP.Placeholder.emptyPlaylistPath {
            throw ScanError.playlistPathNotSelected
        }

        guard let encodedPath = playlistPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw ScanError.playlistPathInvalid
        }

        guard let playlistURL = URL(string: encodedPath) else {
            throw ScanError.playlistPathInvalid
        }

        let files = try FileManager.default.contentsOfDirectory(at: playlistURL, includingPropertiesForKeys: nil)
        let filesCount = files.filter {$0.isFileURL && $0.lastPathComponent.hasSuffix(APP.FileExtension.mkv)}.count

        if filesCount == 0 {
            throw ScanError.noFilesToProcess
        }

        DispatchQueue.main.async {
            self.filesProcessed = 0
            self.totalFiles = filesCount
        }
     

        for file in files {
            if file.isFileURL && file.lastPathComponent.hasSuffix(APP.FileExtension.mkv) {
                DispatchQueue.main.async {
                    self.currentFilename = file.lastPathComponent
                }
                var configEntry = ConfigEntry(name: file.lastPathComponent, introTime: -1, outroTime: -1, introDuration: 0, outroDuration: 0)

                for sample in samples {
                    if configEntry.introTime != -1 && sample.type == .intro {
                        continue
                    }
                    if configEntry.outroTime != -1 && sample.type == .outro {
                        continue
                    }
                    DispatchQueue.main.async {
                        self.currentSampleName = sample.name
                    }
                    let time = try await findTimeByFingerprint(filePath: file.path(percentEncoded: false), fingerprint: sample.getAudioFingerprint(), startTime: sample.scanFrom, stopTime: sample.scanTo)
                    if time != -1 {
                        if sample.type == .intro {
                            configEntry.introTime = sample.scanFrom + time + 1
                            configEntry.introDuration = sample.duration
                        } else {
                            configEntry.outroTime = sample.scanFrom + time + 1
                            configEntry.outroDuration = sample.duration
                        }
                    }
                }

                configEntries.append(configEntry)
                DispatchQueue.main.async {
                    self.filesProcessed = self.configEntries.count
                }
            }
        }

        try savePlaylistFilesArray()
    }

    private func findTimeByFingerprint(filePath: String, fingerprint: AudioFingerprint, startTime: Int, stopTime: Int) async throws -> Int {

        let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleID = Bundle.main.bundleIdentifier!
        let workingPath = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.working)", isDirectory: true)
        try workingPath.createIfNotExists()
        try FileManager.default.removeItem(at: workingPath)
        try workingPath.createIfNotExists()

        let format = try await FFMPEGService.shared.getAudioFormat(path: filePath)
        let fullDuration = try await FFMPEGService.shared.getVideoDuration(path: filePath)
        let outputFileURL = workingPath.appendingPathComponent("full.\(format)")
        try await FFMPEGService.shared.extractSample(sourcePath: filePath, targetPath: outputFileURL.path(percentEncoded: false), startTime: startTime, duration: stopTime - startTime)

        var duration = stopTime - startTime
        let realDuration = fullDuration - startTime

        if realDuration < 1 {
            throw ScanError.sampleScanFromTimeIsOutOfBounds
        }

        if realDuration < duration {
            duration = realDuration
        }

        let cutFileURL = workingPath.appendingPathComponent("cut.\(format)")
        try await FFMPEGService.shared.fragmentAudio(sourcePath: outputFileURL.path(percentEncoded: false), targetPath: cutFileURL.path(percentEncoded: false), endTime: duration, fragmentDuration: APP.Samples.duration + 1)

        for i in 0...(duration - (APP.Samples.duration + 1)) {

            let cutFile2URL = workingPath.appendingPathComponent("cut_\(i).\(format)")

            var similarity: Double?
            var poolError: Error?
            autoreleasepool {
                do {
                    let sourceFingerprint = try AudioFingerprint(from: cutFile2URL)
                    similarity = try sourceFingerprint.similarity(to: fingerprint, ignoreSampleDuration: true)
                } catch {
                    poolError = error
                }
            }

            if let error = poolError {
                throw error
            }
            guard let similarity = similarity else {
                throw ScanError.fingerprintComparisonFailed
            }

            DispatchQueue.main.async {
                self.currentSimilarity = "\(similarity)"
                self.currentIteration = i
            }

            if similarity > APP.Scan.minSimilarity {
                try FileManager.default.removeItem(at: workingPath)
                return i
            }
        }
        try FileManager.default.removeItem(at: workingPath)
        return -1
    }

    private func savePlaylistFilesArray() throws {
        let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleID = Bundle.main.bundleIdentifier!
        let savesURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.saves)", isDirectory: true)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let playlistURL = URL(string: playlistPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let fileName = playlistURL!.lastPathComponent

        if !FileManager.default.fileExists(atPath: savesURL.path(percentEncoded: false)) {
            try FileManager.default.createDirectory(atPath: savesURL.path(percentEncoded: false), withIntermediateDirectories: true, attributes: nil)
        }

        let file = savesURL.appendingPathComponent(fileName.lowercased().appending(APP.FileExtension.json))

        DispatchQueue.main.async {
            self.savesPath = file.path(percentEncoded: false)
        }

        let data = try encoder.encode(configEntries)

        try data.write(to: file)
    }

}
