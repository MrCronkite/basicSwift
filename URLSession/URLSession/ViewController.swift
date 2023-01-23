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
        let request = URLRequest(url: URL(string: "https://api.kucoin.com/api/v1/market/stats?symbol=BTC-USDT")!)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response , error in
            
            print(String(decoding: data!, as: UTF8.self))
            //print(error ?? "нет ошибки")
        }
        dataTask.resume()
    }


}

