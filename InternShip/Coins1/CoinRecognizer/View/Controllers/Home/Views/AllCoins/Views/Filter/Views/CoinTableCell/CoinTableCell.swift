

import UIKit

final class CoinTableCell: UITableViewCell {
    
    var buttonTapped: (() -> Void)?
   
    @IBOutlet weak var buttonTrash: UIButton!
    @IBOutlet weak var ImageViewCoin: UIImageView!
    @IBOutlet weak var containerImage: UIView!
    @IBOutlet weak var lableCostCoin: UILabel!
    @IBOutlet weak var lableYears: UILabel!
    @IBOutlet weak var lablePrice: UILabel!
    @IBOutlet weak var containerCoin: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    @IBAction func deleteRowIN(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        buttonTapped?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let buttonPoint = convert(point, to: buttonTrash)
           if buttonTrash.bounds.contains(buttonPoint) {
               return buttonTrash
           }
           return super.hitTest(point, with: event)
    }
}

private extension CoinTableCell {
    func setupView() {
        guard let view = loadViewFromNib(nibName: "CoinTableCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.backgroundColor = .clear
        view.backgroundColor = .clear
        
        containerCoin.layer.cornerRadius = 16
        containerImage.layer.cornerRadius = 16
        containerCoin.backgroundColor = Asset.Color.lightGray.color
        containerImage.backgroundColor = Asset.Color.lightGray.color
        ImageViewCoin.layer.cornerRadius = 40
        lableCostCoin.textColor = .black
        lableYears.textColor = Asset.Color.textGray.color
        lablePrice.textColor = Asset.Color.orange.color
        lableCostCoin.lineBreakMode = .byWordWrapping
        
        buttonTrash.setTitle("", for: .normal)
        buttonTrash.setImage(Asset.Assets.trash.image, for: .normal)
    }
}
