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

    private let network = Network()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await qux()
            let coins = await network.getCoins()
            coins.forEach { print($0.name) }
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

final class Network {

    private enum API {
        static let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    }

    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder

    init(
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }

    func getCoins() async -> [Coin] {
        return await withCheckedContinuation { continuation in
            urlSession.dataTask(
                with: URLRequest(url: URL(string: API.url)!)
            ) { [weak self] data, response, error in
                guard let data, let self else { return }

                let result: [Coin] = try! self.jsonDecoder.decode([Coin].self, from: data)
                continuation.resume(returning: result)
            }.resume()
        }
    }
}

struct Coin: Decodable {
    let id: String
    let name: String
}

