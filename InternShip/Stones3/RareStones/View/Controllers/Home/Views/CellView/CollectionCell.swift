

import UIKit

final class CollectionCell: UICollectionViewCell {
    
    let cellView: OriginalView
    let titles: [String] = []
    
    override init(frame: CGRect) {
        cellView = OriginalView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        cellView.lableText.textColor = .white
        cellView.contentMode = .scaleAspectFit
        cellView.imageView.contentMode = .scaleAspectFill
        cellView.imageView.clipsToBounds = true
        super.init(frame: frame)
        contentView.addSubview(cellView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(index: Int) {
        if index <= 8 {
            cellView.lableText.text = titles[index]
        }
    }
}


