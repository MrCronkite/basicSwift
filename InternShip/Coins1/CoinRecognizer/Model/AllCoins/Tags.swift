

import Foundation

struct Tags: Decodable {
    let count: Int
    let next, previous: String?
    let results: [TagsResult]
}

struct TagsResult: Decodable {
    let id: Int
    let name: String
    let image: String
}
