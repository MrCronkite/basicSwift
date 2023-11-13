

import UIKit

final class StoneCollectionViewCell: UICollectionViewCell {
    var cellView: CartStone
    var width: CGFloat
    
    override init(frame: CGRect) {
        width = UIScreen.main.bounds.width
        cellView = CartStone(frame: CGRect(x: 0, y: 0, width: (width - 44) / 2, height: 196))
        cellView.titleStone.greyColor()
        cellView.contentMode = .scaleAspectFit
        super.init(frame: frame)
        
        contentView.addSubview(cellView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
