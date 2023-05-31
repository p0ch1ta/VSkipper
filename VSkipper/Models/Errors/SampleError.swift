//  Created by p0ch1ta on 28/05/2023 for project VSkipper

import Foundation

enum SampleError: Error {
    case sampleFilePathResolveError
}

extension SampleError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .sampleFilePathResolveError:
            return NSLocalizedString("Sample file path resolve error", comment: "Sample file path resolve error")
        }
    }
}