import Foundation

struct RecognitionCoins: Decodable {
    let count: Int
    let next, previous: String?
    let results: [RecognitionCoinsResult]
}

struct RecognitionCoinsResult: Decodable {
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
    let reference: Reference
    let chance: Double
}

struct Reference: Decodable {
    let id: Int
    let name, dateRange, designer, denomination: String
    let imageObverse: String?
    let imageReverse: String?
    let priceFrom, priceTo: String
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case dateRange = "date_range"
        case designer, denomination
        case imageObverse = "image_obverse"
        case imageReverse = "image_reverse"
        case priceFrom = "price_from"
        case priceTo = "price_to"
        case isFavorite = "is_favorite"
    }
}
