//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import Foundation

struct SkipConfig: Codable {
    let introDuration: Int
    let outroDuration: Int
    let vlcPort: Int
    let vlcPassword: String
    let entries: [SkipConfigEntry]
}

struct SkipConfigEntry: Codable {
    let name: String
    let introTime: Int
    let outroTime: Int
    let introDuration: Int
    let outroDuration: Int
}
