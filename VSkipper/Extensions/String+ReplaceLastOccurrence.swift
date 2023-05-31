//  Created by p0ch1ta on 30/05/2023 for project VSkipper

import Foundation

extension String {
    func replaceLastOccurrence(of: String, with: String) -> String {
        guard let range = self.range(of: of, options: .backwards) else {
            return self
        }
        return self.replacingCharacters(in: range, with: with)
    }
}