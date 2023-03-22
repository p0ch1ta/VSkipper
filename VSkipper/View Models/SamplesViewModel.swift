//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import Foundation

@MainActor
class SamplesViewModel: ObservableObject {

    let defaults = UserDefaults.standard

    var duration = APP.Samples.duration

    @Published var path: String = APP.Placeholder.fileNotSelected

    @Published var startTime = 0

    @Published var introPath = APP.Placeholder.noFile
    
    @Published var outroPath = APP.Placeholder.noFile
    
    @Published var sampleType = SampleType.intro

    var samplesDirectoryURL: URL

    init() {
        let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!

        let bundleID = Bundle.main.bundleIdentifier!

        samplesDirectoryURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.samples)", isDirectory: true)

        if !FileManager.default.fileExists(atPath: samplesDirectoryURL.path(percentEncoded: false)) {
            try! FileManager.default.createDirectory(atPath: samplesDirectoryURL.path(percentEncoded: false), withIntermediateDirectories: true, attributes: nil)
        }

        let introURL = samplesDirectoryURL.appendingPathComponent(SampleType.intro.rawValue.appending(APP.FileExtension.m4a))
        let outroURL = samplesDirectoryURL.appendingPathComponent(SampleType.outro.rawValue.appending(APP.FileExtension.m4a))

        if FileManager.default.fileExists(atPath: introURL.path(percentEncoded: false)) {
            introPath = introURL.path(percentEncoded: false)
        }
        if FileManager.default.fileExists(atPath: outroURL.path(percentEncoded: false)) {
            outroPath = outroURL.path(percentEncoded: false)
        }
    }

    func saveSample() throws {

        if path == APP.Placeholder.fileNotSelected {
            throw SamplesError.emptyInputPath
        }

        if !path.hasSuffix(APP.FileExtension.mkv) {
            throw SamplesError.incorrectFileExtension
        }

        let vlcPath = defaults.string(forKey: SettingsKey.vlcExecutablePath.rawValue) ?? ""
        let vlcShell = VLCShell(vlcExecutablePath: vlcPath.appending(APP.Path.vlcExecutable))

        let inputURL = URL(fileURLWithPath: path)
        let outputURL = samplesDirectoryURL.appendingPathComponent(sampleType.rawValue.appending(APP.FileExtension.m4a))

        try vlcShell.extractAudio(
            inputFileURL: inputURL,
            outputFileURL: outputURL,
            startTime: startTime,
            stopTime: startTime + duration)

        if sampleType == .intro {
            introPath = outputURL.path(percentEncoded: false)
        } else {
            outroPath = outputURL.path(percentEncoded: false)
        }
    }

    func getStartTime() throws {
        let vlcPort = defaults.integer(forKey: SettingsKey.vlcPort.rawValue)
        let vlcPassword = defaults.string(forKey: SettingsKey.vlcPassword.rawValue) ?? ""
        let vlcApi = VLCApi(port: vlcPort, password: vlcPassword)
        startTime = try vlcApi.getCurrentTime()
    }
    
}
