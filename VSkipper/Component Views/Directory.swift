//  Created by p0ch1ta on 28/12/2023 for project VSkipper

import SwiftUI

struct Directory: View {
    
    @Binding var path: String
    
    var openInFinder = false

    var mode: PickerMode = .file

    var charactersLimit = 40

    @State private var popover = false

    var body: some View {
        HStack {
            Text(path.truncated(limit: charactersLimit, position: .middle))
                .foregroundColor(.gray)
                .onContinuousHover { phase in
                    switch phase {
                    case .active(_):
                        popover = true
                    case .ended:
                        popover = false
                    }
                }
                .popover(isPresented: $popover) {
                    Text(path)
                        .padding()
                }
            if mode != .none {
                Button {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = mode == .directory
                    panel.canChooseFiles = mode == .file
                    if !path.isEmpty {
                        panel.directoryURL = URL(fileURLWithPath: path)
                    }
                    if panel.runModal() == .OK {
                        path = panel.url?.path(percentEncoded: false) ?? ""
                    }
                } label: {
                    Image(systemName: "folder.fill")
                        .foregroundColor(.cyan)
                }
            }
            if openInFinder {
                Button {
                    NSWorkspace.shared.selectFile(path, inFileViewerRootedAtPath: "")
                } label: {
                    Image(systemName: "arrow.up.forward.app.fill")
                        .foregroundColor(.cyan)
                }
            }
        }
        
    }
}

#Preview {
    Directory(path: .constant("/dev/null"), openInFinder: true)
}
