

import UIKit
import StoreKit

protocol PremiumViewProtocol: AnyObject {
    func updateTimer(timer: String)
    func enableButtons()
}

protocol PremiumPresenter: AnyObject {
    var product: SKProduct? { get set }
    
    init(view: PremiumViewProtocol, router: RouterProtocol, googleAdMob: GoogleAdMobService)
    
    func popToRoot()
    func goToPurchase()
    func goToTerm()
    func goToPrivacy()
    func goToRestore()
    func showAd(isClose: Bool)
}

final class PremiumPresenterImpl: PremiumPresenter {
    weak var view: PremiumViewProtocol?
    var router: RouterProtocol?
    var googleAdMob: GoogleAdMobService?
    var product: SKProduct? = nil
    
    init(view: PremiumViewProtocol, router: RouterProtocol, googleAdMob: GoogleAdMobService) {
        self.view = view
        self.router = router
        self.googleAdMob = googleAdMob
        
        TimerManager.shared.startTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("TimerTickNotification"), object: nil)
        
        PurchaseManager.shared.getProduct(for: R.Strings.Prducts.premiumId) { product in
            self.product = product
        }
    }
    
    @IBAction func updateUI() {
        let remainingTime = TimerManager.shared.remainingTime.formatTimeInterval()
        view?.updateTimer(timer: remainingTime)
        if remainingTime == "00:00:00" {
            TimerManager.shared.stopTimer()
        }
    }
    
    func goToPurchase() {
        if Activity.checkInthernet() {
            DispatchQueue.main.async {
                Activity.showActivity(view: self.view as! PremiumViewController)
            }
            PurchaseManager.shared.purchase(product: R.Strings.Prducts.premiumId) { [weak self] result in
                guard let self = self else { return }
                Activity.hideActivity()
                if result {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.popToRoot()
                        self.view?.enableButtons()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.view?.enableButtons()
                        self.showAd(isClose: false)
                    }
                }
            }
        } else {
            Activity.alertNoEthernet(view: self.view as! PremiumViewController)
            self.view?.enableButtons()
        }
    }
    
    func goToRestore() {
        if Activity.checkInthernet() {
            DispatchQueue.main.async {
                Activity.showActivity(view: self.view as! PremiumViewController)
            }
            PurchaseManager.shared.restore { [weak self] result in
                guard let self = self else { return }
                self.view?.enableButtons()
                Activity.hideActivity()
                if result {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.popToRoot()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        Activity.showAlert(title: "Nothing to restor")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            self.showAd(isClose: false)
                        }
                    }
                }
            }
        } else {
            
        }
    }
    
    func goToTerm() {
        guard let url = URL(string: R.Strings.Links.termOfUse) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    func goToPrivacy() {
        guard let url = URL(string: R.Strings.Links.privacyPolicy) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    func popToRoot() {
        showAd(isClose: true)
        AnaliticsService.shared.logEvent(name: Events.close_offer_subscription)
    }
    
    func showAd(isClose: Bool) {
        if (self.googleAdMob?.showInter(view: view as! PremiumViewController) ?? true) {
            self.router?.dismiss(view: self.view as! PremiumViewController, filter: nil, isAnimate: true, name: "")
        }
        
        self.googleAdMob?.adViewedAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                guard let self = self else { return }
                self.view?.enableButtons()
            }
            if isClose {
                guard let self = self else { return }
                self.router?.dismiss(view: self.view as! PremiumViewController, filter: nil, isAnimate: true, name: "")
            }
        }
    }
}

