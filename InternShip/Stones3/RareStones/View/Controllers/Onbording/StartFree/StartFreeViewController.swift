

import UIKit
import Lottie
import GoogleMobileAds
import Reachability

protocol StartFreeViewControllerDelegate: AnyObject {
    func showButton()
}

final class StartFreeViewController: UIViewController {
    
    weak var delegate: StartFreeViewControllerDelegate?
    
    private var animation: LottieAnimationView?
    private let pulseLayer = CALayer()
    private var tapSkip: UITapGestureRecognizer?
    private var tapRestore: UITapGestureRecognizer?
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAnimateContainer: UIView!
    @IBOutlet weak var privatePolTxt: UILabel!
    @IBOutlet weak var restoreTxt: UILabel!
    @IBOutlet weak var termUseTxt: UILabel!
    @IBOutlet weak var skipTxt: UILabel!
    @IBOutlet weak var btnSetFree: UIButton!
    @IBOutlet weak var freeLableFourtin: UILabel!
    @IBOutlet weak var freeLableThird: UILabel!
    @IBOutlet weak var freeLableSecond: UILabel!
    @IBOutlet weak var freeLableFirst: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    
    @IBOutlet weak var price1: UILabel!
    @IBOutlet weak var mainPrice: UILabel!
    @IBOutlet weak var price2: UILabel!
    @IBOutlet weak var price3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupView()
        setupAnimation()
        localizePrice()
        
        Purchase.shared.getProduct(for: R.Strings.KeyProduct.idSub) { product in
            if let product = product {
                self.mainPrice.text = product.localizedPrice
            }
        }
        AnalyticsManager.shared.logEvent(name: Events.view_subscription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupPulsingAnimation()
        delegate?.showButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.7) {
            self.btnSetFree.backgroundColor = .clear
            self.btnSetFree.tintColor = .clear
        }
    }
    
    override func viewDidLayoutSubviews() {
        animation!.frame = viewAnimateContainer.bounds
        view.setupLayer()
    }
    
    @IBAction func getOffer(_ sender: Any) {
        AnalyticsManager.shared.logEvent(name: Events.open_offer_subscription)
        btnSetFree.isEnabled = false
        tapRestore?.isEnabled = false
        if LoadingIndicator.checkInthernet() {
            DispatchQueue.main.async {
                LoadingIndicator.showActivityIndicatorFromView(view: self)
            }
            Purchase.shared.purchase(product: R.Strings.KeyProduct.idSub) { [weak self] result in
                guard let self = self else { return }
                LoadingIndicator.hideActivityIndicatorFromView()
                if result {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.btnSetFree.isEnabled = true
                        self.tapRestore?.isEnabled = true
                        self.goToTabBar()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.btnSetFree.isEnabled = true
                        self.showAd(isClose: false)
                        self.tapRestore?.isEnabled = true
                    }
                }
            }
        } else {
            LoadingIndicator.alertNoEthernet(view: self)
            btnSetFree.isEnabled = true
            tapRestore?.isEnabled = true
        }
    }
    
    @IBAction func restore() {
        AnalyticsManager.shared.logEvent(name: Events.open_restore_subscription)
        tapRestore?.isEnabled = false
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
                        LoadingIndicator.alert(title: "alert_restore".localized)
                        self.goToTabBar()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        LoadingIndicator.alert(title: "alert_no_restore".localized)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            self.showAd(isClose: false)
                        }
                    }
                }
            }
        } else {
            LoadingIndicator.alertNoEthernet(view: self)
            tapRestore?.isEnabled = true
        }
    }
    
    @IBAction func goSkip() {
        AnalyticsManager.shared.logEvent(name: Events.skip_view_subscription)
        showAd(isClose: true)
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
        btnSetFree.isHidden = false
        setupPulsingAnimation()
    }
}

extension StartFreeViewController {
    private func setupView() {
        btnSetFree.backgroundColor = R.Colors.roseBtn
        btnSetFree.layer.cornerRadius = 25
        
        let text = subtitleText.text ?? ""
        let words = "atribute_string_open".localized
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: words)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: R.Colors.darkGrey, range: range)
            subtitleText.attributedText = attributedString
        }
        
        tapSkip = UITapGestureRecognizer(target: self, action:  #selector(goSkip))
        skipTxt.addGestureRecognizer(tapSkip!)
        skipTxt.isUserInteractionEnabled = true
        
        tapRestore = UITapGestureRecognizer(target: self, action: #selector(restore))
        restoreTxt.addGestureRecognizer(tapRestore!)
        restoreTxt.isUserInteractionEnabled = true
        
        let tapTermUse = UITapGestureRecognizer(target: self, action: #selector(goTermOfUse))
        termUseTxt.addGestureRecognizer(tapTermUse)
        termUseTxt.isUserInteractionEnabled = true
        
        let tapPolicy = UITapGestureRecognizer(target: self, action: #selector(goPolicy))
        privatePolTxt.addGestureRecognizer(tapPolicy)
        privatePolTxt.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        let textSize = (text.localized as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
    }
    
    private func localize() {
        subtitleText.text = "onb_sub_third".localized
        let textSize = ("onb_sub_third".localized as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32)])
        widthConstraint.constant = min(textSize.width / 1.5, 340)
        subtitleText.adjustsFontSizeToFitWidth = true
        freeLableFirst.text = "onb_free_first".localized
        freeLableSecond.text = "onb_free_second".localized
        freeLableThird.text = "onb_free_third".localized
        freeLableFourtin.text = "onb_free_fourtin".localized
        btnSetFree.setTitle("onb_free_btn".localized, for: .normal)
        restoreTxt.text = "onb_free_restore".localized
        restoreTxt.adjustsFontSizeToFitWidth = true
        termUseTxt.text = "onb_free_term_us".localized
        privatePolTxt.text = "onb_free_private".localized
        privatePolTxt.adjustsFontSizeToFitWidth = true
        skipTxt.text = "onb_free_skip".localized
        price1.text = "subprice_1".localized
        price2.text = "subprice_2".localized
        price3.text = "subprice_3".localized
    }
    
    private func setupPulsingAnimation() {
        UIView.animate(withDuration: 0.7) {
            self.btnSetFree.isHidden = false
            self.btnSetFree.backgroundColor = R.Colors.roseBtn
            self.btnSetFree.tintColor = .white
        }
        
        pulseLayer.cornerRadius = 25
        pulseLayer.backgroundColor = R.Colors.roseBtn.cgColor
        pulseLayer.zPosition = -1
        pulseLayer.frame = btnSetFree.bounds
        btnSetFree.layer.insertSublayer(pulseLayer, below: btnSetFree.layer)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.7
        animation.fromValue = 0.9
        animation.toValue = 1.1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulseLayer.add(animation, forKey: "pulsing")
    }
    
    private func localizePrice() {
        Purchase.shared.getProduct(for: R.Strings.KeyProduct.idPremium) { [weak self] product in
            guard let self = self else { return }
            if let product = product {
                self.mainPrice.text = product.localizedPrice
            }
        }
    }
    
    private func setupAnimation() {
        animation = .init(name: "Animstone4")
        animation?.contentMode = .scaleAspectFit
        animation?.loopMode = .loop
        animation?.animationSpeed = 1.5
        viewAnimateContainer.addSubview(animation!)
        animation?.play()
    }
    
    private func showAd(isClose: Bool) {
        if GoogleAd.shared.showInter(view: self) {
            self.tapSkip?.isEnabled = false
            self.goToTabBar()
        }
        
        GoogleAd.shared.adViewedAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                guard let self = self else { return }
                self.tapSkip?.isEnabled = true
            }
            if isClose {
                guard let self = self else { return }
                self.goToTabBar()
            }
        }
    }
    
    private func goToTabBar() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController = tabBarController
        present(tabBarController, animated: true)
    }
}
