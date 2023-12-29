//  Created by p0ch1ta on 06/05/2023 for project VSkipper

import Foundation

class ChapterStore: ObservableObject {

    @Published var seriesPath: String = ""
    @Published var chapters: [String: [Chapter]] = [:]
    
    var uniqueChapters: [Chapter] {
        chapters.values.flatMap { $0 }.unique { $0.name }
    }

    @Published var introChapterName: String = ""
    @Published var outroChapterName: String = ""
    @Published var introChapterDisabled: Bool = false
    @Published var outroChapterDisabled: Bool = false

    var pathName: String = ""

    func loadChapters() async throws {
        
        if seriesPath.isEmpty {
            throw ChaptersError.emptyChapterPath
        }
        
        DispatchQueue.main.async {
            self.chapters = [:]
            self.introChapterName = ""
            self.outroChapterName = ""
        }
        
        let url = URL(string: seriesPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        pathName = url.lastPathComponent
        let files = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)

        try await files.asyncForEach { file in
            if file.pathExtension == "mkv" {
                let chapters = try await FFMPEGService.shared.getChapters(path: file.path)
                DispatchQueue.main.async {
                    self.chapters[file.lastPathComponent] = chapters
                }
            }
        }
        if !uniqueChapters.isEmpty {
            DispatchQueue.main.async {
                self.introChapterName = self.uniqueChapters.first!.name
                self.outroChapterName = self.uniqueChapters.first!.name
            }
        }
    }

    func saveConfig() throws {
        
        if (introChapterName.isEmpty && outroChapterName.isEmpty) {
            throw ChaptersError.noChaptersSelected
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let applicationSupportUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let bundleID = Bundle.main.bundleIdentifier!

        let savesURL = applicationSupportUrl.appendingPathComponent("\(bundleID)/\(APP.PathName.saves)", isDirectory: true)


        if !FileManager.default.fileExists(atPath: savesURL.path(percentEncoded: false)) {
            try FileManager.default.createDirectory(atPath: savesURL.path(percentEncoded: false), withIntermediateDirectories: true, attributes: nil)
        }

        let file = savesURL.appendingPathComponent(pathName.lowercased().appending(APP.FileExtension.json))

        let configEntries = chapters.compactMap {key, value in
            let introTime = value.first(where: {$0.name == introChapterName && !introChapterDisabled})?.startTime ?? -2
            let outroTime = value.first(where: {$0.name == outroChapterName && !outroChapterDisabled})?.startTime ?? -2
            
            let introEndTime = value.first(where: {$0.name == introChapterName})?.endTime ?? -1
            let outroEndTime = value.first(where: {$0.name == outroChapterName})?.endTime ?? -1
            
            return ConfigEntry(name: key, introTime: introTime + 1, outroTime: outroTime + 1, introDuration: introEndTime - introTime - 1, outroDuration: outroEndTime - outroTime - 1)
        }

        let data = try encoder.encode(configEntries)

        try data.write(to: file)
    }

}
