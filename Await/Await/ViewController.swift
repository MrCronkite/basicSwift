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

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            let value =  await getAsyncValue()
            await qux()
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
        print(foo)
        print(bar)
    }

}

