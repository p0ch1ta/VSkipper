//  Created by p0ch1ta on 24/03/2023 for project VSkipper

import Foundation
import os

class AgentState {

    let logger = Logger(subsystem: "io.yokata.VSkipperAgent", category: "main")

    var type: AgentStateType = .idle

    var currentFilename: String = ""
    var skipStatus: SkipStatus = .idle

    var introDuration: Int = 0
    var outroDuration: Int = 0
    var vlcPort: Int = 0
    var vlcPassword: String = ""
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
        introDuration = config.introDuration
        outroDuration = config.outroDuration
        vlcPort = config.vlcPort
        vlcPassword = config.vlcPassword
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
                if skipTime > 0 {
                    logger.debug("Status: intro, VLC time: \(time)s, skip at: \(skipTime)s")
                    if (skipTime...(skipTime + 1)).contains(time) {
                        vlcApi.skipForward(seconds: introDuration)
                        skipStatus = .outro
                        logger.debug("Status changed: outro, VLC time: \(time)s, skip at: \(skipTime)")
                    }
                } else {
                    skipStatus = .outro
                    logger.debug("Status changed: outro, VLC time: \(time)s, no skip time")
                }
            }
            if skipStatus == .outro {
                let skipTime = file.outroTime
                if skipTime > 0 {
                    logger.debug("Status: outro, VLC time: \(time)s, skip at: \(skipTime)")
                    if (skipTime...(skipTime + 1)).contains(time) {
                        vlcApi.skipForward(seconds: outroDuration)
                        skipStatus = .idle
                        logger.debug("Status changed: idle, VLC time: \(time)s, skip at: \(skipTime)")
                    }
                } else {
                    skipStatus = .idle
                    logger.debug("Status changed: idle, VLC time: \(time)s, no skip time")
                }
            }
        }
    }

}
