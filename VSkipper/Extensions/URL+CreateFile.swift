//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import Foundation

extension URL {
    func createFileIfNotExists(data: Data) throws {
        if !FileManager.default.fileExists(atPath: path(percentEncoded: false)) {
            try data.write(to: self)
        }
    }
}