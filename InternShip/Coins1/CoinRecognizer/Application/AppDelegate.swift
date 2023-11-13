

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let storage = UserSettingsImpl()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        AnaliticsService.shared.setupAnalytics(application,
//                                               didFinishLaunchingWithOptions: launchOptions)
//
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        UserSettingsImpl().setPremium(false, forKey: .keyPremium)
        
        if !Activity.checkInthernet() {
            PurchaseManager.shared.completeTransactionsInPurchases()
            PurchaseManager.shared.verifySubscription(productId: "") { [weak self] result in
                guard let self = self else { return }
                if result {
                    self.storage.setPremium(true, forKey: .keyPremium)
                } else {
                    PurchaseManager.shared.verifySubscription(productId: "") { result in
                        if result {
                            self.storage.setPremium(true, forKey: .keyPremium)
                        } else {
                            self.storage.setPremium(false, forKey: .keyPremium)
                        }
                    }
                }
            }
        }
        
        return true
    }
}


