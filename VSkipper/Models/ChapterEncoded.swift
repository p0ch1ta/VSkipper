//  Created by p0ch1ta on 06/05/2023 for project VSkipper

import Foundation

struct ChapterEncodedList: Codable {
    let chapters: [ChapterEncoded]
}

struct ChapterEncoded: Codable {
    let start_time: String
    let end_time: String
    let tags: ChapterTagsEncoded

    func toChapter() -> Chapter {
        var startTime = 0
        var endTime = 0
        if let index = (start_time.range(of: ".")?.lowerBound) {
            startTime = Int(String(start_time.prefix(upTo: index))) ?? 0
        }
        if let index = (end_time.range(of: ".")?.lowerBound) {
            endTime = Int(String(end_time.prefix(upTo: index))) ?? 0
        }
        return Chapter(id: UUID(), name: tags.title, startTime: startTime, endTime: endTime)
    }
}

struct ChapterTagsEncoded: Codable {
    let title: String
}