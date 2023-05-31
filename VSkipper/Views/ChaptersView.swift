//  Created by p0ch1ta on 06/05/2023 for project VSkipper

import SwiftUI

struct ChaptersView: View {

    @StateObject var chapterStore = ChapterStore()

    @State private var alert = false
    @State private var loading = false
    @State private var alertMessage = ""
    @State private var path = ""
    @State private var selection = ""

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Group {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Chapters")
                                    .fontWeight(.bold)
                                Spacer()
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Path")
                                Spacer()
                                TextWithPopover(text: path)
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Select path")
                                Spacer()
                                Button {
                                    let panel = NSOpenPanel()
                                    panel.allowsMultipleSelection = false
                                    panel.canChooseDirectories = true
                                    if panel.runModal() == .OK {
                                        let path = panel.url?.path(percentEncoded: false) ?? ""
                                        Task {
                                            do {
                                                loading = true
                                                try await chapterStore.loadChapters(path: path)
                                                self.path = path
                                            } catch {
                                                alertMessage = error.localizedDescription
                                                alert = true
                                            }
                                            loading = false
                                        }
                                    }
                                } label: {
                                    Image(systemName: "folder.fill")
                                        .foregroundColor(.cyan)
                                }
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Intro chapter")
                                Spacer()
                                Picker(selection: $chapterStore.introChapterName, label: EmptyView()) {
                                    if chapterStore.chapters.isEmpty {
                                        Text("No chapters found").tag("")
                                    } else {
                                        ForEach(chapterStore.uniqueChapters, id: \.self) { chapter in
                                            Text(chapter.name).tag(chapter.name)
                                        }
                                    }
                                }.fixedSize()
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Outro chapter")
                                Spacer()
                                Picker(selection: $chapterStore.outroChapterName, label: EmptyView()) {
                                    if chapterStore.chapters.isEmpty {
                                        Text("No chapters found").tag("")
                                    } else {
                                        ForEach(chapterStore.uniqueChapters, id: \.self) { chapter in
                                            Text(chapter.name).tag(chapter.name)
                                        }
                                    }
                                }.fixedSize()
                            }.padding(.vertical)
                        }.padding(.horizontal)
                         .overlay(
                             RoundedRectangle(cornerRadius: 6)
                                 .stroke(.gray, lineWidth: 1)
                                 .opacity(0.15)
                         )
                    }.padding(.bottom)
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
                            try chapterStore.saveConfig()
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

            if loading {
                ZStack {
                    Color(.black).opacity(0.5)
                                 .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect()
                }
            }
        }
    }
}

struct ChaptersView_Previews: PreviewProvider {
    static var previews: some View {
        ChaptersView()
    }
}
