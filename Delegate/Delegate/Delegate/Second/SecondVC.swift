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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.addTarget(self, action: #selector(getText), for: .touchUpInside)
    }
    
    
    @objc func getText() {
        print(textField.text)
    }
}
