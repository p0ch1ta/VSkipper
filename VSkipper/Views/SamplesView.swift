//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import SwiftUI

struct SamplesView: View {

    @EnvironmentObject var sampleStore: SampleStore

    @State private var alert = false
    @State private var alertMessage = ""

    @State private var buttonHidden = true
    @State private var durationButtonHidden = true
    @State private var scanFromTimeButtonHidden = true
    @State private var scanToTimeButtonHidden = true

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Group {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Sample file")
                                .fontWeight(.bold)
                            Spacer()
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("File path")
                            Spacer()
                            TextWithPopover(text: sampleStore.newSample.sourceFilePath)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Select file")
                            Spacer()
                            FilePicker(path: $sampleStore.newSample.sourceFilePath, mode: .file)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Series path")
                            Spacer()
                            TextWithPopover(text: sampleStore.newSample.targetPlaylistPath)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Select path")
                            Spacer()
                            FilePicker(path: $sampleStore.newSample.targetPlaylistPath, mode: .directory)
                        }.padding(.vertical)
                    }.padding(.horizontal)
                     .overlay(
                         RoundedRectangle(cornerRadius: 6)
                             .stroke(.gray, lineWidth: 1)
                             .opacity(0.15)
                     )
                }.padding(.bottom)

                VStack(spacing: 0) {
                    HStack {
                        Text("Sample settings")
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.vertical)
                    Divider()
                    Group {
                        HStack {
                            Text("Name")
                            Spacer()
                            TextField("Sample", text: $sampleStore.newSample.name)
                                .fixedSize()
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.trailing)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Type")
                            Spacer()
                            FixedPicker(selection: $sampleStore.newSample.type)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Start time")
                            Spacer()
                            if !buttonHidden {
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    Task {
                                        do {
                                            buttonHidden = true
                                            try await $sampleStore.newSample.getStartTimeFromVLC()
                                        } catch {
                                            alertMessage = error.localizedDescription
                                            alert = true
                                        }
                                    }
                                } label: {
                                    Text("Get time")
                                }
                            }
                            TextField("", value: $sampleStore.newSample.startTime, formatter: NumberFormatter())
                                .fixedSize()
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.trailing)
                        }.padding(.vertical)
                         .onContinuousHover { phase in
                             switch phase {
                             case .active(_):
                                 buttonHidden = false
                             case .ended:
                                 buttonHidden = true
                             }
                         }
                        Divider()
                        HStack {
                            Text("Duration")
                            Spacer()
                            if !durationButtonHidden {
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    Task {
                                        do {
                                            durationButtonHidden = true
                                            try await $sampleStore.newSample.getDurationStartTimeFromVLC()
                                        } catch {
                                            alertMessage = error.localizedDescription
                                            alert = true
                                        }
                                    }
                                } label: {
                                    Text("Get start time")
                                }
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    Task {
                                        do {
                                            durationButtonHidden = true
                                            try await $sampleStore.newSample.getDurationEndTimeFromVLCAndCalculate()
                                        } catch {
                                            alertMessage = error.localizedDescription
                                            alert = true
                                        }
                                    }
                                } label: {
                                    Text("Get end time & calculate")
                                }
                            }
                            TextField("", value: $sampleStore.newSample.duration, formatter: NumberFormatter())
                                .fixedSize()
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.trailing)
                        }.padding(.vertical)
                         .onContinuousHover { phase in
                             switch phase {
                             case .active(_):
                                 durationButtonHidden = false
                             case .ended:
                                 durationButtonHidden = true
                             }
                         }
                        Group {

                            Divider()
                            HStack {
                                Text("Scan from time")
                                Spacer()
                                if !scanFromTimeButtonHidden {
                                    Button {
                                        NSApp.keyWindow?.makeFirstResponder(nil)
                                        Task {
                                            do {
                                                scanFromTimeButtonHidden = true
                                                try await $sampleStore.newSample.getScanFromTimeFromVLC()
                                            } catch {
                                                alertMessage = error.localizedDescription
                                                alert = true
                                            }
                                        }
                                    } label: {
                                        Text("Get time")
                                    }
                                }
                                TextField("", value: $sampleStore.newSample.scanFrom, formatter: NumberFormatter())
                                    .fixedSize()
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.vertical, 2)
                                    .multilineTextAlignment(.trailing)
                            }.padding(.vertical)
                             .onContinuousHover { phase in
                                 switch phase {
                                 case .active(_):
                                     scanFromTimeButtonHidden = false
                                 case .ended:
                                     scanFromTimeButtonHidden = true
                                 }
                             }
                            Divider()
                            HStack {
                                Text("Scan to time")
                                Spacer()
                                if !scanToTimeButtonHidden {
                                    Button {
                                        NSApp.keyWindow?.makeFirstResponder(nil)
                                        Task {
                                            do {
                                                scanToTimeButtonHidden = true
                                                try await $sampleStore.newSample.getScanToTimeFromVLC()
                                            } catch {
                                                alertMessage = error.localizedDescription
                                                alert = true
                                            }
                                        }
                                    } label: {
                                        Text("Get time")
                                    }
                                }
                                TextField("", value: $sampleStore.newSample.scanTo, formatter: NumberFormatter())
                                    .fixedSize()
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.vertical, 2)
                                    .multilineTextAlignment(.trailing)
                            }.padding(.vertical)
                             .onContinuousHover { phase in
                                 switch phase {
                                 case .active(_):
                                     scanToTimeButtonHidden = false
                                 case .ended:
                                     scanToTimeButtonHidden = true
                                 }
                             }
                        }
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
                            try await sampleStore.saveNewSample()
                            NSApplication.shared.keyWindow?.close()
                        } catch {
                            alertMessage = error.localizedDescription
                            alert = true
                        }
                    }
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

struct SamplesView_Previews: PreviewProvider {
    static var previews: some View {
        SamplesView()
    }
}
