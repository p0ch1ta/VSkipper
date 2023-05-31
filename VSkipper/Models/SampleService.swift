//  Created by p0ch1ta on 24/04/2023 for project VSkipper

import Foundation

class SampleService {

    static let shared = SampleService()

    @UserDefault(key: APP.UserDefaults.currentIntroFile, defaultValue: "")
    var currentIntroFile: String

    @UserDefault(key: APP.UserDefaults.currentOutroFile, defaultValue: "")
    var currentOutroFile: String

    private init() {}

    func getSamples() throws -> [Sample] {
        guard let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw SampleServiceError.samplesDirectoryResolveError
        }
        guard let bundleID = Bundle.main.bundleIdentifier else {
            throw SampleServiceError.samplesDirectoryResolveError
        }

        let samplesDirectoryURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.samples)", isDirectory: true)
        try samplesDirectoryURL.createIfNotExists()

        let samplesFile = samplesDirectoryURL.appendingPathComponent(APP.FileName.samples)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode([Sample]())
        try samplesFile.createFileIfNotExists(data: data)

        let JSONDecoder = JSONDecoder()
        let fileData = try Data(contentsOf: samplesFile)

        return try JSONDecoder.decode([Sample].self, from: fileData)
    }

    func saveSamples(samples: [Sample]) throws {
        guard let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw SampleServiceError.samplesDirectoryResolveError
        }
        guard let bundleID = Bundle.main.bundleIdentifier else {
            throw SampleServiceError.samplesDirectoryResolveError
        }

        let samplesDirectoryURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.samples)", isDirectory: true)
        try samplesDirectoryURL.createIfNotExists()

        let samplesFile = samplesDirectoryURL.appendingPathComponent(APP.FileName.samples)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(samples)
        try data.write(to: samplesFile)
    }

}
