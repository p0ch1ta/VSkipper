//  Created by p0ch1ta on 29/12/2023 for project VSkipper

import Foundation

extension Array {
    func unique<T:Hashable>(by: (Element) -> T)  -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}
