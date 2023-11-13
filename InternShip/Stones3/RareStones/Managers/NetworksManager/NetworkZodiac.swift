

import UIKit

protocol NetworkServicesZodiac {
    func getZodiacData(complition: @escaping (Result<Zodiac, Error>) -> Void)
    func getZodiacInId(id: String, complition: @escaping (Result<ZodiacID, Error>) -> Void)
}

enum Errors: Error {
    case invalidURL
    case invalideState
}

final class NetworkServicesZodiacImpl: NetworkServicesZodiac {
    private enum API {
        static let zodiac = "https://my-stone-collection.com/api/zodiac/"
        static let token = UserDefaults.standard.string(forKey: R.Strings.KeyUserDefaults.tokenKey)!
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func getZodiacData(complition: @escaping(Result<Zodiac, Error>) -> Void) {
        guard let url = URL(string: API.zodiac) else {
            complition(.failure(Errors.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let zodiac = try jsonDecoder.decode(Zodiac.self, from: data)
                    complition(.success(zodiac))
                } catch {
                    complition(.failure(Errors.invalideState))
                }
            case let (nil, .some(error)):
                complition(.failure(error))
            default: complition(.failure(Errors.invalideState))
            }
        }
        task.resume()
    }
    
    func getZodiacInId(id: String, complition: @escaping (Result<ZodiacID, Error>) -> Void) {
        guard let url = URL(string: "https://my-stone-collection.com/api/zodiac/\(id)/") else { complition(.failure(Errors.invalidURL))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let zodiac = try jsonDecoder.decode(ZodiacID.self, from: data)
                    complition(.success(zodiac))
                } catch {
                    complition(.failure(Errors.invalideState))
                }
            case let (nil, .some(error)):
                complition(.failure(error))
            default: complition(.failure(Errors.invalideState))
            }
        }
        task.resume()
    }
}
