//  Created by p0ch1ta on 19/03/2023 for project VSkipper

import Foundation
import SwiftUI

extension String {

    func decodeHTMLSymbols() -> String? {
        guard let encodedData = data(using: .utf8) else {
            return nil
        }
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        guard let attributedString = try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil) else {
            return nil
        }
        return attributedString.string
    }

}
