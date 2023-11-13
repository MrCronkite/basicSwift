

import Moya

enum ArticleService  {
    case getArticlesCoins
    case getArticleForId(id: String)
}


extension ArticleService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.coin-scan.pro/api/articles")!
    }
    
    var path: String {
        switch self {
        case .getArticlesCoins:
            return "/coins/"
        case .getArticleForId(let id):
            return "/coins/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArticleForId:
            return .get
        case .getArticlesCoins:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getArticleForId:
            return .requestPlain
        case .getArticlesCoins:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let token = UserSettingsImpl().token(forKey: .keyToken)
        return ["Content-Type": "application/json", "Authorization": "Token \(token ?? "")" ]
    }
}
    
