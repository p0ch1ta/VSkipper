//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import Foundation

struct SaveFile: Identifiable, Hashable {
    let id: UUID
    var name: String = ""
    var path: String = ""

    func getAgentConfigData() throws -> Data {
        let defaults = UserDefaults.standard
        let vlcPort = defaults.integer(forKey: APP.UserDefaults.vlcPort)
        let vlcPassword = defaults.string(forKey: APP.UserDefaults.vlcPassword) ?? ""

        let JSONDecoder = JSONDecoder()

        let fileData = try Data(contentsOf: URL(fileURLWithPath: path))

        let entries = try JSONDecoder.decode([SkipConfigEntry].self, from: fileData)

        let config = SkipConfig(vlcPort: vlcPort,
                                vlcPassword: vlcPassword,
                                entries: entries)

        let encoder = JSONEncoder()
        return try encoder.encode(config)
    }
}
