//  Created by p0ch1ta on 28/05/2023 for project VSkipper

import Foundation

class FFMPEGService {

    static let shared = FFMPEGService()

    private init() {}

    func getAudioFormat(path: String) async throws -> String {

        let params = [
            "-v",
            "panic",
            "-hide_banner",
            "-select_streams",
            "a:0",
            "-show_entries",
            "stream=codec_name",
            "-of",
            "default=noprint_wrappers=1:nokey=1",
            "\(path)",
        ]

        let (output, _) = try await ShellService.shared.shell(APP.Path.ffprobeExecutable, params)

        guard let output else {
            throw FFMPEGServiceError.noAudioFormatOutput
        }

        //TODO check if output audio format is supported

        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func getVideoDuration(path: String) async throws -> Int {

        let params = [
            "-v",
            "panic",
            "-hide_banner",
            "-show_entries",
            "format=duration",
            "-of",
            "default=noprint_wrappers=1:nokey=1",
            "\(path)",
        ]

        let (output, _) = try await ShellService.shared.shell(APP.Path.ffprobeExecutable, params)

        guard let output else {
            throw FFMPEGServiceError.noAudioFormatOutput
        }
        
        guard let duration = Float(output.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            throw FFMPEGServiceError.invalidDurationFormat
        }

        //TODO check if output audio format is supported

        return Int(floorf(duration))
    }

    func extractSample(sourcePath: String, targetPath: String, startTime: Int, duration: Int) async throws {

        let params = [
            "-i",
            "\(sourcePath)",
            "-v",
            "panic",
            "-hide_banner",
            "-ss",
            "\(startTime)",
            "-t",
            "\(duration)",
            "-map",
            "0:a:0",
            "-c",
            "copy",
            "\(targetPath)",
        ]

        let (_, status) = try await ShellService.shared.shell(APP.Path.ffmpegExecutable, params)

        guard status == 0 else {
            throw FFMPEGServiceError.sampleExtractionFailed
        }
    }

    func cutAudio(sourcePath: String, targetPath: String, startTime: Int, duration: Int) async throws {

        let params = [
            "-i",
            "\(sourcePath)",
            "-v",
            "panic",
            "-hide_banner",
            "-ss",
            "\(startTime)",
            "-t",
            "\(duration)",
            "-c",
            "copy",
            "\(targetPath)",
        ]

        let (_, status) = try await ShellService.shared.shell(APP.Path.ffmpegExecutable, params)

        guard status == 0 else {
            throw FFMPEGServiceError.sampleExtractionFailed
        }
    }

    func fragmentAudio(sourcePath: String, targetPath: String, endTime: Int, fragmentDuration: Int) async throws {

        var params = [
            "-i",
            "\(sourcePath)",
            "-v",
            "panic",
            "-hide_banner",
        ]

        for i in 0...(endTime - fragmentDuration) {
            params.append("-ss")
            params.append("\(i)")
            params.append("-t")
            params.append("\(fragmentDuration)")
            params.append("-c")
            params.append("copy")
            params.append("\(targetPath.replaceLastOccurrence(of: ".", with: "_\(i)."))")
        }

        let (_, status) = try await ShellService.shared.shell(APP.Path.ffmpegExecutable, params)

        guard status == 0 else {
            throw FFMPEGServiceError.sampleExtractionFailed
        }
    }

    func getChapters(path: String) async throws -> [Chapter] {

        let params = [
            "-v",
            "panic",
            "-print_format",
            "json",
            "-hide_banner",
            "-show_chapters",
            "\(path)",
        ]

        let (output, _) = try await ShellService.shared.shell(APP.Path.ffprobeExecutable, params)

        guard let output else {
            throw FFMPEGServiceError.noChaptersOutput
        }

        let data = Data(output.utf8)
        let chaptersEncoded = try JSONDecoder().decode(ChapterEncodedList.self, from: data)
        return chaptersEncoded.chapters.map { $0.toChapter() }
    }

}
