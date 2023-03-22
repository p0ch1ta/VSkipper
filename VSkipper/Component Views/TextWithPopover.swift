//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import SwiftUI

struct TextWithPopover: View {

    var text: String

    var charactersLimit = 40

    @State private var popover = false

    var body: some View {
        Text(text.truncated(limit: charactersLimit, position: .middle))
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
                Text(text)
                    .padding()
            }
    }
}

struct TextWithPopover_Previews: PreviewProvider {
    static var previews: some View {
        TextWithPopover(text: "Test")
    }
}
