

import UIKit
import SwiftyStoreKit
import StoreKit

final class Purchase {
    private let sharedSecret = R.Strings.KeyProduct.sharedKey
    
    static let shared = Purchase()
}

extension Purchase {
    func completeTransactionsInPurchases() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    print("unknown error")
                }
            }
        }
    }
    
    func getProduct(for id: String, completion: @escaping (SKProduct?) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo([id]) { result in
            if let product = result.retrievedProducts.first {
                completion(product)
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
                completion(nil)
            }
            else {
                print("Error: \(String(describing: result.error?.localizedDescription))")
                completion(nil)
            }
        }
    }
    
    func purchase(product id: String, completion: @escaping (_ result: Bool) -> Void) {
        SwiftyStoreKit.purchaseProduct(id, atomically: true) { result in
            switch result {
            case .success(let purchase):
                UserAcquisitionImpl.shared.logPurchase(product: purchase.product)
                completion(true)
                
                UserDefaults.standard.set(true, forKey: R.Strings.KeyUserDefaults.premiumKey)
                AnalyticsManager.shared.logEvent(name: Events.done_subscription)
                AnalyticsManager.shared.logEventAFE(product: purchase.product)
            case .error(let error):
                switch error.code {
                case .paymentCancelled:
                    completion(false)
                    AnalyticsManager.shared.logEvent(name: Events.close_offer_subscription)
                default:
                    print("Purchase failed: \(error)")
                    completion(false)
                }
            }
        }
    }
    
    func restore(completion: @escaping (_ result: Bool) -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                completion(false)
            }
            else if results.restoredPurchases.count > 0 {
                completion(true)
                
                AnalyticsManager.shared.logEvent(name: Events.done_restore_subscription)
                UserDefaults.standard.set(true, forKey: R.Strings.KeyUserDefaults.premiumKey)
            }
            else {
                completion(false)
                print("Nothing to Restore")
            }
        }
    }
    
    func fetchReceipt() {
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")
            case .error(let error):
                print("Fetch receipt failed: \(error)")
            }
        }
    }
    
    func verifySubscription(productId id: String, completion: @escaping (_ result: Bool) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = id
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productId,
                    inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    completion(true)
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    completion(false)
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    completion(false)
                }
            case .error(let error):
                print("Receipt verification failed: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}




