

import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
     var sender: SenderType
     var messageId: String
     var sentDate: Date
     var kind: MessageKind
}
