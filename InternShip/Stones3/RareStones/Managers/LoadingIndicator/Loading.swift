

import UIKit
import NVActivityIndicatorView

final class Loading {
    private var loader: UIView?
    private var blockerView: UIView?
    
    func addLoading(view: UIViewController) {
        if loader == nil {
            loader = UIView()
            loader?.backgroundColor = .clear
            loader?.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            loader?.center = view.view.center
            loader?.center = CGPoint(x: view.view.bounds.midX, y: view.view.bounds.midY)
            view.view.addSubview(loader!)
            
            let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 130, height: 130),
                                                            type: .ballClipRotatePulse,
                                                            color: R.Colors.roseBtn,
                                                            padding: 20)
            activityIndicator.startAnimating()
            activityIndicator.center = CGPoint(x: (loader?.bounds.midX)!, y: (loader?.bounds.midY)!)
            loader?.addSubview(activityIndicator)
        }
    }
    
    func deleleLoader() {
        DispatchQueue.main.async {
            self.loader?.removeFromSuperview()
            self.loader = nil
        }
    }
    
    func blockerView(view: UIViewController) {
        if blockerView == nil {
            blockerView = UIView(frame: UIScreen.main.bounds)
            blockerView?.backgroundColor = UIColor.black.withAlphaComponent(0)
            view.view.addSubview(blockerView!)
        }
    }
    
    func removeBlockedView() {
        DispatchQueue.main.async {
            self.blockerView?.removeFromSuperview()
            self.blockerView = nil
        }
    }
}


