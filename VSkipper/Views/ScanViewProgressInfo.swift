//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import SwiftUI

struct ScanViewProgressInfo: View {

    //@StateObject var scanViewModel: ScanViewModel
    @StateObject var scanStore: ScanStore

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("Progress info")
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.vertical)
                Divider()
                HStack {
                    ProgressView(value: Float(scanStore.filesProcessed),
                                 total: Float(scanStore.totalFiles == 0 ? 1 : scanStore.totalFiles),
                                 label: {
                                     Text(scanStore.getStatus().rawValue)
                    })
                }.padding(.vertical)
                Divider()
                Group {
                    HStack {
                        Text("Files")
                        Spacer()
                        Text("\(scanStore.filesProcessed)/\(scanStore.totalFiles)")
                            .foregroundColor(.gray)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Current file")
                        Spacer()
                        Text(scanStore.currentFilename).foregroundColor(.gray)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Current sample")
                        Spacer()
                        Text(scanStore.currentSampleName).foregroundColor(.gray)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Similarity")
                        Spacer()
                        Text(scanStore.currentSimilarity).foregroundColor(.gray)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Iteration")
                        Spacer()
                        Text("\(scanStore.currentIteration)").foregroundColor(.gray)
                    }.padding(.vertical)
                }
            }.padding(.horizontal)
             .overlay(
                 RoundedRectangle(cornerRadius: 6)
                     .stroke(.gray, lineWidth: 1)
                     .opacity(0.15)
             )
        }.padding(.vertical)
    }
}

struct ScanViewProgressInfo_Previews: PreviewProvider {
    static var previews: some View {
        ScanViewProgressInfo(scanStore: ScanStore())
    }
}
