//  Created by p0ch1ta on 29/12/2023 for project VSkipper

import Foundation

enum ChaptersError: Error {
    case emptyChapterPath
    case noChaptersSelected
}

extension ChaptersError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyChapterPath:
            return NSLocalizedString("Series path is not selected", comment: "Series path is not selected")
        case .noChaptersSelected:
            return NSLocalizedString("No chapters selected", comment: "No chapters selected")
        }
    }
}
