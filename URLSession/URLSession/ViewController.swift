//
//  ViewController.swift
//  URLSession
//
//  Created by admin1 on 23.01.23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRequest()
    }
    
    
    func dataRequest() {
        let request = URLRequest(url: URL(string: "https://api2.binance.com/api/v3/ticker/24hr")!)
        
        var dataTask = URLSession.shared.dataTask(with: request) { data, response , error in
            
            print(String(decoding: data!, as: UTF8.self))
            print(error ?? "нет ошибки")
        }
    }


}

