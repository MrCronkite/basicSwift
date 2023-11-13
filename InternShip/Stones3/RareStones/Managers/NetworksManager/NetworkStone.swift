

import UIKit
import Alamofire
import Moya

protocol NetworkStone {
    func getStoneById(id: String, complition: @escaping(Result<RockID, Error>) -> Void)
    func getStones(complition: @escaping(Result<Rocks, Error>) -> Void)
    func getStonesByTag(tag: String, complition: @escaping(Result<RockTags, Error>) -> Void)
    func makePostRequestWashList(id: Int, complition: @escaping (Result<String, Error>) -> Void)
    func getWashList(complition: @escaping(Result<Wishlist, Error>) -> Void)
    func deleteStoneFromWishList(id: Int, complition: @escaping (Result<String, Error>) -> Void)
}

final class NetworkStoneImpl: NetworkStone {
    private enum API {
        static let rock = "https://my-stone-collection.com/api/rocks/"
        static let token = UserDefaults.standard.string(forKey: R.Strings.KeyUserDefaults.tokenKey)!
        static let wishlist = "https://my-stone-collection.com/api/rocks/wishlist/"
        static let rareRock = "https://my-stone-collection.com/api/rocks/?tags=1"
        static let healingRock = "https://my-stone-collection.com/api/rocks/?tags=2"
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func getStoneById(id: String, complition: @escaping (Result<RockID, Error>) -> Void) {
        guard let url = URL(string: "https://my-stone-collection.com/api/rocks/\(id)/") else { complition(.failure(Errors.invalidURL))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let rock = try jsonDecoder.decode(RockID.self, from: data)
                    complition(.success(rock))
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
    
    func getStones(complition: @escaping (Result<Rocks, Error>) -> Void) {
//        guard let url = URL(string: "https://my-stone-collection.com/api/rocks/") else {
//            complition(.failure(Errors.invalidURL))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "accept")
//        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
//
//        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
//            switch (data, error) {
//            case let (.some(data), nil):
//                do {
//                    let rock = try jsonDecoder.decode(Rocks.self, from: data)
//                    complition(.success(rock))
//                } catch {
//                    complition(.failure(Errors.invalideState))
//                }
//            case let (nil, .some(error)):
//                complition(.failure(error))
//            default: complition(.failure(Errors.invalideState))
//            }
//        }
//        task.resume()
//        let baseURL = "https://my-stone-collection.com/api/rocks/"
//           let limit = 170 // Ваш лимит
//           let offset = 0 // Ваш сдвиг, если необходимо
//
//           let parameters: [String: Any] = ["limit": limit, "offset": offset]
//
//           AF.request(baseURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: HTTPHeaders(["Authorization": "Token \(API.token)", "Accept": "application/json"]))
//               .responseDecodable(of: Rocks.self) { response in
//                   switch response {
//                   case .success(let rocks):
//                       print(rocks)
//                       complition(.success(rocks))
//                   case .failure(let error):
//                       complition(.failure(error))
//                   }
//               }
    }
    
    func getStonesByTag(tag: String, complition: @escaping (Result<RockTags, Error>) -> Void) {
        guard let url = URL(string: "https://my-stone-collection.com/api/rocks/?tags=\(tag)") else { complition(.failure(Errors.invalidURL))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let rock = try jsonDecoder.decode(RockTags.self, from: data)
                    complition(.success(rock))
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
    
    func makePostRequestWashList(id: Int, complition: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: API.wishlist) else {
            complition(.failure(Errors.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let jsonData: [String: Any] = ["stone": id]
        
        let requestBody = try! JSONSerialization.data(withJSONObject: jsonData)
        request.httpBody = requestBody
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            switch (data , error) {
            case (.some(_), nil):
                guard let response = response as? HTTPURLResponse else {
                    complition(.failure(Errors.invalideState))
                    return
                }
                complition(.success("Response status code: \(response.statusCode)"))
            case let (nil, .some(error)):
                complition(.failure(error))
            default: complition(.failure(Errors.invalideState))
            }
        }
        task.resume()
    }
    
    func getWashList(complition: @escaping (Result<Wishlist, Error>) -> Void) {
        guard let url = URL(string: API.wishlist) else {
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
                    let wishList = try jsonDecoder.decode(Wishlist.self, from: data)
                    complition(.success(wishList))
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
    
    func deleteStoneFromWishList(id: Int, complition: @escaping (Result<String, Error>) -> Void) {
        let urlString = "https://my-stone-collection.com/api/rocks/\(id)/remove-from-wishlist/"
        
        guard let url = URL(string: urlString) else {
            complition(.failure(Errors.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            switch (data, error) {
            case (.some(_), nil):
                guard let response = response as? HTTPURLResponse else {
                    complition(.failure(Errors.invalideState))
                    return
                }
                complition(.success("Response status code: \(response.statusCode)"))
            case let (nil, .some(error)):
                complition(.failure(error))
            default: complition(.failure(Errors.invalideState))
            }
        }
        task.resume()
    }
}
