

import Foundation

struct CreateColletion: Decodable {
    let id: Int
    let createdAt, name: String
    let itemsCount, user: Int

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name
        case itemsCount = "items_count"
        case user
    }
}
