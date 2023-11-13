
import Foundation
import FBSDKCoreKit
import AppsFlyerLib
import YandexMobileMetrica
import FacebookCore
import UserAcquisition
//import Firebase
//import FirebaseAnalytics

final class AnaliticsService: NSObject {
    
    static let shared = AnaliticsService()
    let acquisition = ManagerAcquisitionImpl(userAcquisition: UserAcquisition())
    
    private override init() {}
    
    func setupAnalytics(_ application: UIApplication,
                        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        acquisition.setupUserAcquisition()
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: R.Strings.Analytics.AppMetrica)
        
        YMMYandexMetrica.activate(with: configuration!)
        YMMYandexMetrica.requestAppMetricaDeviceID(withCompletionQueue: DispatchQueue.main) { [weak self] deviceId, error in
            guard let self = self else { return }
            self.acquisition.logYandexMetrica(deviceId: deviceId ?? "")
        }
        
        AppsFlyerLib.shared().appsFlyerDevKey = R.Strings.Analytics.AppsFlyer
        AppsFlyerLib.shared().appleAppID = R.Strings.AppStoreAppId.key
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().start()
        
        //FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
    
    func logEvent(name: String) {
        AppEvents.shared.logEvent(AppEvents.Name(rawValue: name))
        AppsFlyerLib.shared().logEvent(name, withValues: nil)
       // Analytics.logEvent(name, parameters: nil)
        YMMYandexMetrica.reportEvent(name, parameters: nil, onFailure: nil)
    }
    
    func logEventAFE(product: SKProduct) {
        AppsFlyerLib.shared().logEvent(AFEventPurchase,
                                       withValues: ["eventValue" : ""])
        AppEvents.shared.logPurchase(amount: product.price.doubleValue,
                                     currency: "USD")
        acquisition.logPurchase(product: product)
    }
}

extension AnaliticsService: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        var data: [String : Any] = [:]
        
        for (key, value) in conversionInfo {
            if let stringKey = key as? String {
                data[stringKey] = value
            }
        }
        
        acquisition.logAppsFlyerId(data: data)
    }
    
    func onConversionDataFail(_ error: Error) { }
}
