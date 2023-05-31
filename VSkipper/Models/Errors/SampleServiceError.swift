//  Created by p0ch1ta on 22/03/2023 for project VSkipper

import Foundation

enum SampleServiceError: Error {
    case samplesDirectoryResolveError
}

extension SampleServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .samplesDirectoryResolveError:
            return NSLocalizedString("Samples directory resolve error", comment: "Samples directory resolve error")
        }
    }
}
