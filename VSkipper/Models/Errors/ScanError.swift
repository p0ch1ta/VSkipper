//  Created by p0ch1ta on 21/03/2023 for project VSkipper

import Foundation

enum ScanError: Error {
    case failedToLoadIntroSample
    case failedToLoadOutroSample
    case playlistPathNotSelected
    case playlistPathInvalid
    case fingerprintComparisonFailed
    case noFilesToProcess
}

extension ScanError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToLoadIntroSample:
            return NSLocalizedString("Failed to load intro sample", comment: "Failed to load intro sample")
        case .failedToLoadOutroSample:
            return NSLocalizedString("Failed to load outro sample", comment: "Failed to load outro sample")
        case .playlistPathNotSelected:
            return NSLocalizedString("Playlist path not selected", comment: "Playlist path not selected")
        case .playlistPathInvalid:
            return NSLocalizedString("Playlist path invalid", comment: "Playlist path invalid")
        case .fingerprintComparisonFailed:
            return NSLocalizedString("Fingerprint comparison failed", comment: "Fingerprint comparison failed")
        case .noFilesToProcess:
            return NSLocalizedString("No files to process", comment: "No files to process")
        }
    }
}