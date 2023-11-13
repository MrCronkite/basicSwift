

import Foundation

// MARK: - Token
struct Token: Decodable {
    let token: String
    let user: User
}

// MARK: - User
struct User: Decodable {
    let id: Int
    let username: String
}
