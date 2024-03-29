//  Created by p0ch1ta on 24/03/2023 for project VSkipper

import Foundation
import os

class AgentState {

    let logger = Logger(subsystem: "io.yokata.VSkipperAgent", category: "main")

    var type: AgentStateType = .idle

    var currentFilename: String = ""
    var skipStatus: SkipStatus = .idle

    var vlcPort: Int = 0
    var vlcPassword: String = ""
    var skipOutroFull: Bool = false
    var configEntries: [SkipConfigEntry] = []

    func updateState(type: AgentStateType, config: Data) {
        logger.debug("State will change to \(type.description, privacy: .public)")
        if type == .idle {
            self.type = type
            return
        }
        let stringData = String(decoding: config, as: UTF8.self)
        logger.debug("Data received: \(stringData, privacy: .public)")
        let decoder = JSONDecoder()
        guard let config = try? decoder.decode(SkipConfig.self, from: config) else {
            logger.warning("Failed to decode config")
            return
        }
        vlcPort = config.vlcPort
        vlcPassword = config.vlcPassword
        skipOutroFull = config.skipOutroFull
        configEntries = config.entries
        self.type = type
    }

    func checkForSkip() {
        if type == .idle {
            return
        }
        let vlcApi = VLCApi(port: vlcPort, password: vlcPassword)
        guard let (time, filename) = try? vlcApi.getCurrentTimeWithFilename() else {
            logger.warning("Failed to get data from VLC API")
            return
        }
        if currentFilename != filename {
            currentFilename = filename
            skipStatus = .intro

            logger.debug("New file: \(self.currentFilename, privacy: .public), status changed to intro")
        } else {
            guard let file = configEntries.first(where: { $0.name == currentFilename }) else {
                logger.error("File not found in config file. File: \(self.currentFilename, privacy: .public)")
                return
            }
            if skipStatus == .intro {
                let skipTime = file.introTime
                if skipTime > -1 {
                    logger.debug("Status: intro, VLC time: \(time)s, skip at: \(skipTime)s")
                    if (skipTime...(skipTime + 1)).contains(time) {
                        vlcApi.skipForward(seconds: file.introDuration)
                        skipStatus = .outro
                        logger.debug("Status changed: outro (skipped \(file.introDuration)s), VLC time: \(time)s, skip at: \(skipTime)")
                    }
                } else {
                    skipStatus = .outro
                    logger.debug("Status changed: outro, VLC time: \(time)s, no skip time")
                }
            }
            if skipStatus == .outro {
                let skipTime = file.outroTime
                if skipTime > -1 {
                    logger.debug("Status: outro, VLC time: \(time)s, skip at: \(skipTime)")
                    if (skipTime...(skipTime + 1)).contains(time) {
                        if skipOutroFull {
                            vlcApi.playNext()
                        } else {
                            vlcApi.skipForward(seconds: file.outroDuration)
                        }
                        skipStatus = .idle
                        logger.debug("Status changed: idle (skipped \(file.outroDuration)s), VLC time: \(time)s, skip at: \(skipTime)")
                    }
                } else {
                    skipStatus = .idle
                    logger.debug("Status changed: idle, VLC time: \(time)s, no skip time")
                }
            }
        }
    }

}
