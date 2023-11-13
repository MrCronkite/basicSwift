

import UIKit
import GoogleMobileAds
import Lottie

extension UIView {
    func addDashedBorder(isDash: Bool, radius: CGFloat, lineDash: NSNumber, color: UIColor) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = 3
        borderLayer.fillColor = nil
        
        if isDash {
            borderLayer.lineDashPattern = [lineDash, 3]
            
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
            borderLayer.path = path.cgPath
            layer.addSublayer(borderLayer)
            
            layer.cornerRadius = radius
            layer.masksToBounds = true
        } else {
            borderLayer.lineDashPattern = [lineDash, 0]
            
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
            borderLayer.path = path.cgPath
            layer.addSublayer(borderLayer)
            
            layer.cornerRadius = radius
            layer.masksToBounds = true
        }
    }
    
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
         return nib.instantiate(withOwner: self).first as? UIView
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
                                constant: 0 ),
             NSLayoutConstraint(item: adbannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    
    func addTapEffect() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            }) { (_) in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                }
            }
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, cornerRadius: CGFloat = 0, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowPath = shadowPath
        
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func tapEffectReverse() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            }) { (_) in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                }
            }
        }
    }
    
    func roundTopCorners(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func setupGradient(startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupThreeGradient(startColor: UIColor, middleColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, middleColor.cgColor,  endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradienBorder(colors: [UIColor], width: CGFloat = 2) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = colors.map({ $0.cgColor })
        gradientLayer.cornerRadius = 15
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = maskPath.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        self.layer.addSublayer(gradientLayer)
    }
    
    //camera
    func setupVisualEffect(focusView: UIView) {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = self.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = 0.5
        
        self.insertSubview(visualEffectView, belowSubview: focusView)
        
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        
        let focusRect = focusView.convert(focusView.bounds, to: self)
        let roundedFocusPath = UIBezierPath(roundedRect: focusRect, cornerRadius: 107)
        let screenRect = self.bounds
        let path = UIBezierPath(rect: screenRect)
        path.append(roundedFocusPath)
        
        maskLayer.path = path.cgPath
        visualEffectView.layer.mask = maskLayer
    }
    
    //animation
    func setupAnimation(name: String) {
        let animationView = LottieAnimationView(name: name)
        animationView.frame = self.frame
        self.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        self.addSubview(animationView)
        animationView.play()
    }
    
    func setupCoinAnimation(name: String) {
        let animationView = LottieAnimationView(name: name)
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        self.addSubview(animationView)
        animationView.play()
    }
    
    func addGradientBackground(topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.withAlphaComponent(0.0).cgColor, bottomColor.withAlphaComponent(0.5).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupGradient() {
        if let existingGradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            return
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Asset.Color.dark.color.withAlphaComponent(0.8).cgColor,
                                Asset.Color.dark.color.withAlphaComponent(0.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.1, y: 0.0)
        gradientLayer.frame = self.bounds
        gradientLayer.zPosition = -1
        
        self.layer.addSublayer(gradientLayer)
        self.clipsToBounds = true
    }
}

extension TimeInterval {
    func formatTimeInterval() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: self) ?? "0:00:00"
    }
}
