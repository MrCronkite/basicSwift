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
        
        ApiManager.shared.getUsers { users in
            print(users.count)
        }
    }
    
    
    func dataRequest() {
        var request = URLRequest(url: URL(string: "https://api.kucoin.com/api/v1/market/stats?symbol=BTC-USDT")!)
        request.allHTTPHeaderFields = ["authToken": "nil"]
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response , error in
            if let data = data, let coin = try? JSONDecoder().decode(Coin.self, from: data) {
                print(coin.data.sell)
                print(coin.data.symbol)
            }
        }
        dataTask.resume()
    }


}

