//  Created by p0ch1ta on 24/04/2023 for project VSkipper

import SwiftUI

struct SamplesListView: View {

    @EnvironmentObject var sampleStore: SampleStore

    @Environment(\.openWindow) var openWindow

    @State private var selection: UUID?

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                VStack (spacing: 0) {
                    Table(sampleStore.samples, selection: $selection) {
                        TableColumn("Name", value: \.name)
                        TableColumn("Type", value: \.type.name)
                    }.task {
                         do {
                             try sampleStore.loadSamples()
                         } catch {
                         }
                     }
                    Divider()
                    Section {
                        HStack {
                            Button {
                                openWindow(id: "sample")
                                DispatchQueue.main.async {
                                    NSApplication.shared.activate(ignoringOtherApps: true)
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.gray)
                            }.padding(.leading, 8)
                            Divider()
                                .frame(height: 16)
                                .padding(.vertical, 4)
                            Button {
                                if let selection = selection {
                                    do {
                                        try sampleStore.removeSample(id: selection)
                                        self.selection = nil
                                    } catch {
                                    }
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }
                }.overlay(
                     RoundedRectangle(cornerRadius: 6)
                         .stroke(.gray, lineWidth: 1)
                         .opacity(0.15)
                 )
            }.padding()
             .frame(height: 300)
            if let selection = selection {
                let selectedSample = sampleStore.samples.first(where: { $0.id == selection })
                VStack(spacing: 0) {
                    Group {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text(selectedSample?.name ?? "")
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Play sound")
                                Spacer()
                                Button {
                                    do {
                                        try $sampleStore.samples.first(where: { $0.id == selection })?.playSound()
                                    } catch {
                                        print(error)
                                    }
                                } label: {
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.cyan)
                                }
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Type")
                                Spacer()
                                Text(sampleStore.samples.first(where: { $0.id == selection })?.type.name ?? "")
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Duration")
                                Spacer()
                                Text("\(sampleStore.samples.first(where: { $0.id == selection })?.duration ?? -1)")
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Series path")
                                Spacer()
                                TextWithPopover(text: sampleStore.samples.first(where: { $0.id == selection })?.fileExtension ?? "")
                            }.padding(.vertical)
                        }.padding(.horizontal)
                         .overlay(
                             RoundedRectangle(cornerRadius: 6)
                                 .stroke(.gray, lineWidth: 1)
                                 .opacity(0.15)
                         )
                    }.padding(.bottom)
                }.padding()
            }
        }
    }
}

struct SamplesListView_Previews: PreviewProvider {
    static var previews: some View {
        SamplesListView()
    }
}
