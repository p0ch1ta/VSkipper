//  Created by p0ch1ta on 28/05/2023 for project VSkipper

import Foundation

class ShellService {

    static let shared = ShellService()

    private init() {}

    func shell(_ launchPath: String, _ arguments: [String] = []) async throws -> (String?, Int32) {
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
