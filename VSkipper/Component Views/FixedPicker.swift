//  Created by p0ch1ta on 20/03/2023 for project VSkipper

import SwiftUI

struct FixedPicker<E: PickerSelectable>: View where E.AllCases == [E] {

    @Binding var selection: E

    var body: some View {
        Picker(selection: $selection, label: EmptyView()) {
            ForEach(E.allCases, id: \.self) { value in
                Text(value.name).tag(value)
            }
        }.fixedSize()
    }
}

struct FixedPicker_Previews: PreviewProvider {

    private enum PreviewSelection: String, PickerSelectable {
        case one = "First case"
        case two = "Second case"

        var name: String { self == .one ? "First case" : "Second case" }
    }

    @State static private var sel = PreviewSelection.one

    static var previews: some View {
        FixedPicker(selection: $sel)
    }
}
