//  Created by p0ch1ta on 22/03/2023 for project VSkipper

import Foundation

enum SamplesError: Error {
    case emptyInputPath
    case incorrectFileExtension
}

extension SamplesError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyInputPath:
            return NSLocalizedString("File path is empty", comment: "File path is empty")
        case .incorrectFileExtension:
            return NSLocalizedString("Incorrect file extension", comment: "Incorrect file extension")
        }
    }
}
