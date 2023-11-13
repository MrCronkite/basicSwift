

import UIKit
import GoogleMobileAds
import Reachability

protocol SubDetectorViewControllerDelegate: AnyObject {
    func showAdd()
}

final class SubDetectorViewController: UIViewController {
    
    private let googleAd = GoogleAd()
    weak var delegate: SubDetectorViewControllerDelegate?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var imgViewBg: UIImageView!
    @IBOutlet weak var btnWatch: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        AnalyticsManager.shared.logEvent(name: Events.open_subscribe_or_ad_view)
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func closeVc(_ sender: Any) {
        AnalyticsManager.shared.logEvent(name: Events.close_subscribe_or_ad_view)
        dismiss(animated: true)
    }
    
    @IBAction func watchAd(_ sender: Any) {
        if checkInternet() {
            loadAd()
        }
    }
    
    @IBAction func goSub(_ sender: Any) {
        let vc = GetPremiumViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension SubDetectorViewController {
    private func setupView() {
        imgViewBg.contentMode = .scaleAspectFill
        btnSub.layer.cornerRadius = 25
        btnWatch.layer.cornerRadius = 25
        separator.layer.cornerRadius = 2
        
        self.btnSub.makeAnimationButton(self.btnSub)
        self.btnWatch.makeAnimationButton(self.btnWatch)
        titleLable.text = "detect_sub_title".localized
        subtitle.text = "detect_sub_subtitle".localized
        btnSub.setTitle("cam_sub_btn_sub".localized, for: .normal)
        btnWatch.setTitle("cam_sub_btn_ad".localized, for: .normal)
        closeButton.setTitle("", for: .normal)
    }
    
    private func loadAd() {
        GoogleAd.shared.showRewardInter(view: self)
    
        GoogleAd.shared.adViewedAction = { [weak self] in
            guard let self = self else { return }
            self.delegate?.showAdd()
            self.btnWatch.isEnabled = false
            dismiss(animated: true)
        }
    }
    
    private func checkInternet() -> Bool {
        if let reachability = Reachability.forInternetConnection() {
            if reachability.isReachable() {
                return true
            } else {
                LoadingIndicator.alert(title: "alert_no_internet".localized)
                return false
            }
        }
        return false
    }
}




