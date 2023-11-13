

import UIKit
import NVActivityIndicatorView
import Reachability

final class Activity {
    
    static var loaderViewController: UIViewController?
    
    static func showActivity(view: UIViewController) {
        if loaderViewController == nil {
            DispatchQueue.main.async {
                loaderViewController = UIViewController()
                loaderViewController?.modalPresentationStyle = .overCurrentContext
                
                loaderViewController?.view.backgroundColor = UIColor(white: 0, alpha: 0.0)
                
                let activityIndicator = NVActivityIndicatorView(frame:  CGRect(x: 0, y: 0, width: 100, height: 100),
                                                                type: .ballRotate,
                                                                color: Asset.Color.orange.color,
                                                                padding: 20)
                activityIndicator.startAnimating()
                activityIndicator.center = (loaderViewController?.view.center)!
                loaderViewController?.view.addSubview(activityIndicator)
                
                if let loaderViewController = loaderViewController {
                    view.present(loaderViewController, animated: false)
                }
            }
        }
    }
    
    static func hideActivity() {
        DispatchQueue.main.async {
            loaderViewController?.dismiss(animated: false)
            loaderViewController = nil
        }
    }
    
    static func show(view: UIView) {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0,
                                                                      y: 0,
                                                                      width: 100,
                                                                      height: 100),
                                                        type: .ballRotate,
                                                        color: Asset.Color.orange.color,
                                                        padding: 0)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    static func hide(view: UIView) {
        view.subviews.last?.removeFromSuperview()
    }
    
    static func checkingInternet(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let reachability = Reachability.forInternetConnection() {
                if reachability.isReachable() {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    static func logo(view: UIView) {
        let logoNV = NVActivityIndicatorView(frame: view.frame,
                                             type: .ballPulse,
                                             color: Asset.Color.orange.color)
        
        logoNV.startAnimating()
        view.addSubview(logoNV)
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
    
    static func alertNoEthernet(view: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let alert = UIAlertController(title: "alert_no_internet".localized, message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "cancel_alert".localized, style: .default) { _ in
                alert.dismiss(animated: false)
                view.navigationController?.popToRootViewController(animated: false)
            }
            
            alert.addAction(action)
            view.present(alert, animated: false, completion: nil)
        }
    }
    
    static func showAlert(title: String) {
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
    
    static func showAlertNoInthernet(complition: @escaping () -> Void) {
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
    
    static func showAlertWithDelete(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "alert_delet".localized, message: "alert_delete_item".localized, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "cancel_alert".localized, style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "alert_delete".localized, style: .destructive) { _ in
            completion("delete")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showSettingsApp(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "allow_allert".localized, message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "cancel_alert".localized, style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "settings_alert".localized, style: .default) { _ in
            completion("settings")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlertNoIntherner(view: UIViewController, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: "alert_no_internet".localized, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "cancel_alert".localized, style: .default) { _ in
            completion(true)
        }
        
        alert.addAction(cancelAction)
    }
    
    static func showAlertWithRenameDelete(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let renameAction = UIAlertAction(title: "alert_rename", style: .default) { _ in
            completion("rename")
        }
        
        let deleteAction = UIAlertAction(title: "alert_delete".localized, style: .destructive) { _ in
            completion("delete")
        }
        
        let cancelAction = UIAlertAction(title: "cancel_alert".localized, style: .cancel) { _ in
            completion("cancel")
        }
        
        alert.addAction(renameAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlertWithCatalogOrRecognizing(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let catalogAction = UIAlertAction(title: "alert_from_catalog".localized, style: .default) { _ in
            completion("catalog")
        }
        
        let recognizingAction = UIAlertAction(title: "alert_recong".localized, style: .default) { _ in
            completion("recognizing")
        }
        
        let cancelAction = UIAlertAction(title: "cancel_alert".localized, style: .cancel, handler: nil)
        
        alert.addAction(catalogAction)
        alert.addAction(recognizingAction)
        alert.addAction(cancelAction)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func alertWithDeleteOrRename(completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let catalogAction = UIAlertAction(title: "alert_rename".localized, style: .default) { _ in
            completion("rename")
        }
        
        let recognizingAction = UIAlertAction(title: "alert_delete_collecti".localized, style: .destructive) { _ in
            completion("dellete")
        }
        
        let cancelAction = UIAlertAction(title: "cancel_alert".localized, style: .cancel, handler: nil)
        
        alert.addAction(catalogAction)
        alert.addAction(recognizingAction)
        alert.addAction(cancelAction)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlertWithActivityIndicator(in viewController: UIViewController, message: String = "Loading...") {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                let activityIndicator = NVActivityIndicatorView(frame:  CGRect(x: 0, y: 0, width: 100, height: 100),
                                                                type: .ballRotate,
                                                                color: Asset.Color.orange.color,
                                                                padding: 20)
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                activityIndicator.startAnimating()
                alert.view.addSubview(activityIndicator)
                
                let constraints = [
                    activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                    activityIndicator.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 40),
                    activityIndicator.heightAnchor.constraint(equalToConstant: 70),
                    activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: 10)
                ]
                NSLayoutConstraint.activate(constraints)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func hideActivityIndicatorFromAlert(in viewController: UIViewController) {
        DispatchQueue.main.async {
            if let alert = viewController.presentedViewController as? UIAlertController {
                alert.dismiss(animated: false, completion: nil)
            }
        }
    }
}
