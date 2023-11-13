

import UIKit

final class ImgCell: UICollectionViewCell {
    let viewImgCell: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            updateCellAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCategoryCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCategoryCell()
    }
    
    func setupCategoryCell() {
        self.addSubview(viewImgCell)
        viewImgCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewImgCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewImgCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewImgCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewImgCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewImgCell.widthAnchor.constraint(equalToConstant: 22),
            viewImgCell.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func updateCellAppearance() {
        if isSelected {
            UIView.animate(withDuration: 0.3) {
                self.viewImgCell.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
                    }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.viewImgCell.transform = CGAffineTransform.identity
                    }
        }
    }
}
