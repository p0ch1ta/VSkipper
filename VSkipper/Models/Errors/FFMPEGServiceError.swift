//  Created by p0ch1ta on 28/05/2023 for project VSkipper

import Foundation

enum FFMPEGServiceError: Error {
    case noAudioFormatOutput
    case invalidDurationFormat
    case sampleExtractionFailed
    case noChaptersOutput
}

extension FFMPEGServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noAudioFormatOutput:
            return NSLocalizedString("No audio format output", comment: "No audio format output")
        case .sampleExtractionFailed:
            return NSLocalizedString("Sample extraction failed", comment: "Sample extraction failed")
        case .noChaptersOutput:
            return NSLocalizedString("No chapters output", comment: "No chapters output")
        case .invalidDurationFormat:
            return NSLocalizedString("Invalid duration format", comment: "Invalid duration format")
        }
    }
}
