

import Foundation

struct Collection: Decodable {
    let id: Int
    var items: [ItemCollection]
    var createdAt, name: String
    let itemsCount, user: Int

    enum CodingKeys: String, CodingKey {
        case id, items
        case createdAt = "created_at"
        case name
        case itemsCount = "items_count"
        case user
    }
}

struct ItemCollection: Decodable {
    let id: Int
    let reference: ReferenceItemCollection
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

struct ReferenceItemCollection: Decodable {
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

struct CoinsResponse: Decodable {
    let id, reference: Int
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

struct UserPhoto: Decodable {
    let id: Int
    let image: String
}

