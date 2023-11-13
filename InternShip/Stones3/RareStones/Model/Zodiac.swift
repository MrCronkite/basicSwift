

import Foundation

struct Zodiac: Decodable {
    let count: Int
    let next, previous: String?
    let results: [Results]
}

struct Results: Decodable {
    let id: Int
    let name: String
    let image: String
    let dateRange, planet, element, chakra: String

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case dateRange = "date_range"
        case planet, element, chakra
    }
}

class JSONNull: Decodable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

struct ZodiacID: Decodable {
    let id: Int
    let stones: [StoneElements]
    let name: String
    let image: String
    let dateRange, planet, element, chakra: String

    enum CodingKeys: String, CodingKey {
        case id, stones, name, image
        case dateRange = "date_range"
        case planet, element, chakra
    }
}


struct StoneElements: Decodable {
    let id: Int
    let stone: StoneElementsStone
    let description: String
}

struct StoneElementsStone: Decodable {
    let id: Int
    let name: String
    let image: String
    let photos: [Photo]
}

struct Photo: Decodable {
    let id: Int
    let image: String
}
