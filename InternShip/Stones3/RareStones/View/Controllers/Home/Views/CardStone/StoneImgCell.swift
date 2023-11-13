

import UIKit

final class StoneImgCell: UICollectionViewCell {
    
    let imgCell: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 16
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCategoryCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCategoryCell()
    }
    
    func setupCategoryCell() {
        contentView.addSubview(imgCell)
        imgCell.translatesAutoresizingMaskIntoConstraints = false
        imgCell.contentMode = .scaleToFill
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        
        NSLayoutConstraint.activate([
            imgCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imgCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imgCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imgCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
}
