

import UIKit

protocol RegistredUser {
    func registerUser(username: String, password: String, complition: @escaping (Result<UserToken, Error>) -> Void)
    func loginUser(username: String, password: String, complition: @escaping (Result<UserToken, Error>) -> Void)
}

final class RegistredUserImpl: RegistredUser {
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func loginUser(username: String, password: String, complition: @escaping (Result<UserToken, Error>) -> Void) {
        guard let url = URL(string: "https://my-stone-collection.com/api/auth/login/") else {
            complition(.failure(Errors.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        let requestBody = try! JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let data = try jsonDecoder.decode(UserToken.self, from: data)
                    complition(.success(data))
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
    
    func registerUser(username: String, password: String, complition: @escaping (Result<UserToken, Error>) -> Void) {
        guard let url = URL(string: "https://my-stone-collection.com/api/auth/sign-up/") else {
            complition(.failure(Errors.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        let requestBody = try! JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let data = try jsonDecoder.decode(UserToken.self, from: data)
                    complition(.success(data))
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

