//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import SwiftUI

struct SkipView: View {

    @StateObject var appViewModel: AppViewModel

    @State private var alert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Skip settings")
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Configuration")
                        Spacer()
                        if appViewModel.selectedSaveFile.rawValue.isEmpty {
                            Text("No configurations").foregroundColor(.gray)
                        } else {
                            FixedPicker(selection: $appViewModel.selectedSaveFile)
                        }
                    }.padding(.vertical)
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
                    Task {
                        do {
                            try await appViewModel.startAgent()
                            NSApplication.shared.keyWindow?.close()
                        } catch {
                            alertMessage = error.localizedDescription
                            alert = true
                        }
                    }
                } label: {
                    Text("Start")
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

struct SkipView_Previews: PreviewProvider {
    static var previews: some View {
        SkipView(appViewModel: AppViewModel())
    }
}
