

import Moya

enum StoneProvider: Encodable {
    case getRocks(limit: Int)
}

extension StoneProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://my-stone-collection.com/api/")!
    }
    
    var path: String {
        switch self {
        case .getRocks:
            return "rocks/"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getRocks(let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let token = UserDefaults.standard.string(forKey: R.Strings.KeyUserDefaults.tokenKey)
        return ["Content-Type": "application/json", "Authorization": "Token \(token ?? "")"]
    }
}
