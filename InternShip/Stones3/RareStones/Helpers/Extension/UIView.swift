

import UIKit
import GoogleMobileAds

extension UIView {
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView
    }
    
    func setupLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = [UIColor(hexString: "#ddcdfa").cgColor, UIColor(hexString: "#d1ddfe").cgColor, UIColor(hexString: "#f2f6ff").cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.zPosition = -2
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#f1f2fe").cgColor, UIColor(hexString: "#e2e4fd").cgColor, R.Colors.blueLight.cgColor, UIColor(hexString: "#e2e4fd").cgColor, UIColor(hexString: "#f1f2fe").cgColor]
        gradientLayer.locations = [0.0, 0.05, 0.5, 0.95, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = self.bounds
        gradientLayer.zPosition = -1
        
        self.layer.addSublayer(gradientLayer)
        self.clipsToBounds = true
    }
    
    func makeAnimationButton(_ button: UIButton) {
        button.addTarget(self, action: #selector(handleIn), for: [
            .touchDown,
            .touchDragInside
        ])
        
        button.addTarget(self, action: #selector(handleOut), for: [
            .touchDragOutside,
            .touchUpInside,
            .touchUpOutside,
            .touchDragExit,
            .touchCancel
        ])
    }
    
    @objc func handleIn() {
        UIView.animate(withDuration: 0.15) { self.alpha = 0.55 }
    }
    
    
    @objc func handleOut() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.7
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (completed) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1.0
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    func addBannerViewToView(_ adbannerView: GADBannerView) {
        adbannerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(adbannerView)
        self.addConstraints(
            [NSLayoutConstraint(item: adbannerView,
                                attribute: .centerY,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .centerY,
                                multiplier: 1,
                                constant: -5 ),
             NSLayoutConstraint(item: adbannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func setupPulsingAnimation() {
        let pulseLayer = CALayer()
        pulseLayer.frame = self.bounds
        pulseLayer.cornerRadius = 16
        pulseLayer.backgroundColor = UIColor.clear.cgColor
        pulseLayer.borderWidth = 12
        pulseLayer.borderColor = UIColor.white.cgColor
        pulseLayer.zPosition = -1
        self.layer.insertSublayer(pulseLayer, below: self.layer)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.8
        animation.fromValue = 0.9
        animation.toValue = 1.1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulseLayer.add(animation, forKey: "pulsing")
    }
    
    
}
