//  Created by p0ch1ta on 24/04/2023 for project VSkipper

import Foundation

@MainActor
class SampleStore: ObservableObject {

    @Published var samples: [Sample] = []

    @Published var newSample = Sample()

    func loadSamples() throws {
        samples = try SampleService.shared.getSamples()
    }

    func saveNewSample() async throws {
        newSample.fileExtension = try await FFMPEGService.shared.getAudioFormat(path: newSample.sourceFilePath)
        guard let samplePath = newSample.filePath else {
            throw SampleError.sampleFilePathResolveError
        }
        try await FFMPEGService.shared.extractSample(sourcePath: newSample.sourceFilePath, targetPath: samplePath, startTime: newSample.startTime, duration: APP.Samples.duration)
        samples.append(newSample)
        try SampleService.shared.saveSamples(samples: samples)
        newSample = Sample()
    }

    func removeSample(id: UUID) throws {
        let sample = samples.first(where: { $0.id == id })
        if let samplePath = sample?.filePath {
            try FileManager.default.removeItem(atPath: samplePath)
        }
        samples.removeAll(where: { $0.id == id })
        try SampleService.shared.saveSamples(samples: samples)
    }

}
