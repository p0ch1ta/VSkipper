//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import SwiftUI

struct SamplesView: View {

    @StateObject var samplesViewModel = SamplesViewModel()

    @State private var alert = false
    @State private var alertMessage = ""

    @State private var buttonHidden = true

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Group {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Sample")
                                .fontWeight(.bold)
                            Spacer()
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("File path")
                            Spacer()
                            TextWithPopover(text: samplesViewModel.path)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Select file")
                            Spacer()
                            FilePicker(path: $samplesViewModel.path, mode: .file)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Start time")
                            Spacer()
                            if !buttonHidden {
                                Button {
                                    NSApp.keyWindow?.makeFirstResponder(nil)
                                    do {
                                        try samplesViewModel.getStartTime()
                                    } catch {
                                        alertMessage = error.localizedDescription
                                        alert = true
                                    }
                                } label: {
                                    Text("Get time")
                                }
                            }
                            TextField("", value: $samplesViewModel.startTime, formatter: NumberFormatter())
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
                            Text("Type")
                            Spacer()
                            FixedPicker(selection: $samplesViewModel.sampleType)
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
                        Text("Sample files")
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.vertical)
                    Divider()
                    Group {
                        HStack {
                            Text("Intro sample path")
                            Spacer()
                            TextWithPopover(text: samplesViewModel.introPath)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Text("Outro sample path")
                            Spacer()
                            TextWithPopover(text: samplesViewModel.outroPath)
                        }.padding(.vertical)
                        Divider()
                        HStack {
                            Spacer()
                            Button {
                                NSWorkspace.shared.open(samplesViewModel.samplesDirectoryURL)
                            } label: {
                                Text("Open in finder")
                            }
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
                    do {
                        try samplesViewModel.saveSample()
                        alertMessage = "Saved"
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

struct SamplesView_Previews: PreviewProvider {
    static var previews: some View {
        SamplesView()
    }
}
