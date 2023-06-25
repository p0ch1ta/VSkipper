//  Created by p0ch1ta on 21/03/2023 for project VSkipper

import Foundation
import SwiftUI
import ServiceManagement

class AppViewModel: ObservableObject {

    private let defaults = UserDefaults.standard

    @Published var iconColor: NSColor = .gray

    @Published var agentRunning: Bool = false

    @Published var agentStatus: SMAppService.Status = .notFound

    let savesURL: URL

    init() {
        let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleID = Bundle.main.bundleIdentifier!

        savesURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.saves)", isDirectory: true)

        refreshAgentStatus()
    }

    func refreshAgentStatus() {
        let agent = SMAppService.agent(plistName: APP.Agent.name)
        DispatchQueue.main.async {
            self.agentStatus = agent.status
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

    func startSkipper(configData: Data) throws {
        if agentStatus != .enabled {
            throw AppError.agentNotRegistered
        }
        try sendDataToAgent(messageID: 1, data: configData)
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

}
