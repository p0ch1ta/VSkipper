//  Created by p0ch1ta on 18/03/2023 for project VSkipper

import SwiftUI

@main
struct VSkipperApp: App {

    @StateObject var sampleStore = SampleStore()
    
    @StateObject var saveFileStore = SaveFileStore()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(saveFileStore: saveFileStore)
        } label: {
            let image = NSImage(systemSymbolName: "forward.circle", accessibilityDescription: nil)!
            Image(nsImage: image.withMenuBarConfiguration(color: saveFileStore.saveFileActive ? .green : .gray)!)
        }
        Window("Settings", id: "settings") {
            SettingsView()
                .onlyCloseButton()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
        Window("Add sample", id: "sample") {
            SampleView()
                .environmentObject(sampleStore)
                .onlyCloseButton()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
        Window("Scan playlist", id: "scan") {
            ScanView()
                .onlyCloseButton()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
        Window("Start skipper", id: "skip") {
            SkipView(saveFileStore: saveFileStore)
                .onlyCloseButton()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
        Window("Samples list", id: "samplesList") {
            SamplesListView()
                .environmentObject(sampleStore)
                .onlyCloseButton()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
        Window("Chapters", id: "chapters") {
            ChaptersView()
                .onlyCloseButton()
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 600)
        }.windowResizability(.contentSize)
    }
}
