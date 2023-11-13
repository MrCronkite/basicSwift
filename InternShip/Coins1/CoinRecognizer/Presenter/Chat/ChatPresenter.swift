

import UIKit
import MessageKit
import Moya

protocol ChatViewProtocol: AnyObject {
    func reloadView()
    func setViewPremium()
    func hideLoader()
    func setupTips()
}

protocol ChatPresenter {
    var user: SenderType { get set }
    var helper: SenderType { get set }
    var messages: [Message] { get set }
    var id: String { get set }
    var tips: [String] { get set }
    var buttons: [UIButton] { get set }
    var isPremium: Bool { get set }
    
    init(view: ChatViewProtocol, router: RouterProtocol, storage: UserSettings, chatProvider: MoyaProvider<ChatAPI>)
    
    func showMessages(message: [MessageElement])
    func goToPremium()
    func popToRoot()
    func addMessage()
    func sendMessage(text: String)
    func getStartMessage()
    func setupChat()
    func getMessages(id: String)
    func getMessageInHelper(id: Int)
    func setupPremiumView()
    func setupTips()
    func saveTips(index: Int)
}

final class ChatPresenterImpl: ChatPresenter {
    weak var view: ChatViewProtocol?
    var router: RouterProtocol?
    var storage: UserSettings?
    var messages: [Message] = []
    var user: SenderType = Sender(senderId: "self", displayName: "User")
    var helper: SenderType = Sender(senderId: "helper", displayName: "Ai helper")
    var chatProvider: MoyaProvider<ChatAPI>?
    var id: String = ""
    var tips: [String] = []
    var buttons: [UIButton] = []
    var isPremium: Bool = false
    
    init(view: ChatViewProtocol, router: RouterProtocol, storage: UserSettings, chatProvider: MoyaProvider<ChatAPI>) {
        self.view = view
        self.router = router
        self.storage = storage
        self.chatProvider = chatProvider
        self.isPremium = self.storage?.premium(forKey: .keyPremium) ?? false
        
        if Activity.checkInthernet(view: view as! ChatViewController) {
            self.setupChat()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.popToRoot()
            }
        }
    }
    
    func setupChat() {
        Activity.showActivity(view: view as! ChatViewController)
        chatProvider?.request(.getChats, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Activity.hideActivity()
            }
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    do {
                        let message = try response.map(AllChats.self)
                        if message.count == 0 {
                            self.getStartMessage()
                        } else {
                            self.getMessages(id: "\(message.results.first?.id ?? 1)")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(_):
                Activity.showAlertNoInthernet {
                    self.router?.popToView(isAnimate: true)
                }
            }
        })
    }
    
    func setupTips() {
        if let tips = storage?.getArray(forKey: .keyArray) {
            self.tips = tips
        } else {
            self.tips = R.Strings.Chat.tips
        }
        view?.setupTips()
    }
    
    func showMessages(message: [MessageElement]) {
        for sender in message {
            if sender.sender == nil {
                let message = Message(sender: helper,
                                      messageId: "\(sender.id)",
                                      sentDate: Date(),
                                      kind: .text(sender.text))
                messages.append(message)
            } else {
                let message = Message(sender: user,
                                      messageId: "\(sender.id)",
                                      sentDate: Date(),
                                      kind: .text(sender.text))
                messages.append(message)
            }
            view?.reloadView()
        }
    }
    
    func getMessages(id: String) {
        self.id = id
        chatProvider?.request(.getMessage(id: id), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                do {
                    let chat = try response.map(MessagesAll.self)
                    showMessages(message: chat.messages)
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                    print(response)
                    print(error.localizedDescription)
                }
            case .failure(_):
                Activity.showAlertNoInthernet {
                    self.router?.popToView(isAnimate: true)
                }
            }
        })
    }
    
    func addMessage() {
        let message = Message(sender: helper,
                               messageId: "1",
                               sentDate: Date(),
                              kind: .text(R.Strings.Chat.firstMessage))
        self.messages.append(message)
        
        view?.reloadView()
    }
    
    func getStartMessage() {
        chatProvider?.request(.setupChat(textMessage: "Set first chat"), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                do {
                    let message = try response.map(Chat.self)
                    self.id = "\(message.id)"
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(let error): print(error.localizedDescription)
            }
        })
    }
    
    func sendMessage(text: String) {
        let message = Message(sender: user,
                              messageId: "2",
                              sentDate: Date(),
                              kind: .text(text))
        let messageLoad = Message(sender: helper,
                              messageId: "2",
                              sentDate: Date(),
                                  kind: .text("..."))
        
        self.messages.append(message)
        self.messages.append(messageLoad)
        view?.reloadView()
        
        chatProvider?.request(.sendMessage(textMessage: text, id: self.id), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let message = try response.map(ResponseMessage.self)
                    self.getMessageInHelper(id: message.id)
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_):
                Activity.showAlertNoInthernet {
                    self.router?.popToView(isAnimate: true)
                }
            }
        })
    }
    
    func getMessageInHelper(id: Int) {
        chatProvider?.request(.getMessage(id: self.id), completion: { [weak self ] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                do {
                    let chat = try response.map(MessagesAll.self)
                    if chat.messages.last?.id == id {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.getMessageInHelper(id: id)
                        }
                    } else {
                        let message = Message(sender: self.helper,
                                              messageId: "1",
                                              sentDate: Date(),
                                              kind: .text(chat.messages.last!.text))
                        self.messages.removeLast()
                        self.messages.append(message)
                        self.view?.hideLoader()
                        self.view?.reloadView()
                    }
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        })
    }
    
    func saveTips(index: Int) {
        self.tips.remove(at: index)
        storage?.setStringArray(self.tips, forKey: .keyArray)
    }
    
    func setupPremiumView() {
        if self.isPremium {
            view?.setViewPremium()
        }
    }
    
    func popToRoot() {
        router?.popToRoot()
    }
    
    func goToPremium() {
        router?.goToPremium(view: view as! ChatViewController)
    }
}
