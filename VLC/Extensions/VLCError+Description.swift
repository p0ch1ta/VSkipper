//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import Foundation

extension VLCError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .decodingError:
            return "VLC API response could not be decoded."
        case .noData:
            return "VLC API request failed. No data received."
        }
    }
}