//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import Foundation
import ChromaSwift

class ScanViewModel: ObservableObject {

    private let defaults = UserDefaults.standard

    struct ConfigEntry: Codable {
        let name: String
        var introTime: Int
        var outroTime: Int
    }

    @Published var playlistPath: String = APP.Placeholder.emptyPlaylistPath
    @Published var savesPath: String = ""
    @Published var scanMode = ScanMode.both
    @Published var currentIteration = 0

    @Published var currentFilename = ""
    @Published var currentSimilarity = ""
    @Published var totalFiles = 0
    @Published var filesProcessed = 0

    var configEntries = [ConfigEntry]()

    var workingPath: URL
    var samplesPath: URL
    var savesURL: URL

    var vlcShell: VLCShell

    public init() {
        let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleID = Bundle.main.bundleIdentifier!

        samplesPath = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.samples)", isDirectory: true)
        workingPath = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.working)", isDirectory: true)
        savesURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.saves)", isDirectory: true)

        let vlcPath = defaults.string(forKey: SettingsKey.vlcExecutablePath.rawValue) ?? ""
        vlcShell = VLCShell(vlcExecutablePath: vlcPath.appending(APP.Path.vlcExecutable))
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

        let introScanEnd = defaults.integer(forKey: SettingsKey.introScanEnd.rawValue)
        let outroScanStart = defaults.integer(forKey: SettingsKey.outroScanStart.rawValue)

        let introPath = samplesPath.appending(path: APP.FileName.introSample)
        let outroPath = samplesPath.appending(path: APP.FileName.outroSample)

        if !FileManager.default.fileExists(atPath: introPath.path(percentEncoded: false)) &&
               (scanMode == .intro || scanMode == .both) {
            throw ScanError.failedToLoadIntroSample
        }

        if !FileManager.default.fileExists(atPath: outroPath.path(percentEncoded: false)) &&
               (scanMode == .outro || scanMode == .both) {
            throw ScanError.failedToLoadOutroSample
        }

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

        if !FileManager.default.fileExists(atPath: workingPath.path(percentEncoded: false)) {
            try FileManager.default.createDirectory(atPath: workingPath.path(percentEncoded: false), withIntermediateDirectories: true, attributes: nil)
        }

        let introFingerprint = try AudioFingerprint(from: introPath)
        let outroFingerprint = try AudioFingerprint(from: outroPath)

        for file in files {
            if file.isFileURL && file.lastPathComponent.hasSuffix(APP.FileExtension.mkv) {

                var playlistFile = ConfigEntry(name: file.lastPathComponent, introTime: -1, outroTime: -1)

                DispatchQueue.main.async {
                    self.currentFilename = file.lastPathComponent
                }

                let introCutURL = workingPath.appendingPathComponent(APP.FileName.introCut)
                let outroCutURL = workingPath.appendingPathComponent(APP.FileName.outroCut)

                if scanMode == .intro || scanMode == .both {
                    let time = try getFingerprintTime(
                        inputFileURL: file,
                        outputFileURL: introCutURL,
                        startTime: 0,
                        stopTime: introScanEnd,
                        fingerprint: introFingerprint
                    )
                    playlistFile.introTime = time
                }
                if scanMode == .outro || scanMode == .both {
                    let time = try getFingerprintTime(
                        inputFileURL: file,
                        outputFileURL: outroCutURL,
                        startTime: outroScanStart,
                        stopTime: 999999,
                        fingerprint: outroFingerprint
                    )
                    playlistFile.outroTime = time + outroScanStart
                }
                configEntries.append(playlistFile)
                DispatchQueue.main.async {
                    self.filesProcessed = self.configEntries.count
                }
            }
        }
        try savePlaylistFilesArray()
    }

    func getFingerprintTime(inputFileURL: URL, outputFileURL: URL, startTime: Int, stopTime: Int, fingerprint: AudioFingerprint) throws -> Int {

        try vlcShell.extractAudio(
            inputFileURL: inputFileURL,
            outputFileURL: outputFileURL,
            startTime: startTime,
            stopTime: stopTime
        )

        let durationDouble = try AudioFingerprint(from: outputFileURL).duration
        let duration = Int(floor(durationDouble)) - APP.Samples.duration

        var cutSeconds = 0
        for i in 0...duration {
            var similarity: Double?
            var poolError: Error?
            autoreleasepool {
                do {
                    let sourceFingerprint =
                        try AudioFingerprint(
                            from: outputFileURL,
                            maxSampleDuration: Double(i - cutSeconds + APP.Samples.duration)
                        )
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
                return i
            }
            if i != 0 && i.isMultiple(of: APP.Scan.maxSampleTime) {
                try vlcShell.cutAudio(fileURL: outputFileURL, startTime: APP.Scan.maxSampleTime - APP.Samples.duration)
                cutSeconds += APP.Scan.maxSampleTime
            }
        }
        return -1
    }

    func savePlaylistFilesArray() throws {
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
