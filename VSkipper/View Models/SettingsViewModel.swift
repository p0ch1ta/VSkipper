//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import Foundation

@MainActor
class SettingsViewModel: ObservableObject {

    let defaults = UserDefaults.standard

    @Published var vlcPort: Int = 8080

    @Published var vlcPassword: String = ""

    @Published var vlcExecutablePath: String = ""

    init() {
        vlcPort = defaults.integer(forKey: SettingsKey.vlcPort.rawValue)
        vlcPassword = defaults.string(forKey: SettingsKey.vlcPassword.rawValue) ?? ""
        vlcExecutablePath = defaults.string(forKey: SettingsKey.vlcExecutablePath.rawValue) ?? ""
    }

    func save() throws {

        if !vlcExecutablePath.hasSuffix(APP.FileName.vlcAppName) {
            throw SettingsError.incorrectVlcPath
        }
        defaults.set(vlcPort, forKey: SettingsKey.vlcPort.rawValue)
        defaults.set(vlcPassword, forKey: SettingsKey.vlcPassword.rawValue)
        defaults.set(vlcExecutablePath, forKey: SettingsKey.vlcExecutablePath.rawValue)
    }

}
