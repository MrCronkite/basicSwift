

import UIKit

final class PhotoTipsViewController: UIViewController {
     
    @IBOutlet weak var subtitle6: UILabel!
    @IBOutlet weak var subtitle5: UILabel!
    @IBOutlet weak var subtitle4: UILabel!
    @IBOutlet weak var subtitle3: UILabel!
    @IBOutlet weak var subtitle2: UILabel!
    @IBOutlet weak var subtitle1: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var textRoole: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnGo: UIButton!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
     }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
        bgView.setupGradient()
    }
    
    @IBAction func goToCame(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension PhotoTipsViewController {
    private func setupView() {
        titleText.textColor = R.Colors.darkGrey
        tintView.layer.cornerRadius = 3
        bgView.layer.cornerRadius = 25
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.white.cgColor
        bgView.backgroundColor = .white
        textRoole.greyColor()
        btnGo.backgroundColor = R.Colors.roseBtn
        btnGo.layer.cornerRadius = 25
    }
    
    private func localize() {
        closeButton.setTitle("", for: .normal)
        titleText.text = "cam_photo_tips".localized
        textRoole.text = "cam_pt_title".localized
        textRoole.adjustsFontSizeToFitWidth = true
        btnGo.setTitle("detect_btn_go".localized, for: .normal)
        subtitle1.text = "cam_pt_1".localized
        subtitle2.text = "cam_pt_2".localized
        subtitle3.text = "cam_pt_3".localized
        subtitle4.text = "cam_pt_4".localized
        subtitle5.text = "cam_pt_5".localized
        subtitle6.text = "cam_pt_6".localized
    }
}
