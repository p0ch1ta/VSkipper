//  Created by p0ch1ta on 22/03/2023 for project VSkipper

import Foundation

enum VLCError: Error {
    case noData
    case decodingError
}

extension VLCError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return NSLocalizedString("No data received from VLC API", comment: "No data received from VLC API")
        case .decodingError:
            return NSLocalizedString("Error decoding data from VLC API", comment: "Error decoding data from VLC API")
        }
    }
}
