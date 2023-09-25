//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import SwiftUI

struct SettingsView: View {

    @StateObject private var settingsViewModel = SettingsViewModel()

    @State private var alert = false
    @State private var alertMessage = ""

    @State private var passwordHidden = true

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
                                Text("VLC executable")
                                Spacer()
                                TextWithPopover(text: settingsViewModel.vlcExecutablePath)
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Select app")
                                Spacer()
                                FilePicker(path: $settingsViewModel.vlcExecutablePath, mode: .file)
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("VLC port")
                                Spacer()
                                TextField("", value: $settingsViewModel.vlcPort, formatter: NumberFormatter())
                                    .fixedSize()
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.vertical, 2)
                                    .multilineTextAlignment(.trailing)
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("VLC password")
                                Spacer()
                                if passwordHidden {
                                    SecureField("", text: $settingsViewModel.vlcPassword)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(.vertical, 2)
                                        .multilineTextAlignment(.trailing)
                                } else {
                                    TextField("", text: $settingsViewModel.vlcPassword)
                                        .fixedSize()
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(.vertical, 2)
                                        .multilineTextAlignment(.trailing)
                                }
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Spacer()
                                Button {
                                    passwordHidden.toggle()
                                } label: {
                                    Text(passwordHidden ? "Show password" : "Hide password").frame(width: 186)
                                }
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
                Button {
                    do {
                        try settingsViewModel.save()
                        alertMessage = "Settings saved"
                    } catch {
                        alertMessage = error.localizedDescription
                    }
                    alert = true
                } label: {
                    Text("Save")
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
