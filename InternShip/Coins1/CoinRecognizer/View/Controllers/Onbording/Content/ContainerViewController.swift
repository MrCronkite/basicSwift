

import UIKit

final class ContainerViewController: UIViewController {
    
    private var index = 0
    
    @IBOutlet weak private var containerWallet: UIView!
    @IBOutlet weak private var lableDenamination: UILabel!
    @IBOutlet weak private var imageThird: UIImageView!
    @IBOutlet weak private var iconWallet: UIImageView!
    @IBOutlet weak private var lablePrices: UILabel!
    @IBOutlet weak private var lableReference: UILabel!
    @IBOutlet weak private var lablePrice1: UILabel!
    @IBOutlet weak private var lableMind: UILabel!
    @IBOutlet weak private var lableYears: UILabel!
    @IBOutlet weak private var lableWallet: UILabel!
    @IBOutlet weak private var lablePrice: UILabel!
    @IBOutlet weak private var secondContainer: UIView!
    @IBOutlet weak private var firstViewContainer: UIView!
    @IBOutlet weak private var referenceContainer: UIView!
    @IBOutlet weak private var containerYears: UIView!
    @IBOutlet weak private var containerPrice: UIView!
    @IBOutlet weak private var imageCoin1: UIImageView!
    @IBOutlet weak private var imageBg: UIImageView!
    @IBOutlet weak private var titleText: UILabel!
    @IBOutlet weak private var folderImage: UIImageView!
    @IBOutlet weak private var costFolder: UILabel!
    
    init(subtitle: String? = nil, index: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Asset.Color.dark.color
        imageBg.image = Asset.Assets.onbFolder.image
        localize()
        setupView()
        self.titleText.text = subtitle
        self.index = index ?? 0
        setupLocalView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLocalView()
        localize()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension ContainerViewController {
    func setupView() {
        imageBg.image = Asset.Assets.circles.image
        imageBg.contentMode = .scaleAspectFill
        folderImage.image = Asset.Assets.folders.image
        folderImage.contentMode = .scaleAspectFit
        imageCoin1.image = Asset.Assets.onb1.image
        
        referenceContainer.layer.cornerRadius = 30
        referenceContainer.layer.borderColor = Asset.Color.grey.color.cgColor
        referenceContainer.layer.borderWidth = 10
        
        iconWallet.image = Asset.Assets.wallet1.image
        containerWallet.layer.cornerRadius = 30
        containerWallet.layer.borderColor = Asset.Color.grey.color.cgColor
        containerWallet.layer.borderWidth = 10
        imageThird.image = Asset.Assets.onb2.image
        
        containerYears.backgroundColor = .white.withAlphaComponent(0.7)
        containerYears.layer.cornerRadius = 20
        containerYears.clipsToBounds = true
        containerPrice.layer.cornerRadius = 20
        containerPrice.clipsToBounds = true
        containerPrice.backgroundColor = .white.withAlphaComponent(0.7)
        titleText.adjustsFontSizeToFitWidth = true
        
        let angleInDegrees: CGFloat = -25.0
                let angleInRadians = angleInDegrees * .pi / 180.0
        costFolder.transform = CGAffineTransform(rotationAngle: angleInRadians)
        costFolder.textColor = Asset.Color.midNativ.color
        costFolder.adjustsFontSizeToFitWidth = true
    }
    
    func setupLocalView() {
        switch index {
        case 0:
            firstViewContainer.isHidden = false
            referenceContainer.isHidden = false
            
            secondContainer.isHidden = true
            containerWallet.isHidden = true
            imageThird.isHidden = true
        case 1:
            firstViewContainer.isHidden = true
            referenceContainer.isHidden = true
            containerWallet.isHidden = false
            
            secondContainer.isHidden = false
            imageThird.isHidden = true
        case 2:
            firstViewContainer.isHidden = true
            referenceContainer.isHidden = true
            containerWallet.isHidden = true
            
            secondContainer.isHidden = true
            imageThird.isHidden = false
        default:
            break
        }
    }
    
    func localize() {
        lableReference.text = "ob_reference".localized
        lablePrices.text = "ob_prices".localized
        lableMind.text = "ob_mind".localized
        lableDenamination.text = "ob_denomin".localized
        lablePrice1.text = "ob_price".localized
        lableWallet.text = "ob_wallet".localized
        lablePrice.text = "price_1202".localized
        lableYears.text = "1921-1935"
    }
}
