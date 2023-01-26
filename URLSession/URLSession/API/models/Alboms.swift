//
//  Alboms.swift
//  URLSession
//
//  Created by admin1 on 26.01.23.
//

import Foundation

// MARK: - Albom
struct Albom: Codable {
    let userID, id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}

typealias Alboms = [Albom]
