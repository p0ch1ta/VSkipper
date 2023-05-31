//  Created by p0ch1ta on 21/03/2023 for project VSkipper

import Foundation

enum SampleType: String, PickerSelectable, Codable {
    case intro = "intro-sample"
    case outro = "outro-sample"

    var name: String { self == .intro ? "Intro" : "Outro" }
}
