

import UIKit

protocol NetworkArticles {
    func getArticlesStones(complition: @escaping(Result<ArticleStone, Error>) -> Void)
    func getArticlesStonesPinned(complition: @escaping(Result<ArticlePinned, Error>) -> Void)
    func getArticlesById(id: String, complition: @escaping(Result<ArticleByID, Error>) -> Void)
}

final class NetworkArticlesImpl: NetworkArticles {
    private enum API {
        static let article = "https://my-stone-collection.com/api/articles/"
        static let articleRecent = "https://my-stone-collection.com/api/articles/recent/"
        static let token = UserDefaults.standard.string(forKey: R.Strings.KeyUserDefaults.tokenKey) ?? ""
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func getArticlesStones(complition: @escaping (Result<ArticleStone, Error>) -> Void) {
        guard let url = URL(string: API.article) else {
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
                    let rock = try jsonDecoder.decode(ArticleStone.self, from: data)
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
    
    func getArticlesStonesPinned(complition: @escaping (Result<ArticlePinned, Error>) -> Void) {
        guard let url = URL(string: API.articleRecent) else {
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
                    let rock = try jsonDecoder.decode(ArticlePinned.self, from: data)
                    complition(.success(rock))
                } catch {
                    print(error)
                    complition(.failure(Errors.invalideState))
                }
            case let (nil, .some(error)):
                complition(.failure(error))
            default: complition(.failure(Errors.invalideState))
            }
        }
        task.resume()
    }
    
    func getArticlesById(id: String, complition: @escaping(Result<ArticleByID, Error>) -> Void) {
        guard let url = URL(string: "https://my-stone-collection.com/api/articles/\(id)/") else { complition(.failure(Errors.invalidURL))
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let rock = try jsonDecoder.decode(ArticleByID.self, from: data)
                    complition(.success(rock))
                } catch {
                    print(error)
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
