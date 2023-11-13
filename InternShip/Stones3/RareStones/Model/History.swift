

import Foundation

struct History: Decodable {
    let count: Int
    let next, previous: String?
    let results: [HistoryResult]
}

struct HistoryResult: Decodable {
    let id: Int
    let image: String
    let completed: Bool
    let createdAt: String
    let results: [ResultResult]

    enum CodingKeys: String, CodingKey {
        case id, image, completed
        case createdAt = "created_at"
        case results
    }
}

struct ResultResult: Decodable {
    let id: Int
    let name: String
    let stone: StoneItm
    let chance: String
}

struct StoneItm: Decodable {
    let id: Int
    let name: String
    let image: String
    let pricePerCaratFrom, pricePerCaratTo: String?
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case pricePerCaratFrom = "price_per_carat_from"
        case pricePerCaratTo = "price_per_carat_to"
        case isFavorite = "is_favorite"
    }
}
