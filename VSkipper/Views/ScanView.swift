//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import SwiftUI

struct ScanView: View {

    //@StateObject var scanViewModel = ScanViewModel()

    @StateObject var scanStore = ScanStore()

    @State private var alert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Playlist")
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Playlist path")
                        Spacer()
                        TextWithPopover(text: scanStore.playlistPath)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Select path")
                        Spacer()
                        FilePicker(path: $scanStore.playlistPath, mode: .directory)
                            .disabled(scanStore.getStatus() == .processing)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Samples count")
                        Spacer()
                        Text("\(scanStore.samples.count)")
                    }.padding(.vertical)
                }.padding(.horizontal)
                 .overlay(
                     RoundedRectangle(cornerRadius: 6)
                         .stroke(.gray, lineWidth: 1)
                         .opacity(0.15)
                 )
                ScanViewProgressInfo(scanStore: scanStore)
                VStack(spacing: 0) {
                    HStack {
                        Text("Saved config info")
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.vertical)
                    Divider()
                    Group {
                        HStack {
                            Text("File directory")
                            Spacer()
                            TextWithPopover(text: scanStore.savesPath)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Spacer()
                            Button {
                                //NSWorkspace.shared.open()
                            } label: {
                                Text("Open in finder")
                            }.disabled(scanStore.savesPath.isEmpty)
                        }.padding(.vertical)
                    }
                }.padding(.horizontal)
                 .overlay(
                     RoundedRectangle(cornerRadius: 6)
                         .stroke(.gray, lineWidth: 1)
                         .opacity(0.15)
                 )
            }.padding()
            Spacer()
            Divider()
            HStack {
                Spacer()
                Button {
                    NSApplication.shared.keyWindow?.close()
                } label: {
                    Text("Close")
                }
                Button {
                    Task {
                        do {
                            try await scanStore.scanPlaylist()
                        } catch {
                            alertMessage = error.localizedDescription
                            alert = true
                        }
                    }
                } label: {
                    Text("Scan")
                }.keyboardShortcut(.defaultAction)
                 .disabled(scanStore.getStatus() == .processing)
                 .alert(alertMessage, isPresented: $alert, actions: {
                     Button("OK", role: .cancel) {
                         alert = false
                     }.keyboardShortcut(.defaultAction)
                 })
            }.padding()
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
