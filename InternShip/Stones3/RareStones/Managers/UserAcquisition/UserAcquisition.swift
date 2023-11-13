

import Foundation
import UserAcquisition
import StoreKit
import FBSDKCoreKit
import AppsFlyerLib

final class UserAcquisitionImpl: NSObject {
    
    static let shared = UserAcquisitionImpl()
    
    private override init() {}
    
    enum API {
        static let server = "https://api.alindas.org/v2"
    }
    
    func configure() {
        UserAcquisition.shared.configure(withAPIKey: R.Strings.KeyProduct.userAcquisitionApiKey,
                                         urlRequest: .init(rawValue: API.server))
        UserAcquisition.shared.conversionInfo.fbAnonymousId = AppEvents.shared.anonymousID
    }
    
    func logPurchase(product: SKProduct) {
        UserAcquisition.shared.logPurchase(of: product)
    }
    
    func logYandexMetrica(deviceId: String) {
        UserAcquisition.shared.conversionInfo.appmetricaId = deviceId 
    }
    
    func logAppsFlyerId(data: [String : Any]) {
        UserAcquisition.shared.conversionInfo.setAppsFlyerData(data)
        UserAcquisition.shared.conversionInfo.appsFlyerId = AppsFlyerLib.shared().getAppsFlyerUID() 
    }
}

