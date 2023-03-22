//  Created by p0ch1ta on 22/03/2023 for project VSkipper

import Foundation

enum SettingsError: Error {
    case incorrectVlcPath
}

extension SettingsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .incorrectVlcPath:
            return NSLocalizedString("Incorrect VLC path", comment: "Incorrect VLC path")
        }
    }
}
