

import UIKit
import MessageKit
import InputBarAccessoryView
import Moya

class ChatViewController: MessagesViewController {
    private var arreyMessages: [MessageType] = []
    private var chatId = ""
    private var buttons: [UIButton] = []
    private var networkChar = MoyaProvider<ChatAPI>()
    private var questions: [String] = []
    private let loading = Loading()
    
    let viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#DAD1FB")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        return view
    }()
    
    let imageDwarfForNavBar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "avatar")
        view.backgroundColor = .clear
        return view
    }()
    
    let imageViewDwarf: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "avatarB")
        view.backgroundColor = .clear
        return view
    }()
    
    let subtitle: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.greyColor()
        lable.text = "helper_subtitle".localized
        lable.adjustsFontSizeToFitWidth = true
        lable.textAlignment = .right
        return lable
    }()
    
    let getPremiumTitle: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = R.Colors.active
        lable.text = "h_button_premium".localized
        lable.isUserInteractionEnabled = true
        lable.numberOfLines = 0
        lable.textAlignment = .left
        return lable
    }()
    
    let scrollQuestionsView: UIScrollView = {
        let view = UIScrollView()
        view.contentSize = .init(width: 655, height: 54)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 16
        return view
    }()
    
    let userSender = Sender(senderId: "self", displayName: "User")
    let helperSender = Sender(senderId: "other", displayName: "Ai helper")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        setChat()
        setupQuestions()
        scrollQuestionsView.contentInset.left = 16
        
        AnalyticsManager.shared.logEvent(name: Events.open_aihelper_view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messagesCollectionView.backgroundColor = .clear
        view.setupLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPremium()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: false)
    }
    
    @objc func getQuestions(_ sender: UIButton) {
        AnalyticsManager.shared.logEvent(name: Events.questions_aihelper)
        if let text = sender.titleLabel?.text {
            messageInputBar.inputTextView.text = text
        }
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustMessageCollectionView(forKeyboardShow: true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustMessageCollectionView(forKeyboardShow: false, notification: notification)
    }
    
    @objc func openGetPremiumVC() {
        let vc = GetPremiumViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func sendButtonTapped() {
        let text = messageInputBar.inputTextView.text
        messageInputBar.inputTextView.text = ""
        let trimmedText = text!.trimmingCharacters(in: .whitespaces)
        
        if !UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            if arreyMessages.count < 7 {
                if LoadingIndicator.checkInthernet(view: self) {
                    messageInputBar.sendButton.subviews.last?.isHidden = false
                    messageInputBar.sendButton.image = .none
                    sendMessage(text: trimmedText)
                }
            } else {
                self.messageInputBar.sendButton.image = UIImage(named: "send")
                self.messageInputBar.sendButton.subviews.last?.isHidden = true
                AnalyticsManager.shared.logEvent(name: Events.free_message_off)
                let vc = GetPremiumViewController()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        } else {
            if LoadingIndicator.checkInthernet(view: self) {
                messageInputBar.sendButton.subviews.last?.isHidden = false
                messageInputBar.sendButton.image = .none
                sendMessage(text: trimmedText)
            }
        }
        
        if let buttonToRemove = buttons.first(where: { $0.titleLabel?.text == trimmedText }) {
            buttonToRemove.removeFromSuperview()
            if let index = buttons.firstIndex(of: buttonToRemove) {
                buttons.remove(at: index)
                questions.remove(at: index)
                UserDefaults.standard.set(questions, forKey: R.Strings.KeyUserDefaults.questions)
            }
            
            if buttons.isEmpty {
                stackView.isHidden = true
                viewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
                if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
                    viewContainer.heightAnchor.constraint(equalToConstant: 5).isActive = true
                }
            }
        }
    }
}

extension ChatViewController {
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        messagesCollectionView.addGestureRecognizer(tapGesture)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.contentInset = .init(top: 130, left: 0, bottom: 0, right: 0)
        messagesCollectionView.showsVerticalScrollIndicator = false
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 50))
        layout?.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 4))
        
        LoadingIndicator.buttonLoader(view: messageInputBar.sendButton)
        messageInputBar.sendButton.subviews.last?.isHidden = true
        messageInputBar.sendButton.image = UIImage(named: "send")
        messageInputBar.sendButton.title = ""
        messageInputBar.sendButton.setSize(CGSize(width: 44, height: 50), animated: false)
        messageInputBar.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        messageInputBar.inputTextView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        messageInputBar.inputTextView.placeholder = "helper_playceholder".localized
        messageInputBar.inputTextView.placeholderTextColor = R.Colors.textColor
        messageInputBar.inputTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        messageInputBar.inputTextView.textColor = R.Colors.darkGrey
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.backgroundView.backgroundColor = .clear
        messageInputBar.backgroundView.layer.borderColor = UIColor.clear.cgColor
        messageInputBar.backgroundColor = UIColor(hexString: "#e9effe")
        messageInputBar.separatorLine.isHidden = true
        headerView.isHidden = true
        imageViewDwarf.isHidden = false
        
        messageInputBar.inputTextView.layer.cornerRadius = 10
        messageInputBar.inputTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        let tapGetLable = UITapGestureRecognizer(target: self, action: #selector(openGetPremiumVC))
        getPremiumTitle.addGestureRecognizer(tapGetLable)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupConstraint() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        imageDwarfForNavBar.translatesAutoresizingMaskIntoConstraints = false
        imageViewDwarf.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        getPremiumTitle.translatesAutoresizingMaskIntoConstraints = false
        scrollQuestionsView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollQuestionsView.addSubview(stackView)
        viewContainer.addSubview(getPremiumTitle)
        messagesCollectionView.addSubview(imageViewDwarf)
        headerView.addSubview(imageDwarfForNavBar)
        messageInputBar.addSubview(viewContainer)
        viewContainer.addSubview(subtitle)
        viewContainer.addSubview(scrollQuestionsView)
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            viewContainer.leadingAnchor.constraint(equalTo: messageInputBar.leadingAnchor, constant: 0),
            viewContainer.trailingAnchor.constraint(equalTo: messageInputBar.trailingAnchor, constant: 0),
            viewContainer.topAnchor.constraint(equalTo: messageInputBar.topAnchor, constant: 0),
            viewContainer.heightAnchor.constraint(equalToConstant: 100),
            viewContainer.bottomAnchor.constraint(equalTo: messageInputBar.inputTextView.topAnchor, constant: 0),
            
            headerView.heightAnchor.constraint(equalToConstant: 100),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            
            imageDwarfForNavBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            imageDwarfForNavBar.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0),
            imageDwarfForNavBar.heightAnchor.constraint(equalToConstant: 40),
            
            imageViewDwarf.bottomAnchor.constraint(equalTo: messagesCollectionView.topAnchor, constant: -10),
            imageViewDwarf.centerXAnchor.constraint(equalTo: messagesCollectionView.centerXAnchor, constant: 0),
            imageViewDwarf.heightAnchor.constraint(equalToConstant: 100),
            subtitle.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 16),
            subtitle.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor, constant: -70),
            subtitle.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 2),
            
            getPremiumTitle.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: 16),
            getPremiumTitle.leadingAnchor.constraint(equalTo: subtitle.trailingAnchor, constant: 3),
            getPremiumTitle.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 2),
            
            scrollQuestionsView.heightAnchor.constraint(equalToConstant: 60),
            scrollQuestionsView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 30),
            scrollQuestionsView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 0),
            scrollQuestionsView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: 0),
            
            stackView.topAnchor.constraint(equalTo: scrollQuestionsView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollQuestionsView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollQuestionsView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollQuestionsView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        setPremium()
    }
    
    private func adjustMessageCollectionView(forKeyboardShow show: Bool, notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = show ? keyboardFrame.height + 10 : 10
        
        UIView.animate(withDuration: 0.3) {
            self.messagesCollectionView.contentInset.bottom = keyboardHeight + self.messageInputBar.frame.height
            self.messagesCollectionView.scrollIndicatorInsets.bottom = keyboardHeight + self.messageInputBar.frame.height 
            
            if show, self.isLastSectionVisible() {
                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            }
        }
    }
    
    private func setPremium() {
        if let questions = UserDefaults.standard.array(forKey: R.Strings.KeyUserDefaults.questions) {
            self.questions = (questions as? [String])!
            if self.questions.count == 0 {
                stackView.isHidden = true
                viewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
                if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
                    subtitle.isHidden = true
                    getPremiumTitle.isHidden = true
                    viewContainer.heightAnchor.constraint(equalToConstant: 5).isActive = true
                }
            } else {
                if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
                    subtitle.isHidden = true
                    getPremiumTitle.isHidden = true
                    viewContainer.heightAnchor.constraint(equalToConstant: 70).isActive = true
                    scrollQuestionsView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10).isActive = true
                }
            }
        } else {
            self.questions = R.Strings.AiHelper.questions
            if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
                subtitle.isHidden = true
                getPremiumTitle.isHidden = true
                viewContainer.heightAnchor.constraint(equalToConstant: 70).isActive = true
                scrollQuestionsView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10).isActive = true
            }
        }
    }
    
    private func isLastSectionVisible() -> Bool {
        guard !arreyMessages.isEmpty else {
            return false
        }
        let lastIndexPath = IndexPath(item: 0, section: arreyMessages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    private func setupQuestions() {
        for text in self.questions {
            let button = UIButton()
            button.setTitle(text.localized, for: .normal)
            button.backgroundColor = UIColor(hexString: "#C9F0CC")
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.titleLabel?.textAlignment = .left
            button.titleLabel?.numberOfLines = 2
            button.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
            button.heightAnchor.constraint(equalToConstant: 54).isActive = true
            button.addTarget(self, action: #selector(getQuestions(_:)), for: .touchUpInside)
            
            let textSize = (text.localized as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
            button.widthAnchor.constraint(equalToConstant: textSize.width / 1.3).isActive = true
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        viewContainer.addSubview(scrollQuestionsView)
    }
}

//MARK: - Network
private extension ChatViewController {
    func setChat() {
        loading.blockerView(view: self)
        loading.addLoading(view: self)
        networkChar.request(.getChats) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    do {
                        let chats = try response.map(Chats.self)
                        if chats.count == 0 {
                            self.startMessage()
                        } else {
                            self.chatId = "\(chats.results.last?.id ?? 1)"
                            self.showAllMessages()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(_):
                LoadingIndicator.alertNoInthernetEscap {
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
    }
    
    func startMessage() {
        networkChar.request(.setupChat(textMessage: "chat"), completion: { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            loading.removeBlockedView()
            switch result {
            case let .success(response):
                do {
                    let message = try response.map(MessagesChat.self)
                    self.chatId = "\(message.id)"
                    let firstMessage = Message(sender: self.helperSender,
                                               messageId: "12",
                                               sentDate: Date(),
                                               kind: .text(R.Strings.AiHelper.message))
                    self.arreyMessages.append(firstMessage)
                    self.reloadView()
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(let error): print(error.localizedDescription)
            }
        })
    }
    
    func showAllMessages() {
        networkChar.request(.getMessage(id: self.chatId), completion: { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            loading.removeBlockedView()
            switch result {
            case let .success(response):
                do {
                    let chat = try response.map(HistoryChat.self)
                    showMessages(message: chat.messages)
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                    print(response)
                    print(error.localizedDescription)
                }
            case .failure(_):
                LoadingIndicator.alertNoInthernetEscap {
                    self.tabBarController?.selectedIndex = 0
                }
            }
        })
    }
    
    func showMessages(message: [MessageElement]) {
        if message.count >= 3 {
            headerView.isHidden = false
            imageViewDwarf.isHidden = true
            self.messagesCollectionView.contentInset.top = 80
        }
        
        let firstMessage = Message(sender: helperSender,
                                   messageId: "12",
                                   sentDate: Date(),
                                   kind: .text(R.Strings.AiHelper.message))
        
        
        for sender in message {
            if sender.sender == nil {
                let message = Message(sender: helperSender,
                                      messageId: "\(sender.id)",
                                      sentDate: Date(),
                                      kind: .text(sender.text))
                arreyMessages.append(message)
            } else {
                let message = Message(sender: userSender,
                                      messageId: "\(sender.id)",
                                      sentDate: Date(),
                                      kind: .text(sender.text))
                arreyMessages.append(message)
            }
        }
        
        arreyMessages.removeFirst()
        arreyMessages.removeFirst()
        arreyMessages.insert(firstMessage, at: 0)
        
        setupSubtitle(number: arreyMessages.count)
        self.reloadView()
    }
    
    func sendMessage(text: String) {
        headerView.isHidden = false
        imageViewDwarf.isHidden = true
        self.messagesCollectionView.contentInset.top = 80
        
        let message = Message(sender: userSender,
                              messageId: "1",
                              sentDate: Date(),
                              kind: .text(text))
        let messageLoad = Message(sender: helperSender,
                                  messageId: "1",
                                  sentDate: Date(),
                                  kind: .text("..."))
        
        arreyMessages.append(message)
        arreyMessages.append(messageLoad)
        setupSubtitle(number: arreyMessages.count)
        self.reloadView()
        
        networkChar.request(.sendMessage(textMessage: text, id: self.chatId), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let message = try response.map(RequestMessage.self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.getMessageInHelper(id: message.id)
                    }
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_):
                LoadingIndicator.alertNoInthernetEscap {
                    self.tabBarController?.selectedIndex = 0
                }
            }
        })
    }
    
    func getMessageInHelper(id: Int) {
        networkChar.request(.getMessage(id: self.chatId), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                do {
                    let chat = try response.map(HistoryChat.self)
                    if chat.messages.last?.id == id {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.getMessageInHelper(id: id)
                        }
                    } else {
                        let message = Message(sender: self.helperSender,
                                              messageId: "10",
                                              sentDate: Date(),
                                              kind: .text(chat.messages.last!.text))
                        self.arreyMessages.removeLast()
                        self.arreyMessages.append(message)
                        self.messageInputBar.sendButton.image = UIImage(named: "send")
                        self.messageInputBar.sendButton.subviews.last?.isHidden = true
                        self.reloadView()
                    }
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                    print(response)
                    print(error.localizedDescription)
                }
            case .failure(_): break
            }
        })
    }
    
    func setupSubtitle(number: Int) {
        switch number {
        case (0...2): self.subtitle.replaceNumberThree(with: 3)
        case 3: self.subtitle.replaceNumberThree(with: 2)
        case (3...5): self.subtitle.replaceNumberThree(with: 1)
        default:  self.subtitle.replaceNumberThree(with: 0)
        }
    }
    
    func reloadView() {
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate {
    var currentSender: SenderType {
        return Sender(senderId: "self", displayName: "User")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return arreyMessages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return arreyMessages[indexPath.section]
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        return .zero
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if message.sender.senderId == currentSender.senderId {
            return .custom { view in
                view.backgroundColor = R.Colors.roseBtn
                view.style = .bubbleTail(.bottomRight, .pointedEdge)
            }
        } else {
            return .custom { view in
                view.backgroundColor = .white
                view.style = .bubbleTail(.bottomLeft, .pointedEdge)
            }
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == currentSender.senderId {
            return .white
        } else {
            return R.Colors.darkGrey
        }
    }
}


