//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import SwiftUI

struct MenuBarView: View {

    @Environment(\.openWindow) var openWindow

    @StateObject var saveFileStore: SaveFileStore

    @State private var alert = false
    @State private var alertMessage = ""

    var body: some View {
        Button {
            openWindow(id: "skip")
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
                do {
                    try saveFileStore.loadSaveFiles()
                } catch {
                    print(error)
                }
            }
        } label: {
            Text(saveFileStore.saveFileActive ? "Skipper is running" : "Start skipper")
        }.disabled(saveFileStore.saveFileActive)
        if saveFileStore.saveFileActive {
            Divider()
            Button {
                do {
                    try saveFileStore.removeSaveFileFromAgent()
                } catch {
                    alertMessage = error.localizedDescription
                    alert = true
                }
            } label: {
                Text("Stop skipper")
            }.alert(alertMessage, isPresented: $alert, actions: {
                Button("OK", role: .cancel) { alert = false }.keyboardShortcut(.defaultAction)
            })
        }
        Divider()
        Button {
            openWindow(id: "samplesList")
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        } label: {
            Text("Samples list")
        }
        Button {
            openWindow(id: "chapters")
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        } label: {
            Text("Chapters")
        }
        Button {
            openWindow(id: "scan")
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        } label: {
            Text("Scan playlist")
        }
        Button {
            openWindow(id: "settings")
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        } label: {
            Text("Settings")
        }
        Divider()
        Button {
            do {
                try saveFileStore.removeSaveFileFromAgent()
            } catch {
                alertMessage = error.localizedDescription
                alert = true
            }
            NSApplication.shared.terminate(self)
        } label: {
            Text("Quit")
        }
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView(saveFileStore: SaveFileStore())
    }
}
