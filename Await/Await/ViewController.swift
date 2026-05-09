//
//  ViewController.swift
//  Await
//
//  Created by Влад Шимченко on 9.05.26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            let value = await getAsyncValue()
            print(value)
        }

    }

    func getAsyncValue() async -> String {
        "Hello"
    }

}

