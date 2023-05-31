//  Created by p0ch1ta on 24/04/2023 for project VSkipper

import Foundation
import AVFoundation
import ChromaSwift

struct Sample: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String = ""
    var type: SampleType = .intro
    var duration: Int = 0
    var startTime: Int = 0
    var scanFrom: Int = 0
    var scanTo: Int = 0
    var fileExtension: String = ""
    var sourceFilePath: String = "" {
        didSet {
            targetPlaylistPath = URL(fileURLWithPath: sourceFilePath)
                .deletingLastPathComponent().path(percentEncoded: false)
        }
    }
    var targetPlaylistPath: String = ""

    var audioPlayer: AVAudioPlayer?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case duration
        case startTime
        case scanFrom
        case scanTo
        case fileExtension
        case sourceFilePath
        case targetPlaylistPath
    }

    var filePath: String? {
        guard let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return nil
        }
        let samplesDirectoryURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.samples)", isDirectory: true)
        return samplesDirectoryURL.appendingPathComponent("\(id).\(fileExtension)").path
    }

    mutating func getStartTimeFromVLC() async throws {
        startTime = try await VLCService.shared.getCurrentTime()
    }

    mutating func getScanFromTimeFromVLC() async throws {
        scanFrom = try await VLCService.shared.getCurrentTime()
    }

    mutating func getScanToTimeFromVLC() async throws {
        scanTo = try await VLCService.shared.getCurrentTime()
    }

    mutating func getDurationStartTimeFromVLC() async throws {
        duration = try await VLCService.shared.getCurrentTime()
    }

    mutating func getDurationEndTimeFromVLCAndCalculate() async throws {
        duration = try await VLCService.shared.getCurrentTime() - startTime
    }

    mutating func playSound() throws {
        guard let filePath = filePath else {
            throw SampleError.sampleFilePathResolveError
        }
        let url = URL(fileURLWithPath: filePath)
        if audioPlayer == nil {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        }
        audioPlayer?.play()
    }

    func stopSound() {
        audioPlayer?.stop()
    }

    func getAudioFingerprint() throws -> AudioFingerprint {
        guard let filePath = filePath else {
            throw SampleError.sampleFilePathResolveError
        }
        let url = URL(fileURLWithPath: filePath)
        return try AudioFingerprint(from: url)
    }
}
