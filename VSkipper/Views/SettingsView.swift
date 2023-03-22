//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import SwiftUI

struct SettingsView: View {

    @StateObject private var settingsViewModel = SettingsViewModel()

    @State private var alert = false
    @State private var alertMessage = ""

    @State private var passwordHidden = true

    @State private var introButtonHidden = true
    @State private var outroButtonHidden = true

    @State private var introEndButtonHidden = true
    @State private var outroStartButtonHidden = true

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Group {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Skip settings")
                                .fontWeight(.bold)
                            Spacer()
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Intro duration")
                            Spacer()
                            if !introButtonHidden {
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    do {
                                        try settingsViewModel.getIntroStartTime()
                                    } catch {
                                        alertMessage = error.localizedDescription
                                        alert = true
                                    }
                                } label: {
                                    Text("Get start time")
                                }
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    do {
                                        try settingsViewModel.calculateIntroDuration()
                                    } catch {
                                        alertMessage = error.localizedDescription
                                        alert = true
                                    }
                                } label: {
                                    Text("Get end time & calculate")
                                }
                            }
                            TextField("", value: $settingsViewModel.introDuration, formatter: NumberFormatter())
                                .fixedSize()
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.trailing)
                        }.padding(.vertical)
                         .onContinuousHover { phase in
                             switch phase {
                             case .active(_):
                                 introButtonHidden = false
                             case .ended:
                                 introButtonHidden = true
                             }
                         }
                        Divider()
                        HStack {
                            Text("Outro duration")
                            Spacer()
                            if !outroButtonHidden {
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    do {
                                        try settingsViewModel.getOutroStartTime()
                                    } catch {
                                        alertMessage = error.localizedDescription
                                        alert = true
                                    }
                                } label: {
                                    Text("Get start time")
                                }
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    do {
                                        try settingsViewModel.calculateOutroDuration()
                                    } catch {
                                        alertMessage = error.localizedDescription
                                        alert = true
                                    }
                                } label: {
                                    Text("Get end time & calculate")
                                }
                            }
                            TextField("", value: $settingsViewModel.outroDuration, formatter: NumberFormatter())
                                .fixedSize()
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.trailing)
                        }.padding(.vertical)
                         .onContinuousHover { phase in
                             switch phase {
                             case .active(_):
                                 outroButtonHidden = false
                             case .ended:
                                 outroButtonHidden = true
                             }
                         }
                    }.padding(.horizontal)
                     .overlay(
                         RoundedRectangle(cornerRadius: 6)
                             .stroke(.gray, lineWidth: 1)
                             .opacity(0.15)
                     )
                }.padding(.bottom)
                Group {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Scan settings")
                                .fontWeight(.bold)
                            Spacer()
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Intro scan end time")
                            Spacer()
                            if !introEndButtonHidden {
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    do {
                                        try settingsViewModel.getIntroScanEndTime()
                                    } catch {
                                        alertMessage = error.localizedDescription
                                        alert = true
                                    }
                                } label: {
                                    Text("Get time")
                                }
                            }
                            TextField("", value: $settingsViewModel.introScanEnd, formatter: NumberFormatter())
                                .fixedSize()
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.trailing)
                        }.padding(.vertical)
                         .onContinuousHover { phase in
                             switch phase {
                             case .active(_):
                                 introEndButtonHidden = false
                             case .ended:
                                 introEndButtonHidden = true
                             }
                         }
                        Divider()
                        HStack {
                            Text("Outro scan start time")
                            Spacer()
                            if !outroStartButtonHidden {
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    do {
                                        try settingsViewModel.getOutroScanStartTime()
                                    } catch {
                                        alertMessage = error.localizedDescription
                                        alert = true
                                    }
                                } label: {
                                    Text("Get time")
                                }
                            }
                            TextField("", value: $settingsViewModel.outroScanStart, formatter: NumberFormatter())
                                .fixedSize()
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.trailing)
                        }.padding(.vertical)
                         .onContinuousHover { phase in
                             switch phase {
                             case .active(_):
                                 outroStartButtonHidden = false
                             case .ended:
                                 outroStartButtonHidden = true
                             }
                         }
                    }.padding(.horizontal)
                     .overlay(
                         RoundedRectangle(cornerRadius: 6)
                             .stroke(.gray, lineWidth: 1)
                             .opacity(0.15)
                     )
                }.padding(.bottom)
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
