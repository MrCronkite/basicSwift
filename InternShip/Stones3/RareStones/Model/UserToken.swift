

import Foundation

struct UserToken: Decodable {
    let token: String
    let user: User
}

struct User: Decodable {
    let id: Int
    let username: String
}
