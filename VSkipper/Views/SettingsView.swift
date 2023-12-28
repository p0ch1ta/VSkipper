//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import SwiftUI

struct SettingsView: View {
    
    @StateObject var settingsStore = SettingsStore()

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Group {
                    VStack(spacing: 0) {
                        HStack {
                            Text("VLC settings")
                                .fontWeight(.bold)
                            Spacer()
                        }.padding(.vertical)
                        Divider()
                        Group {
                            HStack {
                                Text("Skip outro to the end")
                                Spacer()
                                Toggle(isOn: $settingsStore.skipOutroFull){}.toggleStyle(.checkbox)
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("VLC application")
                                Spacer()
                                Directory(path: $settingsStore.vlcExecutablePath, openInFinder: false, mode: .file)
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("VLC port")
                                Spacer()
                                TextField("", value: $settingsStore.vlcPort, formatter: NumberFormatter())
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.vertical, 2)
                                    .multilineTextAlignment(.trailing)
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("VLC password")
                                Spacer()
                                PasswordField(password: $settingsStore.vlcPassword)
                            }.padding(.vertical)
                        }
                    }.padding(.horizontal)
                     .overlay(
                         RoundedRectangle(cornerRadius: 6)
                             .stroke(.gray, lineWidth: 1)
                             .opacity(0.15)
                     )
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
            }.padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
