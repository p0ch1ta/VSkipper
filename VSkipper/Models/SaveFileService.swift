//  Created by p0ch1ta on 25/06/2023 for project VSkipper

import Foundation

class SaveFileService {
    
    static let shared = SaveFileService()

    private init() {}
    
    func getSaveFiles() throws -> [SaveFile] {
        guard let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw SavesServiceError.savesDirectoryResolveError
        }
        guard let bundleID = Bundle.main.bundleIdentifier else {
            throw SavesServiceError.savesDirectoryResolveError
        }

        let savesDirectoryURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.saves)", isDirectory: true)
        try savesDirectoryURL.createIfNotExists()

        let files = try FileManager.default.contentsOfDirectory(at: savesDirectoryURL, includingPropertiesForKeys: nil)

        return files.filter { $0.lastPathComponent != APP.FileName.dsStore }.map { SaveFile(id: UUID(), name: $0.lastPathComponent, path: $0.path(percentEncoded: false)) }
    }
    
}
