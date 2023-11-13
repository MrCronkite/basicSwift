

import UIKit
import Lottie
import GoogleMobileAds
import Reachability

protocol SubscribeCameraViewControllerDelegate: AnyObject {
    func showMatchesStone()
    func closeCamera()
}

final class SubscribeCameraViewController: UIViewController {
    
    var image = UIImage()
    private let googleAd = GoogleAd()
    private let animationView = LottieAnimationView(name: "startAnim")
    weak var delegate: SubscribeCameraViewControllerDelegate?
    
    @IBOutlet weak var priceStone: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var bgViewSearching: UIView!
    @IBOutlet weak var imgSearching: UIImageView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var animeView: UIView!
    @IBOutlet weak var btnAd: UIButton!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var viewAnimateStar: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleOpen: UILabel!
    @IBOutlet weak var separator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
        setupAnimation()
        AnalyticsManager.shared.logEvent(name: Events.open_view_match_subscribe)
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func closeVC(_ sender: Any) {
        AnalyticsManager.shared.logEvent(name: Events.close_view_match_subscribe)
        dismiss(animated: true)
        delegate?.closeCamera()
    }
    
    @IBAction func showAd(_ sender: Any) {
        GoogleAd.shared.showRewardInter(view: self)
        
        GoogleAd.shared.adViewedAction = { [weak self] in
            guard let self = self else { return }
            self.delegate?.showMatchesStone()
            self.btnAd.isEnabled = true
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func subscribeAd(_ sender: Any) {
        let vc = GetPremiumViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension SubscribeCameraViewController {
    private func setupView() {
        bgView.layer.cornerRadius = 20
        imgSearch.contentMode = .scaleAspectFill
        imgSearch.clipsToBounds = true
        imgSearch.layer.cornerRadius = 14
        imgSearch.image = image
        separator.layer.cornerRadius = 3
        
        bgViewSearching.layer.cornerRadius = 20
        imgSearching.contentMode = .scaleAspectFill
        imgSearching.clipsToBounds = true
        imgSearching.layer.cornerRadius = 14
        priceView.layer.cornerRadius = 13
        
        btnAd.layer.cornerRadius = 25
        btnSubscribe.layer.cornerRadius = 25
        let blurEffect = UIBlurEffect(style: R.Strings.Camera.styles.randomElement()!)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.imgSearching.bounds
        
        imgSearching.addSubview(blurView)
        
        let randomNumberUp = (Int.random(in: (20 / 10)...(200 / 10)) * 10)
        let randomNumbeTo = (Int.random(in: (500 / 10)...(20000 / 10)) * 10)
        priceStone.text = "$\(randomNumberUp) - $\(randomNumbeTo) / ct"
    }
    
    private func setupAnimation() {
        animationView.frame = CGRect(x: 0, y: 0, width: 380, height: 330)
        viewAnimateStar.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        viewAnimateStar.addSubview(animationView)
        
        animationView.play()
    }
    
    private func localize() {
        closeButton.setTitle("", for: .normal)
        titleView.text = "cam_sub_title".localized
        titleView.adjustsFontSizeToFitWidth = true
        titleOpen.text = "cam_sub_title_open".localized
        subtitle.text = "cam_sub_subtitle".localized
        btnAd.setTitle("cam_sub_btn_ad".localized, for: .normal)
        btnSubscribe.setTitle("cam_sub_btn_sub".localized, for: .normal)
    }
}
