//  Created by p0ch1ta on 22/03/2023 for project VSkipper

import Foundation

enum SavesServiceError: Error {
    case savesDirectoryResolveError
}

extension SavesServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .savesDirectoryResolveError:
            return NSLocalizedString("Saves directory resolve error", comment: "Saves directory resolve error")
        }
    }
}
