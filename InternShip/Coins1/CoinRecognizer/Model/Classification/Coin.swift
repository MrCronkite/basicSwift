import Foundation

struct Coin: Decodable {
    let id: Int
    let image: String
    let completed: Bool
    let createdAt: String
    let results: [ResultsCoins]
    
    enum CodingKeys: String, CodingKey {
        case id, image, completed
        case createdAt = "created_at"
        case results
    }
}

struct ResultsCoins: Decodable {
    let id: Int
    let name: String
    let reference: ReferenceCoins
    let chance: Double
}

struct ReferenceCoins: Decodable {
    let id: Int
    let isFavorite: Bool
    let photos: [Photo?]
    let userCollection: UserCollection?
    let tags: [String?]
    let imageObverse: String?
    let imageReverse: String?
    let name, dateRange, designer, denomination: String
    let mintMark, composition: String
    let weight, diameter, thickness: Int
    let mintage: Int?
    let priceFrom, priceTo, letteringReverse, letteringObverse: String
    let meltPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isFavorite = "is_favorite"
        case photos
        case userCollection = "user_collection"
        case tags
        case imageObverse = "image_obverse"
        case imageReverse = "image_reverse"
        case name
        case dateRange = "date_range"
        case designer, denomination
        case mintMark = "mint_mark"
        case composition, weight, diameter, thickness, mintage
        case priceFrom = "price_from"
        case priceTo = "price_to"
        case letteringReverse = "lettering_reverse"
        case letteringObverse = "lettering_obverse"
        case meltPrice = "melt_price"
    }
}

struct Photo: Decodable {
    let id: Int
    let image: String
    let reference: Int
}

struct UserCollection: Decodable {
    let id: Int
    let userPhotos: [UserPhoto?]
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userPhotos = "user_photos"
        case createdAt = "created_at"
    }
}
