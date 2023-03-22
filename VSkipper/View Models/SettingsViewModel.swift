//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import Foundation

@MainActor
class SettingsViewModel: ObservableObject {

    let defaults = UserDefaults.standard

    @Published var introDuration: Int = 0

    @Published var outroDuration: Int = 0

    @Published var introScanEnd: Int = 0

    @Published var outroScanStart: Int = 0

    @Published var vlcPort: Int = 8080

    @Published var vlcPassword: String = ""

    @Published var vlcExecutablePath: String = ""

    init() {
        introDuration = defaults.integer(forKey: SettingsKey.introDuration.rawValue)
        outroDuration = defaults.integer(forKey: SettingsKey.outroDuration.rawValue)
        introScanEnd = defaults.integer(forKey: SettingsKey.introScanEnd.rawValue)
        outroScanStart = defaults.integer(forKey: SettingsKey.outroScanStart.rawValue)
        vlcPort = defaults.integer(forKey: SettingsKey.vlcPort.rawValue)
        vlcPassword = defaults.string(forKey: SettingsKey.vlcPassword.rawValue) ?? ""
        vlcExecutablePath = defaults.string(forKey: SettingsKey.vlcExecutablePath.rawValue) ?? ""
    }

    func getIntroStartTime() throws {
        let vlcApi = VLCApi(port: vlcPort, password: vlcPassword)
        introDuration = try vlcApi.getCurrentTime()
    }

    func getOutroStartTime() throws {
        let vlcApi = VLCApi(port: vlcPort, password: vlcPassword)
        outroDuration = try vlcApi.getCurrentTime()
    }

    func calculateIntroDuration() throws {
        let vlcApi = VLCApi(port: vlcPort, password: vlcPassword)
        let introEndTime = try vlcApi.getCurrentTime()
        introDuration = introEndTime - introDuration
    }

    func calculateOutroDuration() throws {
        let vlcApi = VLCApi(port: vlcPort, password: vlcPassword)
        let outroEndTime = try vlcApi.getCurrentTime()
        outroDuration = outroEndTime - outroDuration
    }

    func getIntroScanEndTime() throws {
        let vlcApi = VLCApi(port: vlcPort, password: vlcPassword)
        introScanEnd = try vlcApi.getCurrentTime()
    }

    func getOutroScanStartTime() throws {
        let vlcApi = VLCApi(port: vlcPort, password: vlcPassword)
        outroScanStart = try vlcApi.getCurrentTime()
    }

    func save() throws {

        if !vlcExecutablePath.hasSuffix(APP.FileName.vlcAppName) {
            throw SettingsError.incorrectVlcPath
        }

        defaults.set(introDuration, forKey: SettingsKey.introDuration.rawValue)
        defaults.set(outroDuration, forKey: SettingsKey.outroDuration.rawValue)
        defaults.set(introScanEnd, forKey: SettingsKey.introScanEnd.rawValue)
        defaults.set(outroScanStart, forKey: SettingsKey.outroScanStart.rawValue)
        defaults.set(vlcPort, forKey: SettingsKey.vlcPort.rawValue)
        defaults.set(vlcPassword, forKey: SettingsKey.vlcPassword.rawValue)
        defaults.set(vlcExecutablePath, forKey: SettingsKey.vlcExecutablePath.rawValue)
    }

}
