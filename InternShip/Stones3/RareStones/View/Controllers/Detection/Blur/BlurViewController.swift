

import UIKit
import Lottie

final class BlurViewController: UIViewController {
    
    @IBOutlet weak var btnGO: UIButton!
    @IBOutlet weak var titleBlur: UILabel!
    @IBOutlet weak var viewAnimate: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        btnGO.backgroundColor = R.Colors.purple
        btnGO.layer.cornerRadius = 25
    }
    
    override func viewWillLayoutSubviews() {
        setupAnimation()
    }
    
    @IBAction func popToRoot(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func appWillEnterForeground() {
        dismiss(animated: false)
    }
    
    func setupAnimation() {
        let animationView = LottieAnimationView(name: "anim")
        viewAnimate.frame = animationView.frame
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        viewAnimate.backgroundColor = .clear
        animationView.backgroundColor = .clear
        viewAnimate.addSubview(animationView)
        
        animationView.play()
        titleBlur.text = "detect_alert_text".localized
        titleBlur.adjustsFontSizeToFitWidth = true
        btnGO.setTitle("detect_btn_go".localized, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
