//  Created by p0ch1ta on 20/03/2023 for project VSkipper

protocol PickerSelectable: CaseIterable, Equatable, Hashable, RawRepresentable where RawValue == String {
    var name: String { get }
}