//  Created by p0ch1ta on 25/06/2023 for project VSkipper

import Foundation

@MainActor
class SaveFileStore: ObservableObject {

    @UserDefault(key: APP.UserDefaults.selectedSaveFile, defaultValue: "")
    var selectedSaveFileName: String

    @Published var saveFiles: [SaveFile] = []
    
    @Published var saveFileActive: Bool = false
    @Published var search: String = ""
    @Published var selectedSaveFileId: UUID?

    func loadSaveFiles() throws {
        search = ""
        saveFiles = try SaveFileService.shared.getSaveFiles()
        selectedSaveFileId = saveFiles.first(where: { $0.name == selectedSaveFileName })?.id
    }
    
    func updateSaveFiles() throws {
        selectedSaveFileId = nil
        saveFiles = try SaveFileService.shared.getSaveFiles()
        saveFiles = saveFiles.filter { search.isEmpty ? true : $0.name.lowercased().contains(search.lowercased()) }
    }
    
    func removeSelectedSaveFile() throws {
        let file = saveFiles.first(where: { $0.id == selectedSaveFileId })
        if let filePath = file?.path {
            try FileManager.default.removeItem(atPath: filePath)
        }
        saveFiles.removeAll(where: { $0.id == selectedSaveFileId })
        selectedSaveFileId = nil
    }
    
    func sendSaveFileToAgent() throws {
        if AgentService.shared.getAgentStatus() != .enabled {
            throw AgentServiceError.agentNotRegistered
        }
        if let selectedSaveFile = saveFiles.first(where: { $0.id == selectedSaveFileId }) {
            try AgentService.shared.sendDataToAgent(messageID: 1, data: selectedSaveFile.getAgentConfigData())
            selectedSaveFileName = selectedSaveFile.name
            saveFileActive = true
        } else {
            throw SaveFileError.noSaveFileSelected
        }
    }
    
    func removeSaveFileFromAgent() throws {
        try AgentService.shared.sendDataToAgent(messageID: 0, data: Data())
        saveFileActive = false
    }
}
