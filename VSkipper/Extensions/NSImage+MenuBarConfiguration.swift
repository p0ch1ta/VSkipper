//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import SwiftUI

extension NSImage {

    func withMenuBarConfiguration(color: NSColor) -> NSImage? {
        let configuration = NSImage.SymbolConfiguration(pointSize: 16, weight: .light)
                                   .applying(.init(paletteColors: [color]))
        return withSymbolConfiguration(configuration)
    }

}