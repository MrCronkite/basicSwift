

import Foundation

struct Wishlist: Decodable {
    let count: Int
    let next, previous: String?
    let results: [WishlistResult]
}

struct WishlistResult: Decodable {
    let id: Int
    let reference: WishlistReference
}

struct WishlistReference: Codable {
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
