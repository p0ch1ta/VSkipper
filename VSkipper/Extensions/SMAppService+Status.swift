//  Created by p0ch1ta on 24/03/2023 for project VSkipper

import ServiceManagement

extension SMAppService.Status {
    var name: String {
        switch self {
        case .notRegistered:
            return "Not registered"
        case .enabled:
            return "Enabled"
        case .requiresApproval:
            return "Requires approval"
        case .notFound:
            return "Not found"
        @unknown default:
            return "Unknown"
        }
    }
}