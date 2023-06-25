//  Created by p0ch1ta on 25/06/2023 for project VSkipper

import Foundation

@MainActor
class SaveFileStore: ObservableObject {

    @UserDefault(key: APP.UserDefaults.selectedSaveFile, defaultValue: "")
    var selectedSaveFileName: String

    @Published var selectedSaveFile: SaveFile = SaveFile(id: UUID(), name: "", path: "") {
        didSet {
            selectedSaveFileName = selectedSaveFile.name
        }
    }

    @Published var saveFiles: [SaveFile] = []

    func loadSaveFiles() throws {
        saveFiles = try SaveFileService.shared.getSaveFiles()
        selectedSaveFile = saveFiles.first(where: { $0.name == selectedSaveFileName }) ?? SaveFile(id: UUID(), name: "", path: "")
    }
}
