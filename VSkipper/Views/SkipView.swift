//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import SwiftUI

struct SkipView: View {

    @StateObject var appViewModel: AppViewModel

    @StateObject var saveFileStore = SaveFileStore()

    @State private var alert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Skip settings")
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Agent status")
                        Spacer()
                        Text(appViewModel.agentStatus.name).foregroundColor(.gray)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Spacer()
                        Button {
                            Task {
                                do {
                                    if appViewModel.agentStatus == .enabled {
                                        try await appViewModel.unregisterAgent()
                                    } else {
                                        try await appViewModel.registerAgent()
                                    }
                                } catch {
                                    alertMessage = error.localizedDescription
                                    alert = true
                                }
                            }
                        } label: {
                            Text(appViewModel.agentStatus != .enabled ? "Enable" : "Disable")
                        }
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Configuration")
                        Spacer()
                        Picker(selection: $saveFileStore.selectedSaveFile, label: EmptyView()) {
                            if saveFileStore.saveFiles.isEmpty {
                                Text("No configurations").tag("")
                            } else {
                                ForEach(saveFileStore.saveFiles, id: \.self) { sf in
                                    Text(sf.name).tag(sf.name)
                                }
                            }
                        }.frame(width: 300)
                         .task {
                             do {
                                 try saveFileStore.loadSaveFiles()
                             } catch {
                             }
                         }
                    }.padding(.vertical)
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
                    do {
                        try appViewModel.startSkipper(configData: saveFileStore.selectedSaveFile.getAgentConfigData())
                        NSApplication.shared.keyWindow?.close()
                    } catch {
                        alertMessage = error.localizedDescription
                        alert = true
                    }
                } label: {
                    Text("Start")
                }.keyboardShortcut(.defaultAction)
                 .alert(alertMessage, isPresented: $alert, actions: {
                     Button("OK", role: .cancel) {
                         alert = false
                     }.keyboardShortcut(.defaultAction)
                 })
            }.padding()
        }
    }
}

struct SkipView_Previews: PreviewProvider {
    static var previews: some View {
        SkipView(appViewModel: AppViewModel())
    }
}
