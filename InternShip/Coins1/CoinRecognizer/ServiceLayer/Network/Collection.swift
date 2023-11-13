

import Moya

struct RequestCoin: Encodable {
    let reference: Int
    let request: Int
    let category: Int
}

struct RequestNameCollection: Encodable {
    let name: String
}

enum CollectionServices {
    case getCoinsList
    case getCollectionList
    case createCollectionCategory(name: String)
    case createCoinsCollection(reference: Int, request: Int, category: Int)
    case readCollection(id: Int)
    case deleteCategory(id: Int)
    case renameCollection(id: Int, name: String)
    case deleteCoins(id: Int)
    case uploadImageForId(id: Int, image: UIImage)
}

extension CollectionServices: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.coin-scan.pro/api/collection")!
    }
    
    var path: String {
        switch self {
        case .getCoinsList:
            return "/coins/"
        case .getCollectionList:
            return "/coins/categories/"
        case .createCollectionCategory:
            return "coins/categories/"
        case .createCoinsCollection:
            return "/coins/"
        case let .readCollection(id):
            return "/coins/categories/\(id)/"
        case let .deleteCategory(id):
            return "/coins/categories/\(id)/"
        case let .renameCollection(id, _):
            return "/coins/categories/\(id)/"
        case let .deleteCoins(id):
            return "/coins/\(id)/"
        case let .uploadImageForId(id, _):
            return "/coins/\(id)/upload/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCoinsList:
            return .get
        case .getCollectionList:
            return .get
        case .createCollectionCategory:
            return .post
        case .createCoinsCollection:
            return .post
        case .readCollection:
            return .get
        case .deleteCategory:
            return .delete
        case .renameCollection:
            return .put
        case .deleteCoins:
            return .delete
        case .uploadImageForId:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCoinsList:
            return .requestPlain
        case .getCollectionList:
            return .requestPlain
        case let .createCollectionCategory(name):
            let name = RequestNameCollection(name: name)
            return .requestJSONEncodable(name)
        case let .createCoinsCollection(reference, request, category):
            let coin = RequestCoin(reference: reference,
                                   request: request,
                                   category: category)
            return .requestJSONEncodable(coin)
        case .readCollection:
            return .requestPlain
        case .deleteCategory:
            return .requestPlain
        case let .renameCollection(_, name):
            let name = RequestNameCollection(name: name)
            return .requestJSONEncodable(name)
        case .deleteCoins:
            return .requestPlain
        case let .uploadImageForId(_, image):
            let imageData = image.jpegData(compressionQuality: 0.1)!
            let multipartImage = Moya.MultipartFormData(provider: .data(imageData), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([multipartImage])
        }
    }
    
    var headers: [String : String]? {
        let token = UserSettingsImpl().token(forKey: .keyToken)
        return ["Content-Type": "application/json", "Authorization": "Token \(token ?? "")" ]
    }
}
