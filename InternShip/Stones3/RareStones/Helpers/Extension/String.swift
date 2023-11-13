

import UIKit

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func remove$() -> String {
        let cleanedString = self.replacingOccurrences(of: "[\\$,+\\s]", with: "", options: .regularExpression)
        return cleanedString
    }
}
