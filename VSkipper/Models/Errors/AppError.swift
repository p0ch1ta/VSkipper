//  Created by p0ch1ta on 24/03/2023 for project VSkipper

import Foundation

enum AppError: Error {
    case agentNotRunning
    case agentMessageFailed
    case agentNotRegistered
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .agentNotRunning:
            return NSLocalizedString("Agent is not running", comment: "Agent is not running")
        case .agentMessageFailed:
            return NSLocalizedString("Agent message failed", comment: "Agent message failed")
        case .agentNotRegistered:
            return NSLocalizedString("Agent is not enabled", comment: "Agent is not enabled")
        }
    }
}