//  Created by p0ch1ta on 27/05/2023 for project VSkipper

import SwiftUI

@MainActor
extension Binding where Value == Sample {
    func getStartTimeFromVLC() async throws {
        try await wrappedValue.getStartTimeFromVLC()
    }
    func getScanFromTimeFromVLC() async throws {
        try await wrappedValue.getScanFromTimeFromVLC()
    }
    func getScanToTimeFromVLC() async throws {
        try await wrappedValue.getScanToTimeFromVLC()
    }
    func getDurationStartTimeFromVLC() async throws {
        try await wrappedValue.getDurationStartTimeFromVLC()
    }
    func getDurationEndTimeFromVLCAndCalculate() async throws {
        try await wrappedValue.getDurationEndTimeFromVLCAndCalculate()
    }
    func playSound() throws {
        try wrappedValue.playSound()
    }
}


