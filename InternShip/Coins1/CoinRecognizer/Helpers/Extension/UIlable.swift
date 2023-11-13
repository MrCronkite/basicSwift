

import UIKit

extension UILabel {
    func replaceCount(with replacementNumber: Int) {
        var characters = Array("subtitle_chat".localized)
        
        for (index, character) in characters.enumerated() {
            if let digit = Int(String(character)), digit == 3 {

                characters[index] = Character(String(replacementNumber))
            }
        }
        
        let resultString = String(characters)
        self.text = resultString
    }
}
