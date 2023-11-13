

import UIKit
import NVActivityIndicatorView
import Reachability

final class LoadingIndicator {
    
    static var timer: Timer?
    static var transparentViewController: UIViewController?
    
    static func showActivityIndicatorFromView(view: UIViewController) {
        if transparentViewController == nil {
            DispatchQueue.main.async {
                transparentViewController = UIViewController()
                transparentViewController?.modalPresentationStyle = .overCurrentContext
                
                transparentViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.0)
                
                let activityIndicator = NVActivityIndicatorView(frame:  CGRect(x: 0, y: 0, width: 130, height: 130),
                                                                type: .ballClipRotatePulse,
                                                                color: R.Colors.roseBtn,
                                                                padding: 20)
                activityIndicator.startAnimating()
                activityIndicator.center = (transparentViewController?.view.center)!
                transparentViewController?.view.addSubview(activityIndicator)
                
                if let transparentViewController = transparentViewController {
                    view.present(transparentViewController, animated: false)
                }
            }
        }
    }
    
    static func hideActivityIndicatorFromView() {
        DispatchQueue.main.async {
            transparentViewController?.dismiss(animated: false)
            transparentViewController = nil
        }
    }
    
    static func startCheckingInternet(completion: @escaping (Bool) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if let reachability = Reachability.forInternetConnection() {
                if reachability.isReachable() {
                    timer.invalidate()
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    static func checkInthernet(view: UIViewController) -> Bool {
        if let reachability = Reachability.forInternetConnection() {
            if reachability.isReachable() {
                return true
            } else {
                self.alertNoEthernet(view: view)
                return false
            }
        }
        return true
    }
    
    static func checkInthernet() -> Bool {
        if let reachability = Reachability.forInternetConnection() {
            if reachability.isReachable() {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    static func allowCamera(view: UIViewController) {
        let alertController = UIAlertController(title: "camera_allert_allow".localized,
                                                message: "",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "alert_cancel".localized, style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
        let continueAction = UIAlertAction(title: "alert_settings".localized, style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        alertController.addAction(continueAction)
        
        view.present(alertController, animated: true, completion: nil)
    }
    
    static func buttonLoader(view: UIView) {
        let loader = NVActivityIndicatorView(frame: view.frame,
                                             type: .circleStrokeSpin,
                                             color: R.Colors.roseBtn)
        
        loader.startAnimating()
        view.addSubview(loader)
    }
    
    static func alertNoInthernetEscap(complition: @escaping () -> Void) {
        let alert = UIAlertController(title: "alert_no_internet".localized, message: "", preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            complition()
            alert.dismiss(animated: true)
        }
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            if let presentedViewController = topViewController.presentedViewController {
                presentedViewController.present(alert, animated: true)
            } else {
                topViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    static func alert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: false)
        }
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            if let presentedViewController = topViewController.presentedViewController {
                presentedViewController.present(alert, animated: false)
            } else {
                topViewController.present(alert, animated: false, completion: nil)
            }
        }
    }
    
    static func alertNoEthernet(view: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let alert = UIAlertController(title: "alert_no_internet".localized, message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "alert_cancel".localized, style: .default) { _ in
                alert.dismiss(animated: false)
                view.navigationController?.popToRootViewController(animated: false)
            }
            
            alert.addAction(action)
            view.present(alert, animated: false, completion: nil)
        }
    }
    
    static func alertNoEthernetWithTimer(complition: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let alert = UIAlertController(title: "alert_no_internet".localized, message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "alert_cancel".localized, style: .default) { _ in
                alert.dismiss(animated: false)
                DispatchQueue.main.async {
                    startCheckingInternet { result in
                        complition(result)
                    }
                }
            }
            
            alert.addAction(action)
            if let topViewController = UIApplication.shared.windows.first?.rootViewController {
                if let presentedViewController = topViewController.presentedViewController {
                    presentedViewController.present(alert, animated: false)
                } else {
                    topViewController.present(alert, animated: false, completion: nil)
                }
            }
        }
    }
}
