//
//  ViewController.swift
//  Keychain
//
//  Created by admin1 on 16.07.23.
//

import UIKit

class ViewController: UIViewController {
    
    var keychain: Keychain = KeychainImpl()
    let dataString = "Hello world"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        keychainGO()
    }
}

extension ViewController {
    
    func keychainGO() {
        do {
            try keychain.save(key: .jeyData, data: dataString)
            let loadedData = try keychain.load(key: .jeyData)
            let loadedString = String(data: loadedData!, encoding: .utf8)
            print(loadedString as Any)
            try keychain.delete(key: .jeyData)
        } catch {
            print(error)
        }
    }
}

