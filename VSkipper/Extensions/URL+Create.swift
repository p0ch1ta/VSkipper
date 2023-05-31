//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import Foundation

extension URL {
    func createIfNotExists() throws {
        if !FileManager.default.fileExists(atPath: path(percentEncoded: false)) {
            try FileManager.default.createDirectory(
                atPath: path(percentEncoded: false),
                withIntermediateDirectories: true, attributes: nil)
        }
    }
}