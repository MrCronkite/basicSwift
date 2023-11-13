

import UIKit
import Lottie

protocol ButtonViewDelegate: AnyObject {
    func showCamera()
}

final class ButtonView: UIView {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 70, y: 14, width: 28, height: 28)
        view.image = UIImage(named: "cam")
        return view
    }()
    
    let text: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 17)
        lable.text = "camera_button".localized
        lable.textColor = .white
        lable.frame = CGRect(x: 110, y: 17, width: 137, height: 20)
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    weak var delegate: ButtonViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 311, height: 54)
        setupAnimation()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAnimation()
        setupAction()
    }
    
    @IBAction func goToCameraView(_ sender: UITapGestureRecognizer) {
        delegate?.showCamera()
    }
}

extension ButtonView {
    func setupAnimation() {
        let animationView = LottieAnimationView(name: "button")
        animationView.frame = self.frame
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        self.backgroundColor = .clear
        self.addSubview(animationView)
        self.addSubview(imageView)
        self.addSubview(text)
        
        animationView.play()
    }
    
    private func setupAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToCameraView(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
}
