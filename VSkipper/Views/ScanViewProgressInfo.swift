//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import SwiftUI

struct ScanViewProgressInfo: View {

    @StateObject var scanViewModel: ScanViewModel

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
                    ProgressView(value: Float(scanViewModel.filesProcessed),
                                 total: Float(scanViewModel.totalFiles == 0 ? 1 : scanViewModel.totalFiles),
                                 label: {
                                     Text(scanViewModel.getStatus().rawValue)
                    })
                }.padding(.vertical)
                Divider()
                Group {
                    HStack {
                        Text("Files")
                        Spacer()
                        Text("\(scanViewModel.filesProcessed)/\(scanViewModel.totalFiles)")
                            .foregroundColor(.gray)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Current file")
                        Spacer()
                        Text(scanViewModel.currentFilename).foregroundColor(.gray)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Similarity")
                        Spacer()
                        Text(scanViewModel.currentSimilarity).foregroundColor(.gray)
                    }.padding(.vertical)
                    Divider()
                    HStack {
                        Text("Iteration")
                        Spacer()
                        Text("\(scanViewModel.currentIteration)").foregroundColor(.gray)
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
        ScanViewProgressInfo(scanViewModel: ScanViewModel())
    }
}
