

import UIKit
import MessageKit
import InputBarAccessoryView
import GoogleMobileAds

final class ChatViewController: MessagesViewController {
    
    var presenter: ChatPresenter?
    private var buttons: [UIButton] = []
    
    @IBOutlet weak private var titleChat: UILabel!
    @IBOutlet weak private var logoChat: UIImageView!
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(Asset.Assets.back.image, for: .normal)
        return button
    }()
    
    private let subtitle: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = Asset.Color.textGray.color
        lable.adjustsFontSizeToFitWidth = true
        lable.textAlignment = .right
        return lable
    }()
    
    private let lableGetPremium: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = Asset.Color.orange.color
        lable.isUserInteractionEnabled = true
        lable.numberOfLines = 0
        lable.textAlignment = .left
        return lable
    }()
    
    private let scrollQuestionsView: UIScrollView = {
        let view = UIScrollView()
        view.contentSize = .init(width: 655, height: 54)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 16
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        presenter?.setupTips()
        presenter?.setupPremiumView()
        presenter?.addMessage()
        localize()
    }
    
    @objc private func close() {
        presenter?.popToRoot()
    }
    
    @objc private func sendMessage() {
        messageInputBar.sendButton.image = .none
        messageInputBar.sendButton.subviews.last?.isHidden = false
        let text = messageInputBar.inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if (presenter?.messages.count)! < 7 || (presenter?.isPremium)! {
            presenter?.sendMessage(text: text )
            
            messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            
            if let buttonToRemove = buttons.first(where: { $0.titleLabel?.text == text }) {
                buttonToRemove.removeFromSuperview()
                if let index = buttons.firstIndex(of: buttonToRemove) {
                    buttons.remove(at: index)
                    presenter?.saveTips(index: index)
                }
                
                if buttons.count == 0 {
                    messageInputBar.topStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                    if lableGetPremium.isHidden == true {
                        messageInputBar.topStackView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                    }
                }
            }
        } else {
            messageInputBar.inputTextView.text = ""
            messageInputBar.sendButton.subviews.last?.isHidden = true
            messageInputBar.sendButton.setImage(Asset.Assets.sendArrow.image, for: .normal)
            presenter?.goToPremium()
        }
    }
    
    @objc private func handleTapGesture() {
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    @objc private func goPremium() {
        presenter?.goToPremium()
    }
    
    @objc private func getQuestions(_ sender: UIButton) {
        if let text = sender.titleLabel?.text {
            messageInputBar.inputTextView.text = text
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        adjustMessageCollectionView(forKeyboardShow: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustMessageCollectionView(forKeyboardShow: false, notification: notification)
    }
}

private extension ChatViewController {
    func setupView() {
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.layer.zPosition = -1
        messagesCollectionView.contentInset.top = 62
        messagesCollectionView.backgroundColor = .white
        messagesCollectionView.layer.cornerRadius = 30
        messagesCollectionView.messagesCollectionViewFlowLayout.typingIndicatorSizeCalculator.layout?.itemSize = .init(width: 30, height: 30)
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 50))
        layout?.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 4))
        
        messageInputBar.sendButton.title = ""
        Activity.logo(view: messageInputBar.sendButton)
        messageInputBar.sendButton.subviews.last?.isHidden = true
        messageInputBar.sendButton.setImage(UIImage(named: ""), for: .normal)
        messageInputBar.sendButton.setImage(Asset.Assets.sendArrow.image, for: .normal)
        messageInputBar.sendButton.setSize(CGSize(width: 44, height: 44), animated: false)
        messageInputBar.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        messageInputBar.inputTextView.placeholderTextColor = Asset.Color.textGray.color
        messageInputBar.inputTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        messageInputBar.inputTextView.font = UIFont.systemFont(ofSize: 14)
        messageInputBar.inputTextView.tintColor = Asset.Color.orange.color
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.backgroundView.backgroundColor = .clear
        messageInputBar.backgroundView.layer.borderColor = UIColor.clear.cgColor
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 0, right: 0)
        messageInputBar.inputTextView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        messageInputBar.backgroundColor = Asset.Color.dark.color
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.layer.cornerRadius = 10
        messageInputBar.middleContentViewPadding.top = 14
        messageInputBar.middleContentViewPadding.bottom = 14
        messageInputBar.topStackView.backgroundColor = .white
        scrollQuestionsView.contentInset.right = 16
        
        logoChat.image = Asset.Assets.dwatff.image
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        messagesCollectionView.addGestureRecognizer(tapGesture)
        
        let tapGetPremium = UITapGestureRecognizer(target: self, action: #selector(goPremium))
        lableGetPremium.addGestureRecognizer(tapGetPremium)
        lableGetPremium.isUserInteractionEnabled = true
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupConstraint() {
        messageInputBar.topStackView.addSubview(scrollQuestionsView)
        scrollQuestionsView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollQuestionsView.addSubview(stackView)
        messageInputBar.topStackView.addSubview(lableGetPremium)
        lableGetPremium.translatesAutoresizingMaskIntoConstraints = false
        messageInputBar.topStackView.addSubview(subtitle)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageInputBar.inputTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            messageInputBar.topStackView.heightAnchor.constraint(equalToConstant: 100),
            
            scrollQuestionsView.leadingAnchor.constraint(equalTo: messageInputBar.topStackView.leadingAnchor, constant: 16),
            scrollQuestionsView.trailingAnchor.constraint(equalTo: messageInputBar.topStackView.trailingAnchor, constant: 0),
            scrollQuestionsView.bottomAnchor.constraint(equalTo: messageInputBar.topStackView.bottomAnchor, constant: -10),
            scrollQuestionsView.topAnchor.constraint(equalTo: messageInputBar.topStackView.topAnchor, constant: 30),
            
            lableGetPremium.topAnchor.constraint(equalTo: messageInputBar.topStackView.topAnchor, constant: 2),
            lableGetPremium.trailingAnchor.constraint(equalTo: messageInputBar.topStackView.trailingAnchor, constant: 16),
            lableGetPremium.leadingAnchor.constraint(equalTo: subtitle.trailingAnchor, constant: 3),
            
            subtitle.topAnchor.constraint(equalTo: messageInputBar.topStackView.topAnchor, constant: 2),
            subtitle.centerXAnchor.constraint(equalTo: messageInputBar.topStackView.centerXAnchor, constant: -70),
            subtitle.leadingAnchor.constraint(equalTo: messageInputBar.topStackView.leadingAnchor, constant: 16),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: scrollQuestionsView.topAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollQuestionsView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollQuestionsView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollQuestionsView.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    private func localize() {
        titleChat.text = "title_chat".localized
        lableGetPremium.text = "get_premium".localized
        lableGetPremium.adjustsFontSizeToFitWidth = true
        subtitle.text = "subtitle_chat".localized
        subtitle.adjustsFontSizeToFitWidth = true
        messageInputBar.inputTextView.placeholder = " \("chat_message".localized)"
    }
    
    private func adjustMessageCollectionView(forKeyboardShow show: Bool, notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = show ? keyboardFrame.height : 0
        
        UIView.animate(withDuration: 0.3) {
            self.messagesCollectionView.contentInset.bottom = keyboardHeight + self.messageInputBar.frame.height + 10
            self.messagesCollectionView.scrollIndicatorInsets.bottom = keyboardHeight + self.messageInputBar.frame.height + 10
            
            if show, self.isLastSectionVisible() {
                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            }
        }
    }
    
    private func isLastSectionVisible() -> Bool {
        guard ((presenter?.messages.isEmpty) != nil) else {
            return false
        }
        let lastIndexPath = IndexPath(item: 0, section: (presenter?.messages.count)! - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
}

extension ChatViewController: MessagesDisplayDelegate{
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        return .zero
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if message.sender.senderId == currentSender.senderId {
            return .custom { view in
                view.backgroundColor = Asset.Color.original.color
                view.style = .bubbleTail(.bottomRight, .pointedEdge)
            }
        } else {
            return .custom { view in
                view.backgroundColor = Asset.Color.lightGray.color
                view.style = .bubbleTail(.bottomLeft, .pointedEdge)
            }
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        .black
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate {
    var currentSender: SenderType {
        guard let user = presenter?.user as? SenderType else { return [presenter?.user] as! SenderType }
        return user
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let messages = presenter?.messages as? [Message], indexPath.section < messages.count else {
            return DummyMessage()
        }
        
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return presenter?.messages.count ?? 0
    }
}

extension ChatViewController: ChatViewProtocol {
    func setupTips() {
        guard let tips = presenter?.tips else { return }
        for text in tips {
            let button = UIButton()
            button.setTitle(text.localized, for: .normal)
            button.backgroundColor = Asset.Color.originalBlue.color
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
        
        if tips.isEmpty {
            messageInputBar.topStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            if lableGetPremium.isHidden == true {
                messageInputBar.topStackView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            }
        }
    }
    
    func setViewPremium() {
        subtitle.isHidden = true
        lableGetPremium.isHidden = true
        
        if presenter?.tips.isEmpty ?? false {
            messageInputBar.topStackView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            scrollQuestionsView.topAnchor.constraint(equalTo: messageInputBar.topStackView.topAnchor, constant: 10).isActive = true
        } else {
            messageInputBar.topStackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            scrollQuestionsView.topAnchor.constraint(equalTo: messageInputBar.topStackView.topAnchor, constant: 10).isActive = true
        }
    }
    
    func hideLoader() {
        messageInputBar.sendButton.subviews.last?.isHidden = true
        messageInputBar.sendButton.setImage(Asset.Assets.sendArrow.image, for: .normal)
        
        guard let count = presenter?.messages.count else { return }
        switch count {
        case (0...2): self.subtitle.replaceCount(with: 3)
        case 3: self.subtitle.replaceCount(with: 2)
        case (3...5): self.subtitle.replaceCount(with: 1)
        default:  self.subtitle.replaceCount(with: 0)
        }
    }
    
    func reloadView() {
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
         
        guard let count = presenter?.messages.count else { return }
        switch count {
        case (0...2): self.subtitle.replaceCount(with: 3)
        case 3: self.subtitle.replaceCount(with: 2)
        case (3...5): self.subtitle.replaceCount(with: 1)
        default:  self.subtitle.replaceCount(with: 0)
        }
    }
}

