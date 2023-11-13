

import UIKit

final class CollectionCellInfo: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak private var blurView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.blurView.setupGradient()
        }
    }
}

private extension CollectionCellInfo {
    func setupView() {
        guard let view = loadViewFromNib(nibName: "CollectionCellInfo") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        view.backgroundColor = .clear
        mainImageView.contentMode = .scaleToFill
    }
}
