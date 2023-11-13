

import UIKit

final class PayWallViewController: UIViewController {
    
    var presenter: PayWallPresenter?
    var showButton: (() -> Void)?
    private let pulseLayer = CALayer()
    private var tapRestore: UITapGestureRecognizer?
    
    @IBOutlet weak private var titleView: UILabel!
    @IBOutlet weak private var imageBackgraund: UIImageView!
    @IBOutlet weak private var containerPrice: UIView!
    @IBOutlet weak private var containerRecognizer: UIView!
    @IBOutlet weak private var containerHelper: UIView!
    @IBOutlet weak private var containerCollection: UIView!
    @IBOutlet weak private var containerAds: UIView!
    @IBOutlet weak private var lableRecognizer: UILabel!
    @IBOutlet weak private var lableHelper: UILabel!
    @IBOutlet weak private var lableCollection: UILabel!
    @IBOutlet weak private var lableNoAds: UILabel!
    @IBOutlet weak private var lablePrice: UILabel!
    @IBOutlet weak private var lableWeek: UILabel!
    @IBOutlet weak private var lableSubtitleTrial: UILabel!
    @IBOutlet weak private var lableAuroRenewable: UILabel!
    @IBOutlet weak private var lableTerm: UILabel!
    @IBOutlet weak private var lableRestore: UILabel!
    @IBOutlet weak private var lablePrivacy: UILabel!
    @IBOutlet weak private var purchaseButton: UIButton!
    @IBOutlet weak private var img4: UIImageView!
    @IBOutlet weak private var img3: UIImageView!
    @IBOutlet weak private var img2: UIImageView!
    @IBOutlet weak private var img1: UIImageView!
    @IBOutlet weak private var btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        AnaliticsService.shared.logEvent(name: Events.view_subscription)
    }
    
    override func viewDidLayoutSubviews() {
        lablePrice.text = presenter?.product?.localizedPrice ?? "$9.99"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setAnimation()
        showButton?()
    }
    
    @IBAction func purchase(_ sender: Any) {
        btnClose.isEnabled = false
        tapRestore?.isEnabled = false
        purchaseButton.isEnabled = false
        presenter?.goToPurchase()
    }
    
    @IBAction func close(_ sender: Any) {
        btnClose.isEnabled = false
        tapRestore?.isEnabled = false
        purchaseButton.isEnabled = false
        presenter?.goToTabBar()
    }
    
    @IBAction func enterForeground() {
        setAnimation()
    }
    
    @IBAction private func goToTerm() {
        presenter?.goToTerm()
    }
    
    @IBAction private func goRestore() {
        btnClose.isEnabled = false
        tapRestore?.isEnabled = false
        purchaseButton.isEnabled = false
        presenter?.goToRestore()
    }
    
    @IBAction private func goToPrivacy() {
        presenter?.goToPrivacy()
    }
}

private extension PayWallViewController {
    func setupView() {
        view.backgroundColor = Asset.Color.dark.color
        imageBackgraund.image = Asset.Assets.shine.image
        imageBackgraund.contentMode = .scaleToFill
        btnClose.setImage(Asset.Assets.close.image, for: .normal)
        btnClose.setTitle("", for: .normal)
        containerRecognizer.layer.cornerRadius = 17
        containerRecognizer.layer.borderWidth = 6
        containerRecognizer.layer.borderColor = Asset.Color.grey.color.cgColor
        containerAds.layer.cornerRadius = 17
        containerAds.layer.borderWidth = 6
        containerAds.layer.borderColor = Asset.Color.grey.color.cgColor
        containerHelper.layer.cornerRadius = 17
        containerHelper.layer.borderWidth = 6
        containerHelper.layer.borderColor = Asset.Color.grey.color.cgColor
        containerCollection.layer.cornerRadius = 17
        containerCollection.layer.borderWidth = 6
        containerCollection.layer.borderColor = Asset.Color.grey.color.cgColor
        titleView.adjustsFontSizeToFitWidth = true
        
        img1.image = Asset.Assets.dollarLog.image
        img2.image = Asset.Assets.dollarLog.image
        img3.image = Asset.Assets.dollarLog.image
        img4.image = Asset.Assets.dollarLog.image
        
        containerPrice.layer.cornerRadius = 15
        containerPrice.layer.borderColor = Asset.Color.orange.color.cgColor
        containerPrice.layer.borderWidth = 2
        
        purchaseButton.tintColor = .white
        purchaseButton.layer.cornerRadius = 26
        purchaseButton.backgroundColor = Asset.Color.orange.color
        
        let tapGoToTermOfUse = UITapGestureRecognizer(target: self, action: #selector(goToTerm))
        lableTerm.isUserInteractionEnabled = true
        lableTerm.addGestureRecognizer(tapGoToTermOfUse)
        
        let tapGoToPrivacy = UITapGestureRecognizer(target: self, action: #selector(goToPrivacy))
        lablePrivacy.isUserInteractionEnabled = true
        lablePrivacy.adjustsFontSizeToFitWidth = true
        lablePrivacy.addGestureRecognizer(tapGoToPrivacy)
        
        tapRestore = UITapGestureRecognizer(target: self, action: #selector(goRestore))
        lableRestore.isUserInteractionEnabled = true
        lableRestore.addGestureRecognizer(tapRestore!)
    }
    
    func localize() {
        purchaseButton.setTitle("ob_button".localized, for: .normal)
        titleView.text = "ob_premium".localized
        lableTerm.text = "term_of_use".localized
        lableRestore.text = "restore".localized
        lablePrivacy.text = "privacy".localized
        lableAuroRenewable.text = "auto_renewable".localized
        lableWeek.text = "ob_week".localized
        lableSubtitleTrial.text = "ob_free".localized
        lableNoAds.text = "ob_no_ads".localized
        lableRecognizer.text = "ob_no_recognition".localized
        lableCollection.text = "ob_no_collection".localized
        lableHelper.text = "ob_no_ai_helper".localized
    }
    
    func setAnimation() {
        pulseLayer.cornerRadius = 25
        pulseLayer.backgroundColor = Asset.Color.orange.color.cgColor
        pulseLayer.zPosition = -1
        pulseLayer.frame = purchaseButton.bounds
        purchaseButton.layer.insertSublayer(pulseLayer, below: purchaseButton.layer)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.7
        animation.fromValue = 0.9
        animation.toValue = 1.1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseLayer.add(animation, forKey: "pulsing")
    }
}

extension PayWallViewController: PayWallViewProtocol {
    func enabledButton() {
        btnClose.isEnabled = true
        tapRestore?.isEnabled = true
        purchaseButton.isEnabled = true
    }
}
