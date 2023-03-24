//  Created by p0ch1ta on 24/03/2023 for project VSkipper

import Foundation

enum AgentStateType: Int32 {
    case running = 1
    case idle = 0

    var description: String {
        switch self {
        case .running:
            return "Running"
        case .idle:
            return "Idle"
        }
    }
}
