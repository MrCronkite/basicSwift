

import UIKit
import StoreKit

protocol PayWallViewProtocol: AnyObject {
    func enabledButton()
}

protocol PayWallPresenter: AnyObject {
    var product: SKProduct? { get set }
    
    init(view: PayWallViewProtocol, router: RouterProtocol, googleAdMob: GoogleAdMobService)
    
    func goToTabBar()
    func goToTerm()
    func goToPrivacy()
    func goToPurchase()
    func goToRestore()
    func showAd(isClose: Bool)
}

final class PayWallPresenterImpl: PayWallPresenter {
    weak var view: PayWallViewProtocol?
    var router: RouterProtocol?
    var googleAdMob: GoogleAdMobService?
    var product: SKProduct? = nil
    
    init(view: PayWallViewProtocol, router: RouterProtocol, googleAdMob: GoogleAdMobService) {
        self.view = view
        self.router = router
        self.googleAdMob = googleAdMob
        
        PurchaseManager.shared.getProduct(for: R.Strings.Prducts.subscribeId) { product in
            self.product = product
        }
    }
    
    func goToTabBar() {
        showAd(isClose: true)
        AnaliticsService.shared.logEvent(name: Events.close_offer_subscription)
    }
    
    func goToPurchase() {
        if Activity.checkInthernet() {
            Activity.showActivity(view: view as! PayWallViewController)
            PurchaseManager.shared.purchase(product: R.Strings.Prducts.subscribeId) { [weak self] result in
                guard let self = self else { return }
                Activity.hideActivity()
                if result {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.view?.enabledButton()
                        self.router?.setupInitialViewController(initialView: .tabBar)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.view?.enabledButton()
                        self.showAd(isClose: false)
                    }
                }
            }
        } else {
            Activity.alertNoEthernet(view: view as! PayWallViewController)
            self.view?.enabledButton()
        }
    }
    
    func goToRestore() {
        if Activity.checkInthernet() {
            DispatchQueue.main.async {
               Activity.showActivity(view: self.view as! PayWallViewController)
            }
            PurchaseManager.shared.restore { [weak self] result in
                guard let self = self else { return }
                self.view?.enabledButton()
                Activity.hideActivity()
                if result {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        Activity.showAlert(title: "purchase_restore".localized)
                        self.router?.setupInitialViewController(initialView: .tabBar)
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        Activity.showAlert(title: "nothing_restore".localized)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            self.showAd(isClose: false)
                        }
                    }
                }
            }
        } else {
            Activity.alertNoEthernet(view: view as! PayWallViewController)
            self.view?.enabledButton()
        }
    }
    
    func goToTerm() {
        guard let url = URL(string: R.Strings.Links.termOfUse) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    func showAd(isClose: Bool) {
        if (self.googleAdMob?.showInter(view: view as! PayWallViewController) ?? true) {
            self.router?.setupInitialViewController(initialView: .tabBar)
        }
        
        self.googleAdMob?.adViewedAction = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                guard let self = self else { return }
                self.view?.enabledButton()
            }
            if isClose {
                guard let self = self else { return }
                self.router?.setupInitialViewController(initialView: .tabBar)
            }
        }
    }
    
    func goToPrivacy() {
        guard let url = URL(string: R.Strings.Links.privacyPolicy) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
}

