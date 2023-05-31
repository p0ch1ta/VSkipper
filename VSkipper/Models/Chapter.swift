//  Created by p0ch1ta on 06/05/2023 for project VSkipper

import Foundation

struct Chapter: Identifiable, Hashable {
    let id: UUID
    let name: String
    let startTime: Int
    let endTime: Int
}
