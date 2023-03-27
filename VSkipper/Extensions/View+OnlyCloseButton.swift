//  Created by p0ch1ta on 27/03/2023 for project VSkipper

import SwiftUI

struct OnlyCloseButton: ViewModifier {
    func body(content: Content) -> some View {
        content.onAppear {
            DispatchQueue.main.async {
                NSApplication.shared.windows.forEach { window in
                    window.standardWindowButton(.zoomButton)?.isEnabled = false
                    window.standardWindowButton(.miniaturizeButton)?.isEnabled = false
                }
            }
        }
    }
}

extension View {
    func onlyCloseButton() -> some View {
        ModifiedContent(content: self, modifier: OnlyCloseButton())
    }
}