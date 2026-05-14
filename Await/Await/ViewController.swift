//
//  ViewController.swift
//  Await
//
//  Created by Влад Шимченко on 9.05.26.
//

import UIKit

struct FooResult {
    let result: String
}

struct BarResult {
    let result: Int
}



class ViewController: UIViewController {

    private let network = Networking()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await qux()
        }

        Task {
            do {
                let coins = try await network.getCoinsData()
                coins.forEach { 
                    print($0.name)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getAsyncValue() async -> String {
        "Hello"
    }

    func foo() async -> FooResult {
        FooResult(result: "Hello")
    }

    func bar() async -> BarResult {
        BarResult(result: 23)
    }

    func qux() async {
        let foo = await foo()
        let bar = await bar()
        doSomething(foo, bar)
    }

    func doSomething(_ foo: FooResult, _ bar: BarResult) {
        print(foo.result)
        print(bar.result)
    }

    func getAsyncV() async {
        var x = 0

        for x in 0..<1000000000 {
            await Task.yield()
        }
    }

}



