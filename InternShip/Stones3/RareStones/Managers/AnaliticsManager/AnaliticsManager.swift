

import Foundation
import FBSDKCoreKit
import AppsFlyerLib
import Firebase
import FirebaseAnalytics
import YandexMobileMetrica
import FacebookCore

final class AnalyticsManager: NSObject {
    
    static let shared = AnalyticsManager()
    
    private override init() {}
    
    func setupAnalytics(_ application: UIApplication,
                               didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        UserAcquisitionImpl.shared.configure()
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: R.Strings.Analytics.AppMetrica)
        
        YMMYandexMetrica.activate(with: configuration!)
        YMMYandexMetrica.requestAppMetricaDeviceID(withCompletionQueue: DispatchQueue.main) { deviceId, error in
            UserAcquisitionImpl.shared.logYandexMetrica(deviceId: deviceId ?? "")
        }
        
        AppsFlyerLib.shared().appsFlyerDevKey = R.Strings.Analytics.AppsFlyer
        AppsFlyerLib.shared().appleAppID = R.Strings.AppStoreAppId.key
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60.0)
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().start()
        
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        
    }
    
    func logEvent(name: String) {
        AppEvents.shared.logEvent(AppEvents.Name(rawValue: name))
        AppsFlyerLib.shared().logEvent(name, withValues: nil)
        Analytics.logEvent(name, parameters: nil)
        YMMYandexMetrica.reportEvent(name, parameters: nil, onFailure: nil)
    }
    
    func logEventAFE(product: SKProduct) {
        AppsFlyerLib.shared().logEvent(AFEventPurchase,
                                       withValues: ["eventValue" : ""])
        AppEvents.shared.logPurchase(amount: product.price.doubleValue,
                                     currency: "USD")
    }
}

extension AnalyticsManager: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        var data: [String : Any] = [:]
        
        for (key, value) in conversionInfo {
            if let stringKey = key as? String {
                data[stringKey] = value
            }
        }
        
        UserAcquisitionImpl.shared.logAppsFlyerId(data: data)
    }
    
    func onConversionDataFail(_ error: Error) {
        print(error)
    }
}




