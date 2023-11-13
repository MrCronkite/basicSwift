

import UIKit

final class CollectionCellFolder: UICollectionViewCell {
    
    var buttonAddCollection: (() -> Void)?
    var buttonOpenCollection: (() -> Void)?
    
    @IBOutlet weak private var containerCollection: UIView!
    @IBOutlet weak var imageViewFolder: UIImageView!
    @IBOutlet weak private var containerAditionView: UIView!
    @IBOutlet weak private var plus: UIImageView!
    @IBOutlet weak private var containerLayerFocus: UIView!
    
    @IBOutlet weak var imageViewFirst: UIImageView!
    @IBOutlet weak var imageViewSeccond: UIImageView!
    @IBOutlet weak var imageViewThird: UIImageView!
    @IBOutlet weak var imageViewFourtin: UIImageView!
    @IBOutlet weak var nameCollection: UILabel!
    @IBOutlet weak var lableCountCoins: UILabel!
    @IBOutlet weak var lablePriceCollection: UILabel!
    @IBOutlet weak var addLAble: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    @objc private func addCollection() {
        buttonAddCollection?()
    }
    
    @objc private func openCollection() {
        buttonOpenCollection?()
    }
}

extension CollectionCellFolder {
    private func setupView() {
        guard let view = loadViewFromNib(nibName: "CollectionCellFolder") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        self.backgroundColor = .clear
        view.backgroundColor = .clear
        imageViewFolder.contentMode = .scaleToFill
        containerLayerFocus.backgroundColor = .clear
        let tapFocusLayer = UITapGestureRecognizer(target: self, action: #selector(addCollection))
        containerAditionView.isUserInteractionEnabled = true
        containerAditionView.addGestureRecognizer(tapFocusLayer)
        containerAditionView.isHidden = true
        
        let tapOpenFolder = UITapGestureRecognizer(target: self, action: #selector(openCollection))
        containerCollection.isUserInteractionEnabled = true
        containerCollection.addGestureRecognizer(tapOpenFolder)
        
        imageViewFirst.layer.cornerRadius = 23
        imageViewFirst.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: 1), radius: 10, scale: true)
        imageViewFirst.backgroundColor = .clear
        imageViewFirst.image = Asset.Assets.coinCeel.image
        
        imageViewSeccond.layer.cornerRadius = 23
        imageViewSeccond.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: 1, height: 1), radius: 10, scale: true)
        imageViewSeccond.backgroundColor = .clear
        imageViewSeccond.image = Asset.Assets.coinCeel.image
        
        imageViewThird.layer.cornerRadius = 23
        imageViewThird.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
        imageViewThird.backgroundColor = .clear
        imageViewThird.image = Asset.Assets.coinCeel.image
        
        imageViewFourtin.layer.cornerRadius = 23
        imageViewFourtin.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
        imageViewFourtin.backgroundColor = .clear
        imageViewFourtin.image = Asset.Assets.coinCeel.image
        
        nameCollection.textColor = Asset.Color.midNativ.color
        nameCollection.adjustsFontSizeToFitWidth = true
        lableCountCoins.textColor = Asset.Color.textGray.color
        lablePriceCollection.textColor = .black
        addLAble.text = "add_collect_fold".localized
    }
    
    func setColorView(color: UIColor) {
        containerLayerFocus.addDashedBorder(isDash: true,
                                            radius: 30,
                                            lineDash: 3,
                                            color: color)
        plus.image = Asset.Assets.crest.image.withTintColor(color)
        addLAble.textColor = color
    }
    
    func setCollection() {
        containerAditionView.isHidden = true
        containerCollection.isHidden = false
    }
    
    func setFolder() {
        containerAditionView.isHidden = false
        containerCollection.isHidden = true
    }
}
