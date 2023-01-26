//
//  ApiManager.swift
//  URLSession
//
//  Created by admin1 on 25.01.23.
//

import Foundation

enum ApiType {
    
    case login
    case getUsers
    case getPosts
    case getAlbums
    
    
    var baseUrl: String {
        return "https://jsonplaceholder.typicode.com/"
    }
    
    var headers: [String: String] {
        switch self {
        case .login:
            return ["authToken" : "12345"]
        default:
            return [:]
        }
    }
    
    
}
