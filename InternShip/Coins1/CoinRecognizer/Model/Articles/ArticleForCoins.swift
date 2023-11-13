

import Foundation

struct ArticleForCoins: Codable {
    let id: Int
    let parts: [Part]
    let relatedReferences: [String?]
    let title: String
    let thumbnail: String
    let pinned: Bool
    let publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, parts
        case relatedReferences = "related_references"
        case title, thumbnail, pinned
        case publishedAt = "published_at"
    }
}

struct Part: Codable {
    let title: String?
    let text: String
    let image: String?
    let highlight: Bool
}
