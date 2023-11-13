

import MessageKit
import UIKit

struct DummyMessage: MessageType {
    var sender: SenderType {
        return DummySender()
    }

    var messageId: String {
        return UUID().uuidString
    }

    var sentDate: Date {
        return Date()
    }

    var kind: MessageKind {
        return .text("This is a dummy message.")
    }
}

struct DummySender: SenderType {
    var senderId: String {
        return "dummy_sender"
    }

    var displayName: String {
        return "Dummy Sender"
    }
}
