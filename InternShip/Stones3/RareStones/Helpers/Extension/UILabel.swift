

import UIKit

extension UILabel {
    func greyColor() {
        self.textColor = R.Colors.textColor
    }
    
    func replaceNumberThree(with replacementNumber: Int) {
        var characters = Array("helper_subtitle".localized)
        
        for (index, character) in characters.enumerated() {
            if let digit = Int(String(character)), digit == 3 {

                characters[index] = Character(String(replacementNumber))
            }
        }
        
        let resultString = String(characters)
        self.text = resultString
    }
}
