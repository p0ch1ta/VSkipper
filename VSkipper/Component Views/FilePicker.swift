//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import SwiftUI

struct FilePicker: View {

    @Binding var path: String

    var mode: FilePickerMode = .file

    var body: some View {
        Button {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = mode == .directory
            panel.canChooseFiles = mode == .file
            if panel.runModal() == .OK {
                path = panel.url?.path(percentEncoded: false) ?? ""
            }
        } label: {
            Image(systemName: "folder.fill")
                .foregroundColor(.cyan)
        }
    }
}

struct FilePicker_Previews: PreviewProvider {

    @State static private var path = ""

    static var previews: some View {
        FilePicker(path: $path)
    }
}
