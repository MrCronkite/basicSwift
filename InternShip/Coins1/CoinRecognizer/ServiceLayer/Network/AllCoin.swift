

import Moya

struct IdRequestWishlist: Encodable {
    let reference: Int
}

enum CoinsService {
    case getAllCoins(limit: Int, offset: Int)
    case getWishlist
    case getTags
    case getCoinForId(id: String)
    case postGoWishlist(id: Int)
    case deleteFavorite(id: Int)
    case getCoinByTag(tag: Int)
}

extension CoinsService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.coin-scan.pro/api")!
    }
    
    var path: String {
        switch self {
        case .getAllCoins:
            return "/coins/"
        case .getWishlist:
            return "/coins/wishlist/"
        case let .getCoinForId(id):
            return "/coins/\(id)/"
        case .postGoWishlist:
            return "/coins/wishlist/"
        case let .deleteFavorite(id):
            return "/coins/\(id)/remove-from-wishlist/"
        case .getTags:
            return "/coins/tags/"
        case .getCoinByTag:
            return "/coins/"
        }
    }
    
    var method: Method {
        switch self {
        case .getAllCoins:
            return .get
        case .getWishlist:
            return .get
        case .getCoinForId:
            return .get
        case .postGoWishlist:
            return .post
        case .deleteFavorite:
            return .delete
        case .getTags:
            return .get
        case .getCoinByTag:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .getAllCoins(limit, offset):
            return .requestParameters(parameters: ["limit": limit, "offset": offset], encoding: URLEncoding.default)
        case .getWishlist:
            return .requestPlain
        case .getCoinForId:
            return .requestPlain
        case let .postGoWishlist(id):
            let id = IdRequestWishlist(reference: id)
            return .requestJSONEncodable(id)
        case .deleteFavorite:
            return .requestPlain
        case .getTags:
            return .requestPlain
        case .getCoinByTag(let tag):
            return .requestParameters(parameters: ["tags": tag], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let token = UserSettingsImpl().token(forKey: .keyToken)
        return ["Content-Type": "application/json", "Authorization": "Token \(token ?? "")" ]
    }
}
