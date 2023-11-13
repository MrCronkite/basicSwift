

import UIKit

final class NoMatchViewController: UIViewController {
    
    var presenter: NoMatchPresenter?
    
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var retakeButton: UIButton!
    @IBOutlet weak private var obverseImage: UIImageView!
    @IBOutlet weak private var reverseImage: UIImageView!
    @IBOutlet weak private var titleView: UILabel!
    @IBOutlet weak private var subtitleView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
        presenter?.setupView()
    }
    
    @IBAction private func close(_ sender: Any) {
        presenter?.popToView()
    }
    
    @IBAction private func retake(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        presenter?.popToView()
    }
}

private extension NoMatchViewController {
    func setupView() {
        view.backgroundColor = .white
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(Asset.Assets.close.image, for: .normal)
        
        obverseImage.layer.cornerRadius = 75
        obverseImage.layer.borderColor = Asset.Color.dark.color.cgColor
        obverseImage.layer.borderWidth = 2
        reverseImage.layer.cornerRadius = 75
        reverseImage.layer.borderColor = Asset.Color.dark.color.cgColor
        reverseImage.layer.borderWidth = 2
        
        retakeButton.tintColor = .white
        retakeButton.layer.cornerRadius = 26
        retakeButton.backgroundColor = Asset.Color.orange.color
    }
    
    func localize() {
        titleView.text = "no_mathc_coin".localized
        subtitleView.text = "no_mathc_coin_subtitle".localized
        
        retakeButton.setTitle("retake_button".localized, for: .normal)
    }
}

extension NoMatchViewController: NoMatchViewProtocol {
    func setupImage() {
        obverseImage.image = presenter?.images.first
        reverseImage.image = presenter?.images.last
    }
}
