

import Foundation

struct StonePhoto: Decodable {
    var id: Int
    var image: String
    var completed: Bool
    var createdDate: String
    var results: [StoneClassificationResultModel]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image = "image"
        case completed = "completed"
        case createdDate = "created_at"
        case results = "results"
    }
}

struct StoneClassificationResultModel: Decodable {
    var id: Int
    var name: String
    var stone: RockID
    var chance: String
}
