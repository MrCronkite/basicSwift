
import UIKit

final class RetakeViewController: UIViewController {
    
    var presenter: RetakePresenter?
    
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var obversePhoto: UIImageView!
    @IBOutlet weak private var reversePhoto: UIImageView!
    @IBOutlet weak private var retakeButton: UIButton!
    @IBOutlet weak private var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction private func retake(_ sender: UIButton) {
        sender.addTapEffect()
        presenter?.retake()
    }
    
    @IBAction private func continueAddToCollection(_ sender: UIButton) {
        sender.addTapEffect()
        presenter?.continueView()
    }
    
    @IBAction private func close(_ sender: Any) {
        presenter?.closeView()
    }
}

private extension RetakeViewController {
    func setupView() {
        view.backgroundColor = .white
        obversePhoto.layer.cornerRadius = 106
        reversePhoto.layer.cornerRadius = 106
        obversePhoto.image = presenter?.images.first
        reversePhoto.image = presenter?.images.last
        continueButton.setTitle("ob_button".localized, for: .normal)
        continueButton.layer.cornerRadius = 26
        continueButton.tintColor = .white
        continueButton.backgroundColor = Asset.Color.orange.color
        
        retakeButton.setTitle("retake_button".localized, for: .normal)
        retakeButton.layer.cornerRadius = 26
        retakeButton.tintColor = Asset.Color.orange.color
        retakeButton.backgroundColor = Asset.Color.original.color
        
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(Asset.Assets.closeMiniGray.image, for: .normal)
    }
}

extension RetakeViewController: RetakeViewProtocol {
    
}
