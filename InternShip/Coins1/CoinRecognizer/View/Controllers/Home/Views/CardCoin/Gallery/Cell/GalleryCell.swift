

import UIKit

final class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewCoin: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            updateCellAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

private extension GalleryCell {
    func setupView() {
        guard let view = self.loadViewFromNib(nibName: "GalleryCell") else { return }
        view.frame = self.bounds
        view.backgroundColor = .clear
        self.addSubview(view)
        
        imageViewCoin.contentMode = .scaleAspectFit
    }
    
    func updateCellAppearance() {
        if isSelected {
            UIView.animate(withDuration: 0.3) {
                self.imageViewCoin.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                self.imageViewCoin.layer.zPosition = 3
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.imageViewCoin.transform = CGAffineTransform.identity
                self.imageViewCoin.layer.zPosition = -1
            }
        }
    }
}
