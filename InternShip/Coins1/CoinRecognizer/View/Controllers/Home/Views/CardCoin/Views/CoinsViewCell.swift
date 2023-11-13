

import UIKit

final class CoinsViewCell: UICollectionViewCell {
    
    @IBOutlet weak var obverseViewImage: UIImageView!
    @IBOutlet weak var reverseViewImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

private extension CoinsViewCell {
    func setupView() {
        guard let view = loadViewFromNib(nibName: "CoinsViewCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.backgroundColor = .white
        
        view.backgroundColor = Asset.Color.dark.color
        view.layer.cornerRadius = 16
        
        obverseViewImage.layer.cornerRadius = 35
        obverseViewImage.layer.borderWidth = 2
        obverseViewImage.layer.borderColor = UIColor.white.cgColor
        
        reverseViewImage.layer.cornerRadius = 35
        reverseViewImage.layer.borderWidth = 2
        reverseViewImage.layer.borderColor = UIColor.white.cgColor
    }
}

