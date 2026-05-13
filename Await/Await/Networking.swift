//
//  Networking.swift
//  Await
//
//  Created by Влад Шимченко on 12.05.26.
//

import Foundation


struct Coin: Decodable {
    let id: String
    let name: String
}

public enum APIError: Error {
    case invalidUrl
    case encorectDecoding
    case responseFailure
    case unowned

    var errorDescription: String {
        switch self {
        case .encorectDecoding: return ""
        case .invalidUrl: return ""
        case .unowned: return ""
        case .responseFailure: return ""
        }
    }
}

final class Networking {

    private let jsonDecoder: JSONDecoder
    private let urlSession: URLSession

    private enum API {
        static let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    }

    init(jsonDecoder: JSONDecoder = .init(), urlSession: URLSession = .shared) {
        self.jsonDecoder = jsonDecoder
        self.urlSession = urlSession
    }


    func getCoinsData(completion: @escaping (Result<[Coin], Error>) -> Void) {

        guard let url = URL(string: API.url)
        else {
            DispatchQueue.main.async {
                completion(.failure(APIError.invalidUrl))
            }
            return
        }

        urlSession.dataTask(
            with: url
        ) { [weak self] data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(APIError.unowned))
                }
                return
            }

            guard let HTTPURLResponse = response as? HTTPURLResponse,
                  200...299 ~= HTTPURLResponse.statusCode
            else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.responseFailure))
                }
                return
            }

            guard let data, let self 
            else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.unowned))
                }
                return
            }

            do {
                let coins = try jsonDecoder.decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIError.unowned))
                }
                return
            }
        }.resume()

    }

}
