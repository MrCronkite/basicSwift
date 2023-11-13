

import UIKit
import MessageUI

protocol SettingsViewProtocol: AnyObject {
}

protocol SettingsPresenter: AnyObject {
    init(view: SettingsViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService)
    
    func popToRoot()
    func restore()
    func contactUs()
    func rateApp()
    func shareTheApp()
    func privacyPolicy()
    func termOfUse()
}

final class SettingsPresenterImpl: NSObject, SettingsPresenter {
    weak var view: SettingsViewProtocol?
    var router: RouterProtocol?
    var googleAd: GoogleAdMobService?
    
    init(view: SettingsViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService) {
        self.view = view
        self.router = router
        self.googleAd = googleAd
    }
    
    func restore() {
        if Activity.checkInthernet() {
            DispatchQueue.main.async {
                Activity.showActivity(view: self.view as! SettingsViewController)
            }
            PurchaseManager.shared.restore { [weak self] result in
                guard let self = self else { return }
                Activity.hideActivity()
                if result {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        Activity.showAlert(title: "purchase_restore".localized)
                        self.popToRoot()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        Activity.showAlert(title: "nothing_restore".localized)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            self.showAd()
                        }
                    }
                }
            }
        } else {
            Activity.alertNoEthernet(view: view as! SettingsViewController)
        }
    }
    
    func contactUs() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients([R.Strings.Links.email])
            mailComposeViewController.setSubject("support_coin".localized)
            mailComposeViewController.setMessageBody("support_hi".localized, isHTML: false)
            (self.view as! SettingsViewController).present(mailComposeViewController, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func rateApp() {
        if let url = URL(string: R.Strings.Links.rate) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func shareTheApp() {
        let activityViewController = UIActivityViewController(activityItems: [R.Strings.Links.share], applicationActivities: nil)
        (self.view as! SettingsViewController).present(activityViewController, animated: true, completion: nil)
    }
    
    func privacyPolicy() {
        guard let url = URL(string: R.Strings.Links.privacyPolicy) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    func termOfUse() {
        guard let url = URL(string: R.Strings.Links.termOfUse) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    func showAd() {
       let _ = googleAd?.showInter(view: view as! SettingsViewController)
    }
    
    func popToRoot() {
        router?.popToRoot()
    }
}

extension SettingsPresenterImpl: MFMailComposeViewControllerDelegate {
    
}
