import Moya

struct SendMessageRequest: Encodable {
    let message: String
    let title: String
}

struct SendMessage: Encodable {
    let text: String
}

enum ChatAPI {
    case setupChat(textMessage: String)
    case getMessage(id: String)
    case getChats
    case sendMessage(textMessage: String, id: String)
}

extension ChatAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.coin-scan.pro/api")!
    }

    var path: String {
        switch self {
        case .setupChat:
            return "/chats/"
        case .getMessage(let id):
            return "/chats/\(id)/"
        case .getChats:
            return "/chats/"
        case .sendMessage(_, let id):
            return "/chats/\(id)/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .setupChat:
            return .post
        case .getMessage:
            return .get
        case .getChats:
            return .get
        case .sendMessage:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .setupChat(let textMessage):
            let messageData = SendMessageRequest(message: textMessage, title: "string")
            return .requestJSONEncodable(messageData)
        case .getMessage:
            return .requestPlain
        case .getChats:
            return .requestPlain
        case .sendMessage(let textMessage, _):
            let messageData = SendMessage(text: textMessage)
            return .requestJSONEncodable(messageData)
        }
    }

    var headers: [String: String]? {
        let token = UserSettingsImpl().token(forKey: .keyToken)
        return ["Content-Type": "application/json", "Authorization": "Token \(token ?? "")" ]
    }
}
