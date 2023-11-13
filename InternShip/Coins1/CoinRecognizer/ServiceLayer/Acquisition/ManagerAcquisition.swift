

import Foundation
import UserAcquisition
import StoreKit
import AppsFlyerLib
import FBSDKCoreKit

protocol ManagerAcquisition: AnyObject {
    init(userAcquisition: UserAcquisition )
    
    func setupUserAcquisition()
    func logPurchase(product: SKProduct)
    func logYandexMetrica(deviceId: String)
    func logAppsFlyerId(data: [String : Any])
}

final class ManagerAcquisitionImpl: ManagerAcquisition {
    weak var userAcquisition: UserAcquisition?
    let server = "https://api.alindas.org/v2"
    
    init(userAcquisition: UserAcquisition) {
        self.userAcquisition = userAcquisition
    }
    
    func setupUserAcquisition() {
        userAcquisition?.configure(withAPIKey: R.Strings.Prducts.userAcquisition,
                                   urlRequest: .init(rawValue: server))
        userAcquisition?.conversionInfo.fbAnonymousId = AppEvents.shared.anonymousID
    }
    
    func logPurchase(product: SKProduct) {
        userAcquisition?.logPurchase(of: product)
    }
    
    func logYandexMetrica(deviceId: String) {
        userAcquisition?.conversionInfo.appmetricaId = deviceId
    }
    
    func logAppsFlyerId(data: [String : Any]) {
        userAcquisition?.conversionInfo.setAppsFlyerData(data)
        userAcquisition?.conversionInfo.appsFlyerId = AppsFlyerLib.shared().getAppsFlyerUID()
    }
}
