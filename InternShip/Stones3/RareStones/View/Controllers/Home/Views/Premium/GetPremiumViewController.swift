

import UIKit
import GoogleMobileAds
import Reachability


final class GetPremiumViewController: UIViewController {
    
    private let pulseLayer = CALayer()
    private var tapSkip: UITapGestureRecognizer?
    private var tapRestore: UITapGestureRecognizer?
    
    @IBOutlet weak var txtTile: UILabel!
    @IBOutlet weak var perWeekTile: UILabel!
    @IBOutlet weak var heightConstrint: NSLayoutConstraint!
    @IBOutlet weak var subtitle4: UILabel!
    @IBOutlet weak var subtitle3: UILabel!
    @IBOutlet weak var subtitle2: UILabel!
    @IBOutlet weak var subtitle1: UILabel!
    @IBOutlet weak var bestPriceLable: UILabel!
    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var btnOffer: UIButton!
    @IBOutlet weak var skipTxt: UILabel!
    @IBOutlet weak var restoreTxt: UILabel!
    @IBOutlet weak var termTxt: UILabel!
    @IBOutlet weak var privacyPolTxt: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    @IBOutlet weak var subtitlePrice4: UILabel!
    @IBOutlet weak var mainPrice: UILabel!
    @IBOutlet weak var subtitlePrice3: UILabel!
    @IBOutlet weak var subtitlePrice2: UILabel!
    @IBOutlet weak var subtitlePrice1: UILabel!
    @IBOutlet weak var introPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupView()
        localizePrice()
        
        TimerManager.shared.startTimer()
        AnalyticsManager.shared.logEvent(name: Events.get_premium_view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPulsingAnimation()
    }
    
    @IBAction func updateUI() {
        let remainingTime = TimerManager.shared.remainingTime
        let formattedTime = formatTimeInterval(remainingTime)
        timer.text = formattedTime
        UIView.animate(withDuration: 0.6) {
            self.timer.alpha = 1
        }
        if formattedTime == "00:00:00" {
            heightConstrint.constant = 0
        }
    }
    
    @IBAction func getOffer(_ sender: Any) {
        AnalyticsManager.shared.logEvent(name: Events.premium_button)
        btnOffer.isEnabled = false
        if LoadingIndicator.checkInthernet() {
            DispatchQueue.main.async {
                LoadingIndicator.showActivityIndicatorFromView(view: self)
            }
            Purchase.shared.purchase(product: R.Strings.KeyProduct.idPremium) { [weak self] result in
                guard let self = self else { return }
                LoadingIndicator.hideActivityIndicatorFromView()
                if result {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.btnOffer.isEnabled = true
                        self.dismiss(animated: true)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.btnOffer.isEnabled = true
                        self.loadAd(isClose: false)
                    }
                }
            }
        } else {
            LoadingIndicator.alertNoEthernet(view: self)
            btnOffer.isEnabled = true
       }
    }
    
    @IBAction func restore() {
        tapRestore?.isEnabled = false
        AnalyticsManager.shared.logEvent(name: Events.premium_restore)
        if LoadingIndicator.checkInthernet() {
            DispatchQueue.main.async {
                LoadingIndicator.showActivityIndicatorFromView(view: self)
            }
            Purchase.shared.restore { [weak self] result in
                guard let self = self else { return }
                self.tapRestore?.isEnabled = true
                LoadingIndicator.hideActivityIndicatorFromView()
                if result {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.dismiss(animated: true)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        LoadingIndicator.alert(title: "alert_no_restore".localized)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            self.loadAd(isClose: false)
                        }
                    }
                }
            }
        } else {
            LoadingIndicator.alertNoEthernet(view: self)
            tapRestore?.isEnabled = true
        }
    }
    
    @IBAction func goBack() {
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            self.dismiss(animated: true)
        } else {
            loadAd(isClose: true)
        }
        AnalyticsManager.shared.logEvent(name: Events.get_premium_skip)
        
    }
    
    @IBAction func goTermOfUse() {
        guard let url = URL(string: R.Strings.Links.terms) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    @IBAction func goPolicy() {
        guard let url = URL(string: R.Strings.Links.privacy) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    @IBAction func appWillEnterForeground() {
        setupPulsingAnimation()
    }
}

extension GetPremiumViewController {
    private func setupView() {
        txtTile.shadowColor = UIColor.black
        txtTile.shadowOffset = CGSize(width: 2, height: 2)
        perWeekTile.shadowColor = UIColor.black
        perWeekTile.shadowOffset = CGSize(width: 2, height: 2)
        btnOffer.layer.cornerRadius = 25
        imageBg.contentMode = .scaleAspectFill
        timer.alpha = 0
        
        tapSkip = UITapGestureRecognizer(target: self, action: #selector(goBack))
        skipTxt.addGestureRecognizer(tapSkip!)
        skipTxt.isUserInteractionEnabled = true
        
        tapRestore = UITapGestureRecognizer(target: self, action: #selector(restore))
        restoreTxt.addGestureRecognizer(tapRestore!)
        restoreTxt.isUserInteractionEnabled = true
        
        let tapTermUse = UITapGestureRecognizer(target: self, action: #selector(goTermOfUse))
        termTxt.addGestureRecognizer(tapTermUse)
        termTxt.isUserInteractionEnabled = true
        
        let tapPolicy = UITapGestureRecognizer(target: self, action: #selector(goPolicy))
        privacyPolTxt.addGestureRecognizer(tapPolicy)
        privacyPolTxt.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("TimerTickNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func localizePrice() {
        Purchase.shared.getProduct(for: R.Strings.KeyProduct.idPremium) { [weak self] product in
            guard let self = self else { return }
            if let product = product {
                self.txtTile.text = product.introductoryPrice?.localizedPrice
                self.introPrice.text = product.introductoryPrice?.localizedPrice
                self.mainPrice.text = product.localizedPrice
            }
        }
    }
    
    private func loadAd(isClose: Bool) {
        if GoogleAd.shared.showInter(view: self) {
            self.dismiss(animated: true)
            self.tapSkip?.isEnabled = false
        }
        
        GoogleAd.shared.adViewedAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                guard let self = self else { return }
                self.tapSkip?.isEnabled = true
            }
            
            if isClose {
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
        }
    }
    
    private func setupPulsingAnimation() {
        pulseLayer.cornerRadius = 25
        pulseLayer.backgroundColor = UIColor.white.cgColor
        pulseLayer.zPosition = -1
        pulseLayer.frame = btnOffer.bounds
        btnOffer.layer.insertSublayer(pulseLayer, below: btnOffer.layer)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.7
        animation.fromValue = 0.9
        animation.toValue = 1.1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulseLayer.add(animation, forKey: "pulsing")
    }
    
    private func localize() {
        perWeekTile.text = "pr_week".localized
        perWeekTile.adjustsFontSizeToFitWidth = true
        bestPriceLable.text = "pr_best_price".localized
        bestPriceLable.adjustsFontSizeToFitWidth = true
        subtitle1.text = "onb_free_first".localized
        subtitle2.text = "onb_free_second".localized
        subtitle3.text = "onb_free_third".localized
        subtitle4.text = "onb_free_fourtin".localized
        btnOffer.setTitle("pr_btn".localized, for: .normal)
        restoreTxt.text = "onb_free_restore".localized
        restoreTxt.adjustsFontSizeToFitWidth = true
        termTxt.text = "onb_free_term_us".localized
        termTxt.adjustsFontSizeToFitWidth = true
        privacyPolTxt.text = "onb_free_private".localized
        privacyPolTxt.adjustsFontSizeToFitWidth  = true
        skipTxt.text = "onb_free_skip".localized
        subtitlePrice1.text = "prem_sub_price1".localized
        subtitlePrice2.text = "prem_sub_price2".localized
        subtitlePrice3.text = "prem_sub_price3".localized
        subtitlePrice4.text = "prem_sub_price4".localized
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: interval) ?? "00:00:00"
    }
}
