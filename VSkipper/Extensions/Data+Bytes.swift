//  Created by p0ch1ta on 24/03/2023 for project VSkipper

import Foundation

extension Data {
    var bytes: [UInt8] {
        var byteArray = [UInt8](repeating: 0, count: self.count)
        self.copyBytes(to: &byteArray, count: self.count)
        return byteArray
    }
}