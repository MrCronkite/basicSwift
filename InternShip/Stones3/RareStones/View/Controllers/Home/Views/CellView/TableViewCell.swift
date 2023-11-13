

import UIKit

final class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var imageViewBase: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    func setupView() {
        guard let view = self.loadViewFromNib(nibName: "TableViewCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.backgroundColor = .clear
        
        setupGradient(view: bgView)
        bgView.layer.cornerRadius = 20
        imageBG.backgroundColor = UIColor(hexString: "#f1f5ff")
        imageBG.layer.cornerRadius = 15
        titleText.textColor = R.Colors.darkGrey
        imageViewBase.contentMode = .scaleAspectFill
        imageViewBase.layer.cornerRadius = 13
        imageViewBase.clipsToBounds = true
        
    }
    
    private func setupGradient(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#f1f2fe").cgColor, UIColor(hexString: "#e2e4fd").cgColor, R.Colors.blueLight.cgColor, UIColor(hexString: "#e2e4fd").cgColor, UIColor(hexString: "#f1f2fe").cgColor]
        gradientLayer.locations = [0.0, 0.1, 0.5, 0.9, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = view.bounds
        gradientLayer.zPosition = -1
        
        view.layer.addSublayer(gradientLayer)
        view.clipsToBounds = true
    }
}
