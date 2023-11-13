

import UIKit
import MessageUI
import GoogleMobileAds

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var inviteTxt: UILabel!
    @IBOutlet weak var privacyTxt: UILabel!
    @IBOutlet weak var rateTxt: UILabel!
    @IBOutlet weak var termTxt: UILabel!
    @IBOutlet weak var supportTxt: UILabel!
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var supportVIew: UIView!
    @IBOutlet weak var boxAdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
        
        inviteTxt.greyColor()
        privacyTxt.greyColor()
        rateTxt.greyColor()
        termTxt.greyColor()
        supportTxt.greyColor()
        
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            boxAdView.isHidden = true
        }
        
        let tapInvite = UITapGestureRecognizer(target: self, action: #selector(invite(_:)))
        inviteView.addGestureRecognizer(tapInvite)
        inviteView.isUserInteractionEnabled = true
        
        let tapRate = UITapGestureRecognizer(target: self, action: #selector(rate(_:)))
        rateView.addGestureRecognizer(tapRate)
        rateView.isUserInteractionEnabled = true
        
        let tapPrivacy = UITapGestureRecognizer(target: self, action: #selector(privacy(_:)))
        privacyView.addGestureRecognizer(tapPrivacy)
        privacyView.isUserInteractionEnabled = true
        
        let tapTerm = UITapGestureRecognizer(target: self, action: #selector(term(_:)))
        termView.addGestureRecognizer(tapTerm)
        termView.isUserInteractionEnabled = true
        
        let tapSupport = UITapGestureRecognizer(target: self, action: #selector(support(_:)))
        supportVIew.addGestureRecognizer(tapSupport)
        supportVIew.isUserInteractionEnabled = true
        
        backButton.setTitle("", for: .normal)
        settingsTitle.text = "settings_title".localized
        inviteTxt.text = "settings_invite".localized
        rateTxt.text = "settings_rate".localized
        privacyTxt.text = "onb_free_private".localized
        privacyTxt.adjustsFontSizeToFitWidth = true
        termTxt.text = "onb_free_term_us".localized
        termTxt.adjustsFontSizeToFitWidth = true
        supportTxt.text = "settings_support".localized
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func invite(_ sender: UITapGestureRecognizer) {
        animateButtonPressed(view: inviteView)
        let link = "https://apps.apple.com/app/gem-identifier-rock-scanner/id6462852035"
        let activityViewController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func rate(_ sender: UITapGestureRecognizer) {
        animateButtonPressed(view: rateView)
        if let url = URL(string: R.Strings.Links.rateLinksApp) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func privacy(_ sender: UITapGestureRecognizer) {
        animateButtonPressed(view: privacyView)
        guard let url = URL(string: R.Strings.Links.privacy) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    @IBAction func term(_ sender: UITapGestureRecognizer) {
        animateButtonPressed(view: termView)
        guard let url = URL(string: R.Strings.Links.terms) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    @IBAction func support(_ sender: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients([R.Strings.Links.supportEmail])
            mailComposeViewController.setSubject("_support".localized)
            mailComposeViewController.setMessageBody("hello_support".localized, isHTML: false)
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            alert()
        }
    }
    
    private func alert() {
        let alert = UIAlertController(title: "allert_something_went_wrong".localized, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "alert_cancel".localized, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func animateButtonPressed(view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.alpha = 0.7
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (completed) in
            UIView.animate(withDuration: 0.1, animations: {
                view.alpha = 1.0
                view.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func loadAd() {
        let ad = GoogleAd.loadBaner()
        ad.rootViewController = self
        boxAdView.addBannerViewToView(ad)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


