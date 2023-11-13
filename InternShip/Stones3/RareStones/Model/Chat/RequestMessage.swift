

import Foundation

struct RequestMessage: Decodable {
    let id, sender: Int
    let text, createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, sender, text
        case createdAt = "created_at"
    }
}
