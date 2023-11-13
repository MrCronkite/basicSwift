

import UIKit

final class AddCoinViewController: UIViewController {
    
    var presenter: AddCoinPresenter?
    
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var titleView: UILabel!
    @IBOutlet weak private var containerElementsView: UIImageView!
    @IBOutlet weak private var imageViewFolder: UIImageView!
    @IBOutlet weak private var titleFolderName: UILabel!
    @IBOutlet weak private var imageCoinsView: UIImageView!
    @IBOutlet weak private var titleText: UILabel!
    @IBOutlet weak private var subtitleText: UILabel!
    @IBOutlet weak private var wathTheAdButton: UIButton!
    @IBOutlet weak private var addToCollection: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
    }
    
    @IBAction private func close(_ sender: Any) {
        presenter?.popToRoot()
    }
    
    @IBAction private  func wathAd(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        presenter?.loadGoogleAd()
    }
    
    @IBAction private func addToCollection(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        presenter?.goToPremium()
    }
}

private extension AddCoinViewController {
    func setupView() {
        view.backgroundColor = .white
        titleText.textColor = Asset.Color.orange.color
        containerElementsView.image = Asset.Assets.elements.image
        imageViewFolder.image = Asset.Assets.folderViolet.image
        imageCoinsView.image = Asset.Assets.coinsCollect.image
        titleText.textColor = .black
        subtitleText.textColor = Asset.Color.textGray.color
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(Asset.Assets.closeMiniGray.image, for: .normal)
        titleView.textColor = Asset.Color.orange.color
        
        wathTheAdButton.layer.cornerRadius = 26
        wathTheAdButton.tintColor = Asset.Color.orange.color
        wathTheAdButton.backgroundColor = Asset.Color.nativ.color
        
        addToCollection.layer.cornerRadius = 26
        addToCollection.tintColor = .white
        addToCollection.backgroundColor = Asset.Color.orange.color
        
        titleFolderName.textColor = Asset.Color.midPurple.color
    }
    
    func localize() {
        titleView.text = "add_coins_to".localized
        titleText.text = "open_all_access".localized
        subtitleText.text = "open_subtitle".localized
        wathTheAdButton.setTitle("wathc_ad".localized, for: .normal)
        addToCollection.setTitle("add_coins_btn".localized, for: .normal)
        titleFolderName.text = "$_collection".localized
    }
}

extension AddCoinViewController: AddCoinViewProtocol {
}

