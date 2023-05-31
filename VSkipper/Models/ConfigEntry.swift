//  Created by p0ch1ta on 29/05/2023 for project VSkipper

import Foundation

struct ConfigEntry: Codable {
    var name: String
    var introTime: Int
    var outroTime: Int
    var introDuration: Int
    var outroDuration: Int
}
