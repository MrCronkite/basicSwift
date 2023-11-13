

import Foundation

struct Chat: Codable {
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

struct AllChats: Codable {
    let count: Int
    let next, previous: String?
    let results: [ResultChats]
}

// MARK: - Result
struct ResultChats: Codable {
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
