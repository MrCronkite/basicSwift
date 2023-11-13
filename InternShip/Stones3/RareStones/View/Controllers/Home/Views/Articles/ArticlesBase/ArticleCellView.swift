

import UIKit

final class ArticleCellView: UICollectionViewCell {
    
    @IBOutlet weak var imageViewArticle: UIImageView!
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var textArticel: UILabel!
    @IBOutlet weak var topLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLabelConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

extension ArticleCellView {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "ArticleCellView") else { return }
        view.frame = self.bounds
        view.backgroundColor = .clear
        self.addSubview(view)
        
        imageViewArticle.layer.cornerRadius = 16
        imageViewArticle.contentMode = .scaleAspectFill
        imageViewArticle.clipsToBounds = true
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

