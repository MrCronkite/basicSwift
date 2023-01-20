//
//  SecondVC.swift
//  Delegate
//
//  Created by admin1 on 19.01.23.
//

import UIKit


protocol SecondScrenDelegate: AnyObject {
    func getString(text: String?)
}

class SecondVC: UIViewController {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: SecondScrenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.addTarget(self, action: #selector(getText), for: .touchUpInside)
        textField.delegate = self
    }
    
    
    @objc func getText() {
        delegate?.getString(text: textField.text)
       
    }
}


extension SecondVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return true
    }
}
