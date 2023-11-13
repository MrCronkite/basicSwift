

import Foundation

struct AllCoins: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ResultAllCoins]
}

struct ResultAllCoins: Decodable {
    let id: Int
    var name, dateRange, designer, denomination: String
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
