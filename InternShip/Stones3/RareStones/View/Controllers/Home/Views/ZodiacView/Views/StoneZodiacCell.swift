

import UIKit

final class StoneZodiacCell: UITableViewCell {
    
    var id = 0
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageStoneView: UIImageView!
    @IBOutlet weak var nameStone: UILabel!
    @IBOutlet weak var titleStone: UILabel!
    @IBOutlet weak var openLable: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.setupGradient()
    }
}

extension StoneZodiacCell {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "StoneZodiacCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.backgroundColor = .clear
        
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        
        imageStoneView.layer.cornerRadius = 16
        imageStoneView.layer.borderWidth = 6
        imageStoneView.layer.borderColor = UIColor(hexString: "#708FE8").cgColor
        imageStoneView.contentMode = .scaleAspectFill
        imageStoneView.clipsToBounds = true
        
        openLable.text = "h_zodiac_open_card".localized
    }
}
