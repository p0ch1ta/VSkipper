//  Created by p0ch1ta on 21/03/2023 for project VSkipper

import Foundation
import SwiftUI
import ServiceManagement

class AppViewModel: ObservableObject {

    private let defaults = UserDefaults.standard

    @Published var iconColor: NSColor = .gray

    @Published var agentRunning: Bool = false

    @Published var agentStatus: SMAppService.Status = .notFound

    @Published var selectedSaveFile: SkipSaveFile = SkipSaveFile(rawValue: "")!

    let savesURL: URL

    init() {
        let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleID = Bundle.main.bundleIdentifier!

        savesURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.saves)", isDirectory: true)

        refreshSaves()
        refreshAgentStatus()
    }

    func refreshAgentStatus() {
        let agent = SMAppService.agent(plistName: APP.Agent.name)
        DispatchQueue.main.async {
            self.agentStatus = agent.status
        }
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

    func registerAgent() async throws {
        let agent = SMAppService.agent(plistName: APP.Agent.name)
        try agent.register()
        refreshAgentStatus()
    }

    func unregisterAgent() async throws {
        let agent = SMAppService.agent(plistName: APP.Agent.name)
        try await agent.unregister()
        refreshAgentStatus()
    }

    func startSkipper() throws {
        if agentStatus != .enabled {
            throw AppError.agentNotRegistered
        }
        try sendDataToAgent(messageID: 1, data: createConfigForAgent())
        DispatchQueue.main.async {
            self.agentRunning = true
            self.iconColor = .green
        }
    }

    func stopSkipper() throws {
        try sendDataToAgent(messageID: 0, data: Data())
        DispatchQueue.main.async {
            self.agentRunning = false
            self.iconColor = .gray
        }
    }

    private func sendDataToAgent(messageID: Int32, data: Data) throws {
        guard let serverPort = CFMessagePortCreateRemote(nil, APP.Agent.portName as CFString) else {
            throw AppError.agentNotRunning
        }
        let bytes: [UInt8] = data.bytes
        let data = CFDataCreate(nil, bytes, bytes.count)
        let sendResult = CFMessagePortSendRequest(serverPort, messageID, data, 1.0, 1.0, nil, nil);
        if sendResult != Int32(kCFMessagePortSuccess) {
            throw AppError.agentMessageFailed
        }
    }

    private func createConfigForAgent() throws -> Data {
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
        return try encoder.encode(config)
    }

}
