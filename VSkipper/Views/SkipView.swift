//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import SwiftUI

struct SkipView: View {

    @StateObject var saveFileStore: SaveFileStore

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
                        Text(AgentService.shared.getAgentStatus().name).foregroundColor(.gray)
                        Button {
                            Task {
                                do {
                                    if AgentService.shared.getAgentStatus() == .enabled {
                                        try await AgentService.shared.unregisterAgent()
                                    } else {
                                        try await AgentService.shared.registerAgent()
                                    }
                                } catch {
                                    DispatchQueue.main.async {
                                        alertMessage = error.localizedDescription
                                        alert = true
                                    }
                                }
                            }
                        } label: {
                            Text(AgentService.shared.getAgentStatus() != .enabled ? "Enable" : "Disable")
                        }
                    }.padding(.vertical)
                }.padding(.horizontal)
                 .overlay(
                     RoundedRectangle(cornerRadius: 6)
                         .stroke(.gray, lineWidth: 1)
                         .opacity(0.15)
                 )
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Search")
                            Spacer()
                            TextField("Name", text: $saveFileStore.search)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: saveFileStore.search) { _ in
                                    do {
                                        try saveFileStore.updateSaveFiles()
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
                }.padding(.top)
                VStack(spacing: 0) {
                    VStack (spacing: 0) {
                        Table(saveFileStore.saveFiles, selection: $saveFileStore.selectedSaveFileId) {
                            TableColumn("Name", value: \.name)
                        }
                        Divider()
                        Section {
                            HStack {
                                Button {
                                    if saveFileStore.selectedSaveFileId != nil {
                                        do {
                                            try saveFileStore.removeSelectedSaveFile()
                                        } catch {
                                            alertMessage = error.localizedDescription
                                            alert = true
                                        }
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.leading, 8)
                                .contentShape(Rectangle())
                                .buttonStyle(.plain)
                                Divider()
                                    .frame(height: 16)
                                    .padding(.vertical, 4)
                                Spacer()
                            }
                        }
                    }.overlay(
                         RoundedRectangle(cornerRadius: 6)
                             .stroke(.gray, lineWidth: 1)
                             .opacity(0.15)
                     )
                }.padding(.top)
                .frame(height: 300)
                if let selection = saveFileStore.selectedSaveFileId {
                    let selectedFile = saveFileStore.saveFiles.first(where: { $0.id == saveFileStore.selectedSaveFileId })
                    VStack(spacing: 0) {
                        Group {
                            VStack(spacing: 0) {
                                HStack {
                                    Text("Selected series configuration")
                                        .fontWeight(.bold)
                                    Spacer()
                                }.padding(.vertical)
                                Divider()
                                HStack {
                                    Text("Name")
                                    Spacer()
                                    Text(selectedFile?.name ?? "")
                                }.padding(.vertical)
                                Divider()
                                HStack {
                                    Text("Series path")
                                    Spacer()
                                    Directory(path: .constant(saveFileStore.saveFiles.first(where: { $0.id == selection })?.path ?? ""), openInFinder: true, mode: .none)
                                }.padding(.vertical)
                            }.padding(.horizontal)
                             .overlay(
                                 RoundedRectangle(cornerRadius: 6)
                                     .stroke(.gray, lineWidth: 1)
                                     .opacity(0.15)
                             )
                        }.padding(.bottom)
                    }.padding(.top)
                }
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
                        try saveFileStore.sendSaveFileToAgent()
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
        SkipView(saveFileStore: SaveFileStore())
    }
}
