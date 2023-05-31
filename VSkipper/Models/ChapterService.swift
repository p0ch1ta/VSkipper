//  Created by p0ch1ta on 06/05/2023 for project VSkipper

import Foundation

class ChapterService {

    static let shared = ChapterService()

    private init() {}

    func getChapters(path: String) throws -> [Chapter] {

        let params = [
            "-v",
            "panic",
            "-print_format",
            "json",
            "-hide_banner",
            "-show_chapters",
            "\(path)",
        ]

        let (output, _) = try shell("/usr/local/bin/ffprobe", params)

        let data = Data(output!.utf8)
        let chaptersEncoded = try JSONDecoder().decode(ChapterEncodedList.self, from: data)
        return chaptersEncoded.chapters.map { $0.toChapter() }
    }

    private func shell(_ launchPath: String, _ arguments: [String] = []) throws -> (String?, Int32) {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: launchPath)
        task.arguments = arguments

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        try task.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        task.waitUntilExit()
        return (output, task.terminationStatus)
    }

}
