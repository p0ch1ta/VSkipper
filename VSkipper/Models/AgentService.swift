//  Created by p0ch1ta on 29/12/2023 for project VSkipper

import Foundation
import ServiceManagement

class AgentService {
    
    static let shared = AgentService()

    private init() {}
    
    func getAgentStatus() -> SMAppService.Status {
        let agent = SMAppService.agent(plistName: APP.Agent.name)
        return agent.status
    }
    
    func registerAgent() async throws {
        let agent = SMAppService.agent(plistName: APP.Agent.name)
        try agent.register()
    }

    func unregisterAgent() async throws {
        let agent = SMAppService.agent(plistName: APP.Agent.name)
        try await agent.unregister()
    }
    
    func sendDataToAgent(messageID: Int32, data: Data) throws {
        guard let serverPort = CFMessagePortCreateRemote(nil, APP.Agent.portName as CFString) else {
            throw AgentServiceError.agentNotRunning
        }
        let bytes: [UInt8] = data.bytes
        let data = CFDataCreate(nil, bytes, bytes.count)
        let sendResult = CFMessagePortSendRequest(serverPort, messageID, data, 1.0, 1.0, nil, nil);
        if sendResult != Int32(kCFMessagePortSuccess) {
            throw AgentServiceError.agentMessageFailed
        }
    }
    
}
