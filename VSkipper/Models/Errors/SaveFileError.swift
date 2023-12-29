//  Created by p0ch1ta on 29/12/2023 for project VSkipper

import Foundation

enum SaveFileError: Error {
    case noSaveFileSelected
}

extension SaveFileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noSaveFileSelected:
            return NSLocalizedString("No configuration selected", comment: "No configuration selected")
        }
    }
}
