

import UIKit

final class PremiumViewController: UIViewController {
    
    var presenter: PremiumPresenter?
    private let pulseLayer = CALayer()
    private var tapRestore: UITapGestureRecognizer?
    
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var buttonPurchase: UIButton!
    @IBOutlet weak private var secondsContainer: UIView!
    @IBOutlet weak private var minutsContainer: UIView!
    @IBOutlet weak private var hoursContainer: UIView!
    @IBOutlet weak private var priceFirstWeek: UILabel!
    @IBOutlet weak private var subtitleFirstWeek: UILabel!
    @IBOutlet weak private var lableSpecial: UILabel!
    @IBOutlet weak private var mainTitleOffer: UILabel!
    @IBOutlet weak private var logo1: UIImageView!
    @IBOutlet weak private var logo2: UIImageView!
    @IBOutlet weak private var logo3: UIImageView!
    @IBOutlet weak private var logo4: UIImageView!
    @IBOutlet weak private var lableSeconds: UILabel!
    @IBOutlet weak private var lableMinuts: UILabel!
    @IBOutlet weak private var lableHours: UILabel!
    @IBOutlet weak private var lableNoAds: UILabel!
    @IBOutlet weak private var lableCollection: UILabel!
    @IBOutlet weak private var lableHelper: UILabel!
    @IBOutlet weak private var lableRecognition: UILabel!
    @IBOutlet weak private var lableThen: UILabel!
    @IBOutlet weak private var lableweek: UILabel!
    @IBOutlet weak private var lableFullPriceWeek: UILabel!
    @IBOutlet weak private var lableAutoRenewable: UILabel!
    @IBOutlet weak private var lableRestore: UILabel!
    @IBOutlet weak private var lablePolicy: UILabel!
    @IBOutlet weak private var lableTerms: UILabel!
    @IBOutlet weak private var bgImage: UIImageView!
    @IBOutlet weak private var timerContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setAnimation()
    }
    
    @IBAction func purchase(_ sender: Any) {
        buttonPurchase.isEnabled = false
        closeButton.isEnabled = false
        presenter?.goToPurchase()
    }
    
    @IBAction func close(_ sender: Any) {
        buttonPurchase.isEnabled = true
        closeButton.isEnabled = true
        tapRestore?.isEnabled = true
        presenter?.popToRoot()
    }
    
    @IBAction private func goToTerm() {
        presenter?.goToTerm()
    }
    
    @IBAction private func goToPrivacy() {
        presenter?.goToPrivacy()
    }
    
    @IBAction private func goToRestore() {
        buttonPurchase.isEnabled = true
        closeButton.isEnabled = true
        presenter?.goToRestore()
    }
    
    @objc func enterForeground() {
        setAnimation()
    }
}

private extension PremiumViewController {
    func setupView() {
        tabBarController?.tabBar.isHidden = true
        secondsContainer.layer.cornerRadius = 16
        secondsContainer.dropShadow(color: .black.withAlphaComponent(0.7), offSet: .init(width: 5, height: 5), cornerRadius: 16)
        minutsContainer.layer.cornerRadius = 16
        minutsContainer.dropShadow(color: .black.withAlphaComponent(0.7), offSet: .init(width: 5, height: 5), cornerRadius: 16)
        hoursContainer.layer.cornerRadius = 16
        hoursContainer.dropShadow(color: .black.withAlphaComponent(0.7), offSet: .init(width: 5, height: 5), cornerRadius: 16)
        
        logo1.image = Asset.Assets.dollarLog.image
        logo2.image = Asset.Assets.dollarLog.image
        logo3.image = Asset.Assets.dollarLog.image
        logo4.image = Asset.Assets.dollarLog.image
        timerContainerView.alpha = 0
        
        let fullGradient = UIImage.gradientImage(bounds: mainTitleOffer.bounds, colors: [Asset.Color.gold1.color, Asset.Color.gold3.color])
        let gradientSpecial = UIImage.gradientImage(bounds: lableSpecial.bounds, colors: [Asset.Color.gold1.color, Asset.Color.gold3.color])
        lableSpecial.textColor = UIColor(patternImage: gradientSpecial)
        lableSpecial.layer.shadowColor = Asset.Color.shadow.color.cgColor
        lableSpecial.layer.shadowOffset = .init(width: 3, height: 3)
        lableSpecial.layer.shadowRadius = 1
        lableSpecial.layer.shadowOpacity = 1
        
        mainTitleOffer.textColor = UIColor(patternImage: fullGradient)
        mainTitleOffer.layer.shadowColor = Asset.Color.shadow.color.cgColor
        mainTitleOffer.layer.shadowOffset = .init(width: 4, height: 4)
        mainTitleOffer.layer.shadowRadius = 1
        mainTitleOffer.layer.shadowOpacity = 1
        
        priceFirstWeek.textColor = Asset.Color.gold1.color
        priceFirstWeek.layer.shadowColor = Asset.Color.shadow.color.cgColor
        priceFirstWeek.layer.shadowOffset = .init(width: 2, height: 2)
        priceFirstWeek.layer.shadowRadius = 1
        priceFirstWeek.layer.shadowOpacity = 1
        
        subtitleFirstWeek.textColor = Asset.Color.gold1.color
        subtitleFirstWeek.layer.shadowColor = Asset.Color.shadow.color.cgColor
        subtitleFirstWeek.layer.shadowOffset = .init(width: 2, height: 2)
        subtitleFirstWeek.layer.shadowRadius = 1
        subtitleFirstWeek.layer.shadowOpacity = 1
        
        buttonPurchase.backgroundColor = Asset.Color.orange.color
        buttonPurchase.tintColor = .white
        buttonPurchase.layer.cornerRadius = 26
        buttonPurchase.titleLabel?.textAlignment = .center
        
        closeButton.setImage(Asset.Assets.close.image, for: .normal)
        closeButton.setTitle("", for: .normal)
        
        let tapGoToTermOfUse = UITapGestureRecognizer(target: self, action: #selector(goToTerm))
        lableTerms.isUserInteractionEnabled = true
        lableTerms.adjustsFontSizeToFitWidth = true
        lableTerms.addGestureRecognizer(tapGoToTermOfUse)
        
        let tapGoToPrivacy = UITapGestureRecognizer(target: self, action: #selector(goToPrivacy))
        lablePolicy.isUserInteractionEnabled = true
        lablePolicy.adjustsFontSizeToFitWidth = true
        lablePolicy.addGestureRecognizer(tapGoToPrivacy)
        
        tapRestore = UITapGestureRecognizer(target: self, action: #selector(goToRestore))
        lableRestore.isUserInteractionEnabled = true
        lableRestore.addGestureRecognizer(tapRestore!)
        
        bgImage.image = Asset.Assets.bgImage.image
    }
    
    func localize() {
        buttonPurchase.setTitle("premium_button".localized, for: .normal)
        lableweek.text = "ob_week".localized
        lableRestore.text = "restore".localized
        lableTerms.text = "term_of_use".localized
        lablePolicy.text = "privacy".localized
        lableAutoRenewable.text = "auto_renewable".localized
        lableThen.text = "prem_then".localized
        lableFullPriceWeek.text = "8.99$"
        subtitleFirstWeek.text = "first_week".localized
        priceFirstWeek.text = "0.99$"
        lableNoAds.text = "ob_no_ads".localized
        lableCollection.text = "ob_no_collection".localized
        lableHelper.text = "ob_no_ai_helper".localized
        lableRecognition.text = "ob_no_recognition".localized
        mainTitleOffer.text = "-90%"
        lableSpecial.text = "prem_special".localized
        lableSpecial.adjustsFontSizeToFitWidth = true
        
        lableFullPriceWeek.text = presenter?.product?.localizedPrice ?? "8.99$"
        priceFirstWeek.text = presenter?.product?.introductoryPrice?.localizedPrice ?? "0.99$"
    }
    
    func setAnimation() {
        pulseLayer.cornerRadius = 25
        pulseLayer.backgroundColor = Asset.Color.orange.color.cgColor
        pulseLayer.zPosition = -1
        pulseLayer.frame = buttonPurchase.bounds
        buttonPurchase.layer.insertSublayer(pulseLayer, below: buttonPurchase.layer)
        
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

extension PremiumViewController: PremiumViewProtocol {
    func enableButtons() {
        buttonPurchase.isEnabled = true
        closeButton.isEnabled = true
    }
    
    func updateTimer(timer: String) {
        let components = timer.components(separatedBy: ":")
        
        if Int(components[1])! == 0 {
            timerContainerView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5) {
            self.timerContainerView.alpha = 1
        }
        
        if components.count == 3 {
            if let hours = Int(components[0]),
                let minutes = Int(components[1]),
                let seconds = Int(components[2]) {
                
                lableSeconds.text = String(format: "%02d", hours)
                lableMinuts.text = String(format: "%02d", minutes)
                lableHours.text = String(format: "%02d", seconds)
            }
        }
    }
}

