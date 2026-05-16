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

    private let vm = GalleryViewModel()
    private let ls = LocalStorage()

    override func viewDidLoad() {
        super.viewDidLoad()

       // vm.getCoins()

        Task {
            do {
                 let userIds = [1, 2, 2, 3] // userId=2 дублируется — кэш должен слить запросы
                 let results = try await ls.loadDashboard(userIds: userIds)
                 results.forEach { print($0) }
             } catch FetchError.timeout {
                 print("❌ Timeout!")
             } catch {
                 print("❌ Error: \(error)")
             }
        }

//        Task {
//            await qux()
//        }
//
//        Task {
//            do {
//                let coins = try await network.getCoinsData()
//                coins.forEach { 
//                    print($0.name)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
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



