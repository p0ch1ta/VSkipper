//  Created by p0ch1ta on 18/03/2023 for project VSkipper

import Foundation
import os

//Written into log show --predicate 'senderImagePath CONTAINS "VSkipperAgent"' --info --debug
let logger = Logger(subsystem: "io.yokata.VSkipperAgent", category: "main")

//logger.info("Test")

let userURL = FileManager.default.homeDirectoryForCurrentUser

let defaults = UserDefaults.standard

let configURL = userURL.appendingPathComponent("Library/Containers/io.yokata.VSkipper/Data/Library/Application Support/io.yokata.VSkipper/config", isDirectory: true)

let fileURL = configURL.appendingPathComponent("config.json")

if FileManager.default.fileExists(atPath: fileURL.path(percentEncoded: false)) {

    guard let fileData = try? Data(contentsOf: fileURL) else {
        exit(0)
    }

    let decoder = JSONDecoder()

    guard let config = try? decoder.decode(SkipConfig.self, from: fileData) else {
        exit(0)
    }

    let introDuration = config.introDuration
    let outroDuration = config.outroDuration
    let vlcPort = config.vlcPort
    let vlcPassword = config.vlcPassword

    let files = config.entries

    let vlcApi = VLCApi(port: vlcPort, password: vlcPassword)

    let savedPlaylistFile = defaults.string(forKey: "playlistFile")
    guard let currentPlaylistFile = try? vlcApi.getCurrentFileName() else {
        exit(0)
    }

    let sessionStatusString = defaults.string(forKey: "sessionStatus") ?? ""
    let sessionStatus =  SkipSessionStatus(rawValue: sessionStatusString) ?? SkipSessionStatus.stopped

    if currentPlaylistFile != savedPlaylistFile {

        defaults.set(currentPlaylistFile, forKey: "playlistFile")
        defaults.set(SkipSessionStatus.intro.rawValue, forKey: "sessionStatus")

        print("New file: \(currentPlaylistFile), status changed to intro")
    } else {
        guard let file = files.first(where: { $0.name == currentPlaylistFile }) else {
            exit(0)
        }
        guard let currentTime = try? vlcApi.getCurrentTime() else {
            exit(0)
        }
        if sessionStatus == .intro {
            let skipTime = file.introTime
            if skipTime > 0 {
                print("Status: intro, VLC time: \(currentTime)s, skip at: \(skipTime)")
                if (skipTime...(skipTime + 1)).contains(currentTime) {
                    vlcApi.skipForward(seconds: introDuration)
                    defaults.set(SkipSessionStatus.outro.rawValue, forKey: "sessionStatus")
                    print("Status changed: outro, VLC time: \(currentTime)s, skip at: \(skipTime)")
                }
            } else {
                defaults.set(SkipSessionStatus.outro.rawValue, forKey: "sessionStatus")
                print("Status changed: outro, VLC time: \(currentTime)s, no skip time")
            }
        }
        if sessionStatus == .outro {
            let skipTime = file.outroTime
            if skipTime > 0 {
                print("Status: outro, VLC time: \(currentTime)s, skip at: \(skipTime)")
                if (skipTime...(skipTime + 1)).contains(currentTime) {
                    vlcApi.skipForward(seconds: outroDuration)
                    defaults.set(SkipSessionStatus.idle.rawValue, forKey: "sessionStatus")
                    print("Status changed: idle, VLC time: \(currentTime)s, skip at: \(skipTime)")
                }
            } else {
                defaults.set(SkipSessionStatus.idle.rawValue, forKey: "sessionStatus")
                print("Status changed: idle, VLC time: \(currentTime)s, no skip time")
            }
        }
    }

}

