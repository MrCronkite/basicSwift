

import UIKit
import Lottie

final class BaseViewOnbording: UIViewController {
    
    var nameAnimation = ""
    var animationView: LottieAnimationView?
    
    @IBOutlet weak var subtitleText: UILabel!
    @IBOutlet weak var titleOriginal: UILabel!
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var viewAnim: UIView!
    @IBOutlet weak var nameStone: UILabel!

    init(subtitle: String? = nil, nameAnimation: String){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .clear
        nameStone.text = "onb_sub_diamond".localized
        titleOriginal.text = "onb_original".localized
        titleOriginal.adjustsFontSizeToFitWidth = true
        self.subtitleText.text = subtitle?.localized
        self.subtitleText.adjustsFontSizeToFitWidth = true
        self.nameAnimation = nameAnimation
        
        setupTitle()
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setupLayer()
        animationView?.frame = CGRect(x: 0, y: 0, width: viewAnim.frame.width, height: viewAnim.frame.height)
    }
    
    private func setupAnimation() {
        animationView = LottieAnimationView(name: nameAnimation)
        animationView?.loopMode = .loop
        animationView?.contentMode = .scaleAspectFit
        animationView?.animationSpeed = 1.5
        viewAnim.addSubview(animationView!)
        animationView?.play()
    }
    
    private func setupTitle() {
        if nameAnimation == "anim02" {
            nameStone.isHidden = false
            titleOriginal.isHidden = false
            let text = subtitleText.text ?? ""
            let words = "atribute_string_expen".localized
            
            let attributedString = NSMutableAttributedString(string: text)
            let range = (text as NSString).range(of: words)

            if range.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: R.Colors.active, range: range)
                subtitleText.attributedText = attributedString
            }
            AnalyticsManager.shared.logEvent(name: Events.view_onbording_second)
        } else {
            let text = subtitleText.text ?? ""
            let words = "atribute_string_find".localized
            let secondWords = "atribute_string_value".localized
            
            let attributedString = NSMutableAttributedString(string: text)
            let rangeSecond = (text as NSString).range(of: secondWords)
            let range = (text as NSString).range(of: words)

            if range.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: R.Colors.active, range: range)
                attributedString.addAttribute(.foregroundColor, value: R.Colors.active, range: rangeSecond)
                subtitleText.attributedText = attributedString
            }
            AnalyticsManager.shared.logEvent(name: Events.view_onbording_first)
        }
    }
}
