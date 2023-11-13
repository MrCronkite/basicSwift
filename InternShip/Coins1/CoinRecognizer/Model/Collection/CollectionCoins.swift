

import Foundation

struct CollectionCoins: Decodable {
    let count: Int
    let next, previous: String?
    let results: [CollectionCoinsResult]
}

struct CollectionCoinsResult: Decodable {
    let id: Int
    let reference: ReferenceCollectionCoins
    let createdAt: String
    let userPhotos: [UserPhoto?]
    let category: Int

    enum CodingKeys: String, CodingKey {
        case id, reference
        case createdAt = "created_at"
        case userPhotos = "user_photos"
        case category
    }
}

struct ReferenceCollectionCoins: Decodable {
    let id: Int
    let name, dateRange, designer, denomination: String
    let imageObverse, imageReverse: String?
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

