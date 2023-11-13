

import Foundation

struct HistoryChat: Decodable {
    let id: Int
    let suggestions: [String?]
    let messages: [MessageElement]
    let title, createdAt: String
    let lastMessage: String?
    let user: Int

    enum CodingKeys: String, CodingKey {
        case id, suggestions, messages, title
        case createdAt = "created_at"
        case lastMessage = "last_message"
        case user
    }
}

struct MessageElement: Decodable {
    let id: Int
    let sender: Int?
    let text, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, sender, text
        case createdAt = "created_at"
    }
}

