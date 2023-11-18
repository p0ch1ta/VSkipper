//  Created by p0ch1ta on 21/03/2023 for project VSkipper

import Foundation

struct APP {
    
    struct UserDefaults {
        static let currentIntroFile = "currentIntroFile"
        static let currentOutroFile = "currentOutroFile"
        static let introDuration = "introDuration"
        static let outroDuration = "outroDuration"
        static let vlcPassword = "vlcPassword"
        static let vlcPort = "vlcPort"
        static let selectedSaveFile = "selectedSaveFile"
        static let skipOutroFull = "skipOutroFull"
    }

    struct Agent {
        static let name = "io.yokata.VSkipperAgent.plist"
        static let portName = "io.yokata.VSkipperAgent"
    }

    struct Placeholder {
        static let emptyPlaylistPath = "Path not selected"
        static let fileNotSelected = "File not selected"
        static let noFile = "No file"
    }

    struct FileName {
        static let config = "config.json"
        static let samples = "samples.json"
        static let dsStore = ".DS_Store"
        static let introSample = "intro-sample.m4a"
        static let outroSample = "outro-sample.m4a"
        static let introCut = "intro-cut.m4a"
        static let outroCut = "outro-cut.m4a"
        static let vlcAppName = "VLC.app/"
    }

    struct FileExtension {
        static let mkv = ".mkv"
        static let json = ".json"
        static let m4a = ".m4a"
    }

    struct PathName {
        static let config = "config"
        static let saves = "saves"
        static let samples = "samples"
        static let working = "working"
    }

    struct Path {
        static let vlcExecutable = "Contents/MacOS/VLC"
        static let ffprobeExecutable = "/usr/local/bin/ffprobe"
        static let ffmpegExecutable = "/usr/local/bin/ffmpeg"
    }

    struct VLC {
        static let url = "http://127.0.0.1"
        static let port = 8080
        static let statusPath = "/requests/status.xml"
    }

    struct Samples {
        static let duration = 3
    }

    struct Scan {
        static let minSimilarity = 0.80
        static let maxSampleTime = 60
    }

}
