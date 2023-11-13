

import UIKit

protocol NetworkCamera {
    func sendImageData(image: Data, complition: @escaping (Result<StonePhoto, Error>) -> Void)
    func getClassificationHistory(complition: @escaping(Result<History, Error>) -> Void)
}

final class NetworkClassificationImpl: NetworkCamera {
    private enum API {
        static let classification = "https://my-stone-collection.com/api/classification/"
        static let history = "https://my-stone-collection.com/api/classification/history/"
        static let token = UserDefaults.standard.string(forKey: R.Strings.KeyUserDefaults.tokenKey)!
    }
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func sendImageData(image: Data, complition: @escaping (Result<StonePhoto, Error>) -> Void) {
        guard let url = URL(string: API.classification) else { complition(.failure(Errors.invalidURL))
            return }
        
        let boundary = UUID().uuidString
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(image)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Token \(API.token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let task = urlSession.dataTask(with: request) { [jsonDecoder] data, response, error in
            switch (data, error) {
            case let (.some(data), nil):
                do {
                    let photo = try jsonDecoder.decode(StonePhoto.self, from: data)
                    complition(.success(photo))
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
    
    func getClassificationHistory(complition: @escaping (Result<History, Error>) -> Void) {
        guard let url = URL(string: API.history) else {
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
                    let history = try jsonDecoder.decode(History.self, from: data)
                    complition(.success(history))
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
