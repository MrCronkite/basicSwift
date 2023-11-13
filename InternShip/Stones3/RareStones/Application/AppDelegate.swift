

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        AnalyticsManager.shared.setupAnalytics(application, didFinishLaunchingWithOptions: launchOptions)
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GoogleAd.shared.loadRewardedInter()
        GoogleAd.shared.loadInter()
        GoogleAd.shared.loadAppOpen()
        
        UserDefaults.standard.set(false, forKey: R.Strings.KeyUserDefaults.premiumKey)
        if !LoadingIndicator.checkInthernet() {
            Purchase.shared.completeTransactionsInPurchases()
            Purchase.shared.verifySubscription(productId: R.Strings.KeyProduct.idSub) { result in
                if result {
                    UserDefaults.standard.set(true, forKey: R.Strings.KeyUserDefaults.premiumKey)
                } else {
                    Purchase.shared.verifySubscription(productId: R.Strings.KeyProduct.idPremium) { result in
                        if result {
                            UserDefaults.standard.set(true, forKey: R.Strings.KeyUserDefaults.premiumKey)
                        } else {
                            UserDefaults.standard.set(false, forKey: R.Strings.KeyUserDefaults.premiumKey)
                        }
                    }
                }
            }
        }
        
        return true
    }
}


