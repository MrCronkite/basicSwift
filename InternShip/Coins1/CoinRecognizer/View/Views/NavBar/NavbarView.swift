

import UIKit
import Moya

enum NavBarSetup {
    case nativ
    case close
    case back
    case folder
}

@objc protocol NavBarViewDelegate: AnyObject {
    @objc optional func showSettings()
    @objc optional func openWallet()
    @objc optional func close()
    @objc optional func goBack()
    @objc optional func delete()
}

@IBDesignable
final class NavbarView: UIView {
    
    weak var delegate: NavBarViewDelegate?
    private var provider: MoyaProvider<CollectionServices> = MoyaProvider<CollectionServices>()
    private var prices: [String] = []
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak private var settingsBtn: UIButton!
    @IBOutlet weak private var iconWallet: UIImageView!
    @IBOutlet weak private var subtitlePrice: UILabel!
    @IBOutlet weak private var walletPriceTitle: UILabel!
    @IBOutlet weak private var containerWallet: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        let idNameImage = (sender.currentImage?.accessibilityIdentifier)!
        switch idNameImage {
        case "settings": delegate?.showSettings?()
        case "close": delegate?.close?()
        case "delete": delegate?.delete?()
        default: break
        }
    }
    
    @IBAction func showWallet() {
        delegate?.openWallet?()
        containerWallet.addTapEffect()
    }
    
    @IBAction func goBackView(_ sender: Any) {
        delegate?.goBack?()
    }
}

extension NavbarView {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "NavbarView") else { return }
        view.frame = self.bounds
        view.backgroundColor = .clear
        self.addSubview(view)
        self.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(showWallet))
        containerWallet.isUserInteractionEnabled = true
        containerWallet.addGestureRecognizer(tap)
        
        walletPriceTitle.text = "$0"
        subtitlePrice.text = "ob_wallet".localized
        subtitlePrice.textColor = Asset.Color.textGray.color
        iconWallet.image = Asset.Assets.wallet1.image
        iconWallet.isUserInteractionEnabled = true
        let image = Asset.Assets.settings.image
        image.accessibilityIdentifier = "settings"
        settingsBtn.setImage(image, for: .normal)
        settingsBtn.setTitle("", for: .normal)
        walletPriceTitle.textColor = .black
        titleLable.textColor = .black
        buttonBack.setTitle("", for: .normal)
        buttonBack.setImage(Asset.Assets.back.image, for: .normal)
        
        if Activity.checkInthernet() {
            setWalletPrice()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.setWalletPrice()
            }
        }
    }
    
    func setupStyleNavBar(title: String, style: NavBarSetup) {
        switch style {
        case .nativ:
            titleLable.text = title
            buttonBack.isHidden = true
        case .close:
            buttonBack.isHidden = true
            titleLable.text = title
            let image = Asset.Assets.close.image
            image.accessibilityIdentifier = "close"
            settingsBtn.setImage(image, for: .normal)
        case .back:
            titleLable.text = title
            containerWallet.isHidden = true
            settingsBtn.isHidden = true
        case .folder:
            titleLable.text = title
            containerWallet.isHidden = true
            let image = Asset.Assets.delete.image
            image.accessibilityIdentifier = "delete"
            settingsBtn.setImage(image, for: .normal)
        }
    }
    
    func setWalletPrice() {
        provider.request(.getCoinsList) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let result = try response.map(CollectionCoins.self)
                    self.prices = []
                    result.results.forEach { item in
                        self.prices.append(item.reference.priceTo)
                    }
                  //  self.updateLabelsWithStrings(self.prices)
                } catch {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        }
    }
    
    private func updateLabelsWithStrings(_ strings: [String]) {
        var currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            UIView.transition(with: self.walletPriceTitle, duration: 0.7, options: .transitionCrossDissolve, animations: {
                self.walletPriceTitle.text = strings[currentIndex]
            }, completion: nil)
            
            currentIndex = (currentIndex + 1) % strings.count
        }
    }
}
 

