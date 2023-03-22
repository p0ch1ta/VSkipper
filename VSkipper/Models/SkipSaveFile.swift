//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import Foundation

struct SkipSaveFile: PickerSelectable {

    var name: String

    static var allCases: [SkipSaveFile] = []

    init?(rawValue: String) {
        self.rawValue = rawValue
        name = rawValue
    }

    var rawValue: String
}
