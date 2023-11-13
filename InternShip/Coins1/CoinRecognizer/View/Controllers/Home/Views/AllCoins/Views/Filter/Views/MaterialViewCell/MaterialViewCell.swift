

import UIKit

final class MaterialViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var imageViewCheck: UIImageView!
    @IBOutlet weak var titleNameMaterial: UILabel!
    
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

private extension MaterialViewCell {
    func setupView() {
        guard let view = self.loadViewFromNib(nibName: "MaterialViewCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        view.backgroundColor = .clear
        
        titleNameMaterial.textColor = Asset.Color.textGray.color
    }
    
    func updateCellAppearance() {
        if isSelected {
            titleNameMaterial.textColor = .black
            imageViewCheck.image = Asset.Assets.check.image
        } else {
            titleNameMaterial.textColor = Asset.Color.textGray.color
            imageViewCheck.image = Asset.Assets.ellipse.image
        }
    }
}
