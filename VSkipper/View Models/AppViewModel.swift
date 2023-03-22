//  Created by p0ch1ta on 21/03/2023 for project VSkipper

import Foundation
import SwiftUI
import ServiceManagement

class AppViewModel: ObservableObject {

    private let defaults = UserDefaults.standard

    @Published var iconColor: NSColor = .gray

    @Published var agentRunning: Bool = false

    @Published var selectedSaveFile: SkipSaveFile = SkipSaveFile(rawValue: "")!

    let savesURL: URL

    init() {
        let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleID = Bundle.main.bundleIdentifier!

        savesURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.saves)", isDirectory: true)

        refreshSaves()
    }

    func refreshSaves() {
        var saves: [SkipSaveFile] = []

        if FileManager.default.fileExists(atPath: savesURL.path(percentEncoded: false)) {
            let files = try! FileManager.default.contentsOfDirectory(at: savesURL, includingPropertiesForKeys: nil)
            for file in files {
                if file.lastPathComponent == APP.FileName.dsStore {
                    continue
                }
                saves.append(SkipSaveFile(rawValue: file.lastPathComponent)!)
            }
        }

        if !saves.isEmpty {
            SkipSaveFile.allCases = saves
            selectedSaveFile = SkipSaveFile.allCases.first!
        } else {
            SkipSaveFile.allCases = []
            selectedSaveFile = SkipSaveFile(rawValue: "")!
        }
    }

    func startAgent() async throws {
        try createConfigForAgent()
        let agent = SMAppService.agent(plistName: APP.Agent.name)
        if agent.status != .enabled {
            try agent.register()
        }
        DispatchQueue.main.async { [self] in
            agentRunning = true
            iconColor = .green
        }
    }

    func stopAgent() async throws {
        let agent = SMAppService.agent(plistName: APP.Agent.name)
        try await agent.unregister()
        DispatchQueue.main.async { [self] in
            agentRunning = false
            iconColor = .gray
        }
    }

    private func createConfigForAgent() throws {
        let path = savesURL.deletingLastPathComponent().appendingPathComponent(APP.PathName.config, isDirectory: true)
        if !FileManager.default.fileExists(atPath: path.path(percentEncoded: false)) {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        }
        let fileURL = path.appendingPathComponent(APP.FileName.config)

        let introDuration = defaults.integer(forKey: SettingsKey.introDuration.rawValue)
        let outroDuration = defaults.integer(forKey: SettingsKey.outroDuration.rawValue)
        let vlcPort = defaults.integer(forKey: SettingsKey.vlcPort.rawValue)
        let vlcPassword = defaults.string(forKey: SettingsKey.vlcPassword.rawValue) ?? ""

        let JSONDecoder = JSONDecoder()

        let fileData = try Data(contentsOf: savesURL.appendingPathComponent(selectedSaveFile.name))

        let entries = try JSONDecoder.decode([SkipConfigEntry].self, from: fileData)

        let config = SkipConfig(introDuration: introDuration,
                                outroDuration: outroDuration,
                                vlcPort: vlcPort,
                                vlcPassword: vlcPassword,
                                entries: entries)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try encoder.encode(config)
        try data.write(to: fileURL)
    }

}
