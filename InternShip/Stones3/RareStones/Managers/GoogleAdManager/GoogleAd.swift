

import UIKit
import GoogleMobileAds

final class GoogleAd: NSObject {
    var adViewedAction: (() -> Void)?
    
    static var shared = GoogleAd()
    
    var interstitial: GADInterstitialAd!
    var rewardInter: GADRewardedInterstitialAd!
    var appOpen: GADAppOpenAd!
    var amount: NSDecimalNumber?
    
    static func loadBaner() -> GADBannerView {
        let adBannerView: GADBannerView!
        adBannerView = GADBannerView(adSize: GADAdSizeBanner)
        adBannerView.adUnitID = R.Strings.KeyAd.bannerAdKey
        adBannerView.load(GADRequest())
        
        return adBannerView
    }
    
    func loadAppOpen() {
        GADAppOpenAd.load(withAdUnitID: R.Strings.KeyAd.appOpenAdKey, request: GADRequest()) { ad, error in
            if let error = error {
                AnalyticsManager.shared.logEvent(name: Events.appOpen_error)
                GoogleAd.shared.loadAppOpen()
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
            AnalyticsManager.shared.logEvent(name: Events.appOpen_view)
            return true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                print(GoogleAd.shared.showAppOpen())
            }
            return false
        }
    }
    
    func loadInter() {
        AnalyticsManager.shared.logEvent(name: Events.inter_request)
        GADInterstitialAd.load(withAdUnitID: R.Strings.KeyAd.interKey,
                               request: GADRequest()) { ad, error in
            if let error = error {
                AnalyticsManager.shared.logEvent(name: Events.inter_error)
                GoogleAd.shared.loadInter()
            } else if let ad = ad {
                self.interstitial = ad
                self.interstitial.fullScreenContentDelegate = self
            }
        }
    }
    
    func showInter(view: UIViewController) -> Bool {
        if interstitial != nil {
            interstitial.present(fromRootViewController: view)
            AnalyticsManager.shared.logEvent(name: Events.inter_view)
            return false
        } else {
            return true
        }
    }
    
    func loadRewardedInter() {
        AnalyticsManager.shared.logEvent(name: Events.rewarded_inter_request)
        GADRewardedInterstitialAd.load(withAdUnitID: R.Strings.KeyAd.rewardedInterKey,
                                       request: GADRequest()) { ad, error in
            if let error = error {
                AnalyticsManager.shared.logEvent(name: Events.rewarded_inter_error)
                GoogleAd.shared.loadRewardedInter()
            } else if let ad = ad{
                self.rewardInter = ad
                self.rewardInter.fullScreenContentDelegate = self
            }
        }
    }
    
    func showRewardInter(view: UIViewController) {
        guard let rewardInter = rewardInter else {
            LoadingIndicator.alert(title: "allert_loading_ads".localized)
            return
        }
        
        rewardInter.present(fromRootViewController: view) { [weak self] in
            guard let self = self else { return }
            let reward = rewardInter.adReward
            self.amount = reward.amount
            AnalyticsManager.shared.logEvent(name: Events.rewarded_inter_view)
        }
    }
}

extension GoogleAd: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        switch ad {
        case _ as GADInterstitialAd:
            adViewedAction?()
            interstitial = nil
            GoogleAd.shared.loadInter()
        case _ as GADRewardedInterstitialAd:
            if amount != nil {
                adViewedAction?()
                amount = nil
                rewardInter = nil
                GoogleAd.shared.loadRewardedInter()
            } else {
                GoogleAd.shared.loadRewardedInter()
            }
        case _ as GADAppOpenAd:
            adViewedAction?()
            appOpen = nil
            GoogleAd.shared.loadAppOpen()
        default:
            break
        }
    }
}
