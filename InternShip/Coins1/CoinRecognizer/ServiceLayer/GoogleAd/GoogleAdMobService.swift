

import UIKit
import GoogleMobileAds

protocol GoogleAdMobService {
    var adViewedAction: (() -> Void)? { get set }
    
    func loadBaner() -> GADBannerView
    func loadInterAd()
    func showInter(view: UIViewController) -> Bool
    func loadAppOpen()
    func showAppOpen() -> Bool
    func loadRewardedInter()
    func showRewardInter(view: UIViewController)
}

final class GoogleAdMobServiceImpl: NSObject, GoogleAdMobService {
    var adViewedAction: (() -> Void)?
    
    var amount: NSDecimalNumber?
    var interAd: GADInterstitialAd!
    var rewardInter: GADRewardedInterstitialAd!
    var appOpen: GADAppOpenAd!
    
    func loadBaner() -> GADBannerView {
        let adBannerView: GADBannerView!
        adBannerView = GADBannerView(adSize: GADAdSizeBanner)
        adBannerView.adUnitID = R.Strings.GoogleAdMobKeys.bannner
        adBannerView.load(GADRequest())
        
        return adBannerView
    }
    
    func loadAppOpen() {
        GADAppOpenAd.load(withAdUnitID: R.Strings.GoogleAdMobKeys.appOpen, request: GADRequest()) { [weak self] ad, error in
            guard let self = self else { return }
            if (error != nil) {
                self.loadAppOpen()
            } else if let ad = ad {
                self.appOpen = ad
                self.appOpen.fullScreenContentDelegate = self
            }
        }
    }
    
    func showAppOpen() -> Bool {
        if appOpen != nil {
            if let topViewController = UIApplication.shared.windows.first?.rootViewController {
                if let presentedViewController = topViewController.presentedViewController {
                    appOpen.present(fromRootViewController: presentedViewController)
                } else {
                    appOpen.present(fromRootViewController: topViewController)
                }
            }
            AnaliticsService.shared.logEvent(name: Events.appOpen_view)
            return true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let _ = self.showAppOpen()
            }
            return false
        }
    }
    
    func loadInterAd() {
        GADInterstitialAd.load(withAdUnitID: R.Strings.GoogleAdMobKeys.interstitial,
                               request: GADRequest()) { [weak self] ad, error in
            guard let self = self else { return }
            if (error != nil) {
                self.loadInterAd()
            } else if let ad = ad {
                self.interAd = ad
                self.interAd.fullScreenContentDelegate = self
            }
        }
        AnaliticsService.shared.logEvent(name: Events.inter_request)
    }
    
    func showInter(view: UIViewController) -> Bool {
        if let interAd = interAd {
            interAd.present(fromRootViewController: view)
            AnaliticsService.shared.logEvent(name: Events.inter_view)
            return false
        } else {
            return true
        }
    }
    
    func loadRewardedInter() {
        GADRewardedInterstitialAd.load(withAdUnitID: R.Strings.GoogleAdMobKeys.rewardedInter,
                                       request: GADRequest()) { [weak self] ad, error in
            guard let self = self else { return }
            if (error != nil) {
                self.loadRewardedInter()
            } else if let ad = ad{
                self.rewardInter = ad
                self.rewardInter.fullScreenContentDelegate = self
            }
        }
        AnaliticsService.shared.logEvent(name: Events.rewarded_inter_request)
    }
    
    func showRewardInter(view: UIViewController) {
        guard let rewardInter = rewardInter else {
            Activity.showAlert(title: "alert_no_redy".localized)
            return
        }
        
        rewardInter.present(fromRootViewController: view) { [weak self] in
            guard let self = self else { return }
            let reward = rewardInter.adReward
            self.amount = reward.amount
            AnaliticsService.shared.logEvent(name: Events.rewarded_inter_view)
        }
    }
}

extension GoogleAdMobServiceImpl: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        switch ad {
        case _ as GADInterstitialAd:
            adViewedAction?()
            interAd = nil
            loadInterAd()
        case _ as GADRewardedInterstitialAd:
            if amount != nil {
                adViewedAction?()
                amount = nil
                rewardInter = nil
                loadRewardedInter()
            } else {
                loadRewardedInter()
            }
        case _ as GADAppOpenAd:
            adViewedAction?()
            appOpen = nil
            loadAppOpen() 
        default:
            break
        }
    }
}
