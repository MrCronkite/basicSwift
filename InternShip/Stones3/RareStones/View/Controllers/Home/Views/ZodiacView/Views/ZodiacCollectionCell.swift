

import UIKit

final class ZodiacCollectionCell: UICollectionViewCell {
    
    let lableTextCell: UILabel = {
        let lable = UILabel()
        lable.backgroundColor = .white
        lable.textColor = R.Colors.textColor
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 17)
        lable.layer.cornerRadius = 10
        return lable
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
    
   private func setupCategoryCell() {
        self.addSubview(lableTextCell)
        lableTextCell.translatesAutoresizingMaskIntoConstraints = false
        lableTextCell.contentMode = .scaleAspectFill
        lableTextCell.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            lableTextCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lableTextCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lableTextCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            lableTextCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lableTextCell.widthAnchor.constraint(equalToConstant: 90),
            lableTextCell.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func updateCellAppearance() {
        if isSelected {
            lableTextCell.backgroundColor =  UIColor(hexString: "#708FE8")
            lableTextCell.textColor = .white
        } else {
            lableTextCell.greyColor()
            lableTextCell.backgroundColor = .white
        }
    }
}
