

import UIKit

final class CatalogViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewCoin: UIImageView!
    @IBOutlet weak var titleCatalog: UILabel!
    @IBOutlet weak var priceCoin: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

extension CatalogViewCell {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "CatalogViewCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        view.backgroundColor = .clear
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
       
        titleCatalog.textColor = .black
        priceCoin.textColor = .black
        imageViewCoin.image = Asset.Assets.coinCeel.image
    }
}


