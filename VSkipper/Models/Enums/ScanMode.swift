//  Created by p0ch1ta on 20/03/2023 for project VSkipper

enum ScanMode: String, PickerSelectable {
    case both = "Both"
    case intro = "Intro"
    case outro = "Outro"

    var name: String { self == .both ? "Intro and Outro" : self == .intro ? "Only intro" : "Only outro" }
}