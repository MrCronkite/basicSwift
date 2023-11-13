

import Moya
import KeychainSwift

enum AuthService {
    case registerUser(username: String, password: String)
    case loginUser(username: String, password: String)
}

extension AuthService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.coin-scan.pro/api/auth")!
    }
    
    var path: String {
        switch self {
        case .registerUser:
            return "/sign-up/"
        case .loginUser:
            return "/login/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerUser:
            return .post
        case .loginUser:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .registerUser(username, password):
            let parameters: [String: Any] = [
                "username": username,
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .loginUser(username, password):
            let parameters: [String: Any] = [
                "username": username,
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

protocol Registred: AnyObject {
    func registerUser(completion: @escaping (Result<Token, Error>) -> Void)
    func loginUser(login: String, completion: @escaping (Result<Token, Error>) -> Void)
    func checkToken()
}

final class RegistredImpl: Registred {
    private let keychain = KeychainSwift()
    private let authService = MoyaProvider<AuthService>()
    private let storage = UserSettingsImpl()
    
    func registerUser(completion: @escaping (Result<Token, Error>) -> Void) {
        let logAuth = generateUniqueUsernameAndPassword()
        
        keychain.set(logAuth.username, forKey: "login")
        keychain.set(logAuth.password, forKey: "password")
        
        authService.request(.registerUser(username: logAuth.username, password: logAuth.password)) { result in
            switch result {
            case let .success(response):
                do {
                    let userToken = try response.map(Token.self)
                    completion(.success(userToken))                    
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(login: String, completion: @escaping (Result<Token, Error>) -> Void) {
        let password = keychain.get("password")
        authService.request(.loginUser(username: login, password: password ?? "")) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                do {
                    let userToken = try response.map(Token.self)
                    completion(.success(userToken))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func checkToken() {
        if let login = keychain.get("login") {
            if Activity.checkInthernet() {
                self.login(login: login)
            } else {
                Activity.alertNoEthernet(view: StartViewController())
                Activity.checkingInternet { [weak self] result in
                    guard let self = self else { return }
                    if result {
                        self.login(login: login)
                    }
                }
            }
        } else {
            if Activity.checkInthernet() {
                self.registred()
            } else {
                Activity.alertNoEthernet(view: StartViewController())
                Activity.checkingInternet { [weak self] result in
                    guard let self = self else { return }
                    if result {
                        self.registred()
                    }
                }
            }
        }
    }
    
    func login(login: String) {
        loginUser(login: login) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.storage.setToken(token.token, forKey: .keyToken)
            case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.registred()
                }
            }
        }
    }
    
    func registred() {
        registerUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.storage.setToken(token.token, forKey: .keyToken)
            case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.registred()
                }
            }
        }
    }
}

private extension RegistredImpl {
    func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    func generateUniqueUsernameAndPassword() -> (username: String, password: String) {
        let username = "user_" + generateRandomString(length: 8)
        let password = generateRandomString(length: (15...30).randomElement()!)
        return (username, password)
    }
}


