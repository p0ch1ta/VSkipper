//  Created by p0ch1ta on 27/05/2023 for project VSkipper

import Foundation

enum VLCServiceError: Error {
    case invalidURL
    case decodingError
}

extension VLCServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .decodingError:
            return NSLocalizedString("Decoding error", comment: "Decoding error")
        }
    }
}