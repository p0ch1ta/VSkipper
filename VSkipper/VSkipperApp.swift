//  Created by p0ch1ta on 18/03/2023 for project VSkipper

import SwiftUI

@main
struct VSkipperApp: App {

    @StateObject var appViewModel = AppViewModel()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(appViewModel: appViewModel)
        } label: {
            let image = NSImage(systemSymbolName: "forward.circle", accessibilityDescription: nil)!
            Image(nsImage: image.withMenuBarConfiguration(color: appViewModel.iconColor)!)
        }
        Window("Settings", id: "settings") {
            SettingsView()
                .onAppear {
                    DispatchQueue.main.async {
                        NSApplication.shared.windows.forEach { window in
                            window.standardWindowButton(.zoomButton)?.isEnabled = false
                            window.standardWindowButton(.miniaturizeButton)?.isEnabled = false
                        }
                        NSApplication.shared.activate(ignoringOtherApps: true)
                    }
                }.fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
        Window("Select samples", id: "samples") {
            SamplesView()
                .onAppear {
                    DispatchQueue.main.async {
                        NSApplication.shared.windows.forEach { window in
                            window.standardWindowButton(.zoomButton)?.isEnabled = false
                            window.standardWindowButton(.miniaturizeButton)?.isEnabled = false
                        }
                        NSApplication.shared.activate(ignoringOtherApps: true)
                    }
                }.fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
        Window("Scan playlist", id: "scan") {
            ScanView()
                .onAppear {
                    DispatchQueue.main.async {
                        NSApplication.shared.windows.forEach { window in
                            window.standardWindowButton(.zoomButton)?.isEnabled = false
                            window.standardWindowButton(.miniaturizeButton)?.isEnabled = false
                        }
                        NSApplication.shared.activate(ignoringOtherApps: true)
                    }
                }.fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
        Window("Start skipper", id: "skip") {
            SkipView(appViewModel: appViewModel)
                .onAppear {
                    DispatchQueue.main.async {
                        NSApplication.shared.windows.forEach { window in
                            window.standardWindowButton(.zoomButton)?.isEnabled = false
                            window.standardWindowButton(.miniaturizeButton)?.isEnabled = false
                        }
                        NSApplication.shared.activate(ignoringOtherApps: true)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
    }
}
