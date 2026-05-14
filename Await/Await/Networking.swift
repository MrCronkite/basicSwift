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


    func getCoinsData() async throws -> [Coin] {

        guard let url = URL(string: API.url)
        else {
            throw APIError.invalidUrl
        }

        let (data, response) = try await urlSession.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode
        else {
            throw APIError.responseFailure
        }

        do {
            return try jsonDecoder.decode([Coin].self, from: data)
        } catch {
            throw APIError.encorectDecoding
        }

    }

}
