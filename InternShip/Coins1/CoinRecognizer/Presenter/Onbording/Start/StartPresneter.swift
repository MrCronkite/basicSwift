

import UIKit
import AppTrackingTransparency
import FBAudienceNetwork

protocol StartViewProtocol: AnyObject {
}

protocol StartPresenter: AnyObject {
    init(view: StartViewProtocol,
         router: RouterProtocol,
         googleAd: GoogleAdMobService,
         registred: Registred,
         storage: UserSettings)
    
    func registredUser()
    func requestDataPermission()
}

final class StartPresenterImpl: StartPresenter {
    weak var view: StartViewProtocol?
    var router: RouterProtocol?
    var googleAd: GoogleAdMobService?
    var registred: Registred?
    var storage: UserSettings?
    var timer: Timer?
    
    init(view: StartViewProtocol,
         router: RouterProtocol,
         googleAd: GoogleAdMobService,
         registred: Registred,
         storage: UserSettings) {
        self.view = view
        self.router = router
        self.googleAd = googleAd
        self.registred = registred
        self.storage = storage
        
        registredUser()
        startTimer()
    }

    private func loadAd() {
        if !(self.googleAd?.showAppOpen() ?? false) {
            self.router?.setupInitialViewController(initialView: .onbording)
        }
        
        self.googleAd?.adViewedAction = { [weak self] in
            guard let self = self else { return }
            self.router?.setupInitialViewController(initialView: .onbording)
        }
    }
    
    func registredUser() {
        if storage?.token(forKey: .keyToken) == nil {
            registred?.checkToken()
        }
    }
    
    @objc func timerFired() {
        pauseTimer()
        if let isPremium = storage?.premium(forKey: .keyPremium), isPremium {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.router?.setupInitialViewController(initialView: .tabBar)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadAd()
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 6.0, target: self,
                                     selector: #selector(timerFired),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    func resumeTimer() {
        if timer == nil {
            startTimer()
        }
    }
    
    func requestDataPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    FBAdSettings.setAdvertiserTrackingEnabled(true)
                    print("Authorized")
                case .denied:
                    FBAdSettings.setAdvertiserTrackingEnabled(false)
                    print("Denied")
                case .notDetermined:
                    
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            })
        } else {
            //you got permission to track, iOS 14 is not yet installed
        }
    }
}
