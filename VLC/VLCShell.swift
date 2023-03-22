//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import Foundation

class VLCShell {

    private var vlcExecutablePath: String

    init(vlcExecutablePath: String) {
        self.vlcExecutablePath = vlcExecutablePath
    }

    func extractAudio(inputFileURL: URL, outputFileURL: URL, startTime: Int, stopTime: Int) throws {

        let params = [
            "-I",
            "dummy",
            "--no-sout-video",
            "--sout-audio",
            "--sout=#std{access=file,mux=mov,dst=\(outputFileURL.path(percentEncoded: false))}",
            "\(inputFileURL.path(percentEncoded: false))",
            "--stop-time=\(stopTime)",
            "vlc://quit",
        ]

        let (_, _) = try shell(vlcExecutablePath, params)

        try cutAudio(fileURL: outputFileURL, startTime: startTime)
    }

    func cutAudio(fileURL: URL, startTime: Int) throws {

        let fileName = fileURL.lastPathComponent

        let tempUrl = fileURL.deletingLastPathComponent().appending(path: "tmp-\(fileName)")

        let cutParams = [
            "-I",
            "dummy",
            "--sout=#std{access=file,mux=mov,dst=\(tempUrl.path(percentEncoded: false))}",
            "\(fileURL.path(percentEncoded: false))",
            "--start-time=\(startTime)",
            "vlc://quit",
        ]

        let (_, _) = try shell(vlcExecutablePath, cutParams)

        try! FileManager.default.removeItem(at: fileURL)

        try! FileManager.default.moveItem(at: tempUrl, to: fileURL)
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
