

import Foundation

struct Articles: Decodable {
    let count: Int
    let next, previous: String?
    let results: [ArticlesResult]
}

struct ArticlesResult: Decodable {
    let id: Int
    let title: String
    let thumbnail: String
    let pinned: Bool
    let publishedAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail, pinned
        case publishedAt = "published_at"
    }
}
