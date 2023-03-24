//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import Foundation

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        Data(self.utf8).base64EncodedString()
    }

}