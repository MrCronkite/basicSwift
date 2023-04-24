// Swift
import UIKit
import PlaygroundSupport

class Singleton {

    private static var uniqueInstance: Singleton?

    private init() {}

    static func shared() -> Singleton {
        if uniqueInstance == nil {
            uniqueInstance = Singleton()
        }
        return uniqueInstance!
    }

}



//MARK: - Decorator
typealias Decoration<T> = (T) -> Void


//MARK: - Observing
struct RegistredUser: Codable {
    let refreshToken, accessToken: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
        case userID = "user_id"
    }
}

public enum Urls {
    static var checkAuthCode = "https://plannerok.ru/api/v1/users/check-auth-code/"
    static var sendAuthCode = "https://plannerok.ru/api/v1/users/send-auth-code/"
    static var register = "https://plannerok.ru/api/v1/users/register/"
    static var getUser = "https://plannerok.ru/api/v1/users/me/"
    static var getToken = "https://plannerok.ru/api/v1/users/refresh-token/"
    static var putUserData = "https://plannerok.ru/api/v1/users/me/"
}

//public func postRegister(phoneNumber: String, name: String, username: String) -> Void {
//    let session = URLSession.shared
//    let url = Urls.register
//    let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
//    request.httpMethod = "POST"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    var params :[String: Any]?
//    params = [  "phone": phoneNumber,
//                "name": name,
//                "username": username]
//    do{
//        request.httpBody = try JSONSerialization.data(withJSONObject: params as Any, options: JSONSerialization.WritingOptions())
//        let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
//            if let data = data {
//                do{
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
//                    guard let json = try? JSONSerialization.data(withJSONObject: jsonResponse, options: .prettyPrinted) else { return }
//                    guard let pretty = try? JSONDecoder().decode(RegistredUser.self, from: json) else {
//                        print("error")
//                        return
//                    }
//                    print(pretty.userID)
//                    print(pretty.accessToken)
//                    print(pretty.refreshToken)
//                    return "12"
//                }catch _ {
//                    print ("OOps not good JSON formatted response")
//                }
//            }
//        })
//        task.resume()
//    }catch _ {
//        print ("Oops something happened buddy")
//    }
//    return ""
//}
//
//postRegister(phoneNumber: "+33333", name: "vlad1245", username: "vlwed13323232")
//

enum NetworkType {
    case login
    case registerUser
    
    var baseUrl: String {
        return "https://plannerok.ru/api/v1/users/"
    }
    
    var path: String {
        switch self {
        case .login: return "send-auth-code/"
        case .registerUser: return "register/"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseUrl)!)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        switch self {
        case .login:
            request.httpMethod = "POST"
            return request
        case .registerUser:
            request.httpMethod = "POST"
            return request
        default:
            request.httpMethod = "GET"
            return request
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    public func restredUser(name: String, username: String, phoneNumber: String, completion: @escaping (RegistredUser) -> Void) {
        var params = ["phone": phoneNumber, "name": name, "username": username]
        
        var request = NetworkType.registerUser.request
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params as Any, options: JSONSerialization.WritingOptions())
            let task = URLSession.shared.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                if let data = data {
                    do{
                        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) else { return }
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else { return }
                        guard let jsonDecoded = try? JSONDecoder().decode(RegistredUser.self, from: jsonData) else { print("error 400"); return }
                        completion(jsonDecoded)
                    }
                }
            })
            task.resume()
        }catch _ {
            print ("Oops something happened buddy")
        }
    }
}

NetworkManager.shared.restredUser(name: "vldis12lav", username: "2imd23fdfa", phoneNumber: "3923") { user in
    print(user.userID)
    print(user.accessToken)
}
