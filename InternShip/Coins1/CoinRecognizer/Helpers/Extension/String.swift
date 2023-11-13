

import UIKit

extension String {
    mutating func removeWhiteSpace() -> String {
        if self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self = ""
        }
        return self
    }
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func replacingCurrentYear() -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        
        var updatedString = self
        if let range = updatedString.range(of: "Present") {
            updatedString.replaceSubrange(range, with: String(currentYear))
        }
        
        if let range = updatedString.range(of: "present") {
            updatedString.replaceSubrange(range, with: String(currentYear))
        }
        
        return updatedString
    }
    
    func lastWordsAfterComma() -> String? {
        let components = self.components(separatedBy: ",")
        if let lastWord = components.last?.trimmingCharacters(in: .whitespaces) {
            return lastWord
        }
        return nil
    }
}
