

import Foundation

struct Wishlist: Decodable {
    let count: Int
    let next, previous: String?
    let results: [WishlistResult]
}

struct WishlistResult: Decodable {
    let id: Int
    let stone: Stone
}

struct Stone: Decodable {
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
