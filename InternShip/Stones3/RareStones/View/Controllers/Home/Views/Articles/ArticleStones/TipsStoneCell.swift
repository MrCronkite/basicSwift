

import UIKit

final class TipsStoneCell: UICollectionViewCell {
    
    var indexCell = 0
    
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var text: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with text: String) {
        self.text.text = text
    }
}

extension TipsStoneCell {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "TipsStoneCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.clipsToBounds = true
    }
    
    static func calculateCellHeight(for text: String, width: CGFloat) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = width
        label.font = UIFont.systemFont(ofSize: 16)
        
        let size = label.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return size.height
    }
}
