

import UIKit

final class MatchViewController: UIViewController {
    
    var presenter: MatchPresenter?
    
    @IBOutlet weak private var firstIcon: UIImageView!
    @IBOutlet weak private var secondIcon: UIImageView!
    @IBOutlet weak private var thirdIcon: UIImageView!
    @IBOutlet weak private var titleText: UILabel!
    @IBOutlet weak private var subtitleText: UILabel!
    @IBOutlet weak private var obversePhoto: UIImageView!
    @IBOutlet weak private var reversePhoto: UIImageView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var titleView: UILabel!
    @IBOutlet weak private var containerPhotoView: UIView!
    @IBOutlet weak private var watchTheAdButton: UIButton!
    @IBOutlet weak private var seeResultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
        presenter?.showImages()
    }
    
    @IBAction func close(_ sender: Any) {
        presenter?.popToRoot()
    }
    
    @IBAction func watchTheAd(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        presenter?.watchAd()
    }
    
    @IBAction func seeResult(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        presenter?.goToResult()
    }
}

private extension MatchViewController {
    func setupView() {
        view.backgroundColor = .white
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(Asset.Assets.closeMiniGray.image, for: .normal)
        titleView.textColor = Asset.Color.orange.color
        containerPhotoView.layer.cornerRadius = 24
        containerPhotoView.backgroundColor = Asset.Color.dark.color
        
        firstIcon.image = Asset.Assets.dollarLog.image
        secondIcon.image = Asset.Assets.dollarLog.image
        thirdIcon.image = Asset.Assets.dollarLog.image
        
        obversePhoto.layer.cornerRadius = 75
        obversePhoto.layer.borderWidth = 2
        obversePhoto.layer.borderColor = UIColor.white.cgColor
    
        reversePhoto.layer.cornerRadius = 75
        reversePhoto.layer.borderWidth = 2
        reversePhoto.layer.borderColor = UIColor.white.cgColor
        
        watchTheAdButton.layer.cornerRadius = 26
        watchTheAdButton.tintColor = Asset.Color.orange.color
        watchTheAdButton.backgroundColor = Asset.Color.nativ.color
        
        seeResultButton.layer.cornerRadius = 26
        seeResultButton.tintColor = .white
        seeResultButton.backgroundColor = Asset.Color.orange.color
        subtitleText.textColor = Asset.Color.textGray.color
        titleText.textColor = .black
    }
    
    func localize() {
        titleView.text = "mathc_found".localized
        subtitleText.text = "subtitle_match".localized
        subtitleText.adjustsFontSizeToFitWidth = true
        titleText.text = "match_title".localized
        seeResultButton.setTitle("result_button".localized, for: .normal)
        watchTheAdButton.setTitle("wathc_ad".localized, for: .normal)
    }
}

extension MatchViewController: MatchViewProtocol {
    func setupImages(images: [UIImage]) {
        obversePhoto.image = images.first
        reversePhoto.image = images.last
    }
}
