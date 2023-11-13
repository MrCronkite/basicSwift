

import UIKit

final class NotFoundViewController: UIViewController {
    
    var image = UIImage()
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var btnRetake: UIButton!
    @IBOutlet weak var btnPhotoTips: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        
        mainImageView.image = image
        setupView()
        AnalyticsManager.shared.logEvent(name: Events.open_view_no_match)
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func goRetake(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goPhotoTips(_ sender: Any) {
        let vc = PhotoTipsViewController()
        present(vc, animated: true)
    }
}

extension NotFoundViewController {
    private func setupView() {
        mainImageView.layer.cornerRadius = 20
        mainImageView.layer.borderWidth = 8
        mainImageView.layer.borderColor = UIColor.white.cgColor
        mainImageView.contentMode = .scaleAspectFill
        
        subtitle.greyColor()
        btnRetake.backgroundColor = R.Colors.roseBtn
        btnRetake.layer.cornerRadius = 25
        btnPhotoTips.backgroundColor = R.Colors.purple
        btnPhotoTips.layer.cornerRadius = 25
    }
    
    private func localize() {
        closeButton.setTitle("", for: .normal)
        titleLable.text = "cam_nomatch_title".localized
        subtitle.text = "cam_nomatch_subtitle".localized
        subtitle.adjustsFontSizeToFitWidth = true
        btnRetake.setTitle("cam_nomatch_btn_retake".localized, for: .normal)
        btnPhotoTips.setTitle("cam_photo_tips".localized, for: .normal)
    }
}
 
