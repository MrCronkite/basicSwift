

import UIKit

@IBDesignable
final class OriginalView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lableText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
}

extension OriginalView {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "OriginalView") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        view.backgroundColor = UIColor(hexString: "#f1f5ff")
        
        imageView.layer.cornerRadius = 25
        lableText.backgroundColor = UIColor(hexString: "#bd82ff")
        lableText.layer.cornerRadius = 12
        lableText.clipsToBounds = true
    
    }
    
    func setImage(imageName: String) {
        self.imageView.image = UIImage(named: imageName)
    }
    
    func setTitle(text: String) {
        self.lableText.text = text
    }
    
}
