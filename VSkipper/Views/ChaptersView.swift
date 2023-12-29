//  Created by p0ch1ta on 06/05/2023 for project VSkipper

import SwiftUI

struct ChaptersView: View {

    @StateObject var chapterStore = ChapterStore()

    @State private var alert = false
    @State private var loading = false
    @State private var alertMessage = ""
    
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
                                Text("Series path")
                                Spacer()
                                Directory(path: $chapterStore.seriesPath, openInFinder: false, mode: .directory)
                                Button {
                                    Task {
                                        do {
                                            loading = true
                                            try await chapterStore.loadChapters()
                                        } catch {
                                            alertMessage = error.localizedDescription
                                            alert = true
                                        }
                                        loading = false
                                    }
                                } label: {
                                    Text("Load")
                                }
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Intro chapter")
                                Spacer()
                                if chapterStore.uniqueChapters.isEmpty {
                                    Text("No chapters found").foregroundColor(.gray)
                                } else {
                                    Picker(selection: $chapterStore.introChapterName, label: EmptyView()) {
                                        ForEach(chapterStore.uniqueChapters, id: \.self) { chapter in
                                            Text(chapter.name).tag(chapter.name)
                                        }
                                    }.fixedSize().disabled(chapterStore.introChapterDisabled)
                                }
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("No intro")
                                Spacer()
                                Toggle(isOn: $chapterStore.introChapterDisabled){}.toggleStyle(.checkbox)
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("Outro chapter")
                                Spacer()
                                if chapterStore.uniqueChapters.isEmpty {
                                    Text("No chapters found").foregroundColor(.gray)
                                } else {
                                    Picker(selection: $chapterStore.outroChapterName, label: EmptyView()) {
                                        ForEach(chapterStore.uniqueChapters, id: \.self) { chapter in
                                            Text(chapter.name).tag(chapter.name)
                                        }
                                    }.fixedSize().disabled(chapterStore.outroChapterDisabled)
                                }
                            }.padding(.vertical)
                            Divider()
                            HStack {
                                Text("No outro")
                                Spacer()
                                Toggle(isOn: $chapterStore.outroChapterDisabled){}.toggleStyle(.checkbox)
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
