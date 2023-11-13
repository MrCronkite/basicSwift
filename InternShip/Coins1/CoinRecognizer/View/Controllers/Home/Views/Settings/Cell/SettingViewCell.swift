

import UIKit

final class SettingViewCell: UITableViewCell {
    
    @IBOutlet weak var iconCell: UIImageView!
    @IBOutlet weak var lableCell: UILabel!
    @IBOutlet weak private var arrowIcon: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

private extension SettingViewCell {
    func setupView() {
        guard let view = loadViewFromNib(nibName: "SettingViewCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        view.backgroundColor = .white
        
        arrowIcon.image = Asset.Assets.arrowRight.image
        lableCell.textColor = .black
    }
}
