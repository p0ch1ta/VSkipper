//  Created by p0ch1ta on 28/12/2023 for project VSkipper

import Foundation
import SwiftUI

class SettingsStore: ObservableObject {
    
    @AppStorage(APP.UserDefaults.vlcPort)
    var vlcPort: Int = 8080
    
    @AppStorage(APP.UserDefaults.vlcPassword)
    var vlcPassword: String = ""
    
    @AppStorage(APP.UserDefaults.vlcExecutablePath)
    var vlcExecutablePath: String = "/Applications/"
    
    @AppStorage(APP.UserDefaults.skipOutroFull)
    var skipOutroFull: Bool = false
}
