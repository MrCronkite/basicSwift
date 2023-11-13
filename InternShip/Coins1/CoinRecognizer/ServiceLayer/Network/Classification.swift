

import Moya
import UIKit

enum ClassificationAPIService {
    case uploadImages(image: UIImage)
    case getHistory
    case getHistoryId(id: String)
}

extension ClassificationAPIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.coin-scan.pro/api/classification")!
    }
    
    var path: String {
        switch self {
        case .uploadImages:
            return "/coins/"
        case .getHistory:
            return "/coins/history/"
        case .getHistoryId(let id):
            return "/coins/history/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadImages:
            return .post
        case .getHistory:
            return .get
        case .getHistoryId:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .uploadImages(let image):
                let imageData = image.jpegData(compressionQuality: 0.1)!
            let multipartImage = Moya.MultipartFormData(provider: .data(imageData), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([multipartImage])
        case .getHistory: 
            return .requestPlain
        case .getHistoryId:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        let token = UserSettingsImpl().token(forKey: .keyToken)
        return ["Content-Type": "application/json", "Authorization": "Token \(token ?? "")" ]
    }
}

