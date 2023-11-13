

import Foundation

struct Chats: Decodable {
    let count: Int
    let next, previous: String?
    let results: [ChatsResults]
}


struct ChatsResults: Decodable {
    let id: Int
    let suggestions: [String?]
    let title, createdAt: String
    let lastMessage: String?
    let user: Int

    enum CodingKeys: String, CodingKey {
        case id, suggestions, title
        case createdAt = "created_at"
        case lastMessage = "last_message"
        case user
    }
}
