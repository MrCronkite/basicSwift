

import UIKit

@objc protocol CartStoneDelegate: AnyObject {
    func deleteFromCollection()
    func openStone(id: Int)
    func checkInternet()
    func setLoadIndicator()
    
    @objc optional func addToCollection()
}

final class CartStone: UIView {
    let networkStone = NetworkStoneImpl()
    var id = 0
    var isButtonSelected = false
    weak var delegate: CartStoneDelegate?
    
    @IBOutlet weak var upLable: UILabel!
    @IBOutlet weak var imageStone: UIImageView!
    @IBOutlet weak var titleStone: UILabel!
    @IBOutlet weak var priceStone: UILabel!
    
    @IBOutlet weak var btnHeart: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        isButtonSelected.toggle()
        self.delegate?.setLoadIndicator()
        
        let imageToSet = isButtonSelected ? UIImage(named: "fillheart") : UIImage(named: "heart")
        sender.setImage(imageToSet, for: .normal)
        
        func handleRequestResult(_ result: Result<String, Error>, completion: @escaping () -> Void) {
            LoadingIndicator.hideActivityIndicatorFromView()
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completion()
                }
            case .failure: delegate?.checkInternet()
            }
        }
        
        if id != 0 {
            let requestClosure: (Result<String, Error>) -> Void = { [weak self] result in
                guard let self = self else { return }
                handleRequestResult(result) {
                    if self.isButtonSelected {
                        self.delegate?.addToCollection?()
                    } else {
                        self.delegate?.deleteFromCollection()
                    }
                }
            }
            
            if isButtonSelected {
                networkStone.makePostRequestWashList(id: id, complition: requestClosure)
            } else {
                networkStone.deleteStoneFromWishList(id: id, complition: requestClosure)
            }
        }
    }
    
    @IBAction func openStoneCard(_ sender: UITapGestureRecognizer) {
        delegate?.openStone(id: id)
    }
}

extension CartStone {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "CartStone") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        view.backgroundColor = UIColor(hexString: "#e5edfe")
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        imageStone.contentMode = .scaleAspectFill
        imageStone.clipsToBounds = true
        imageStone.layer.cornerRadius = 12
        
        btnHeart.layer.cornerRadius = 16
        btnHeart.layer.shadowColor = UIColor.black.cgColor
        btnHeart.layer.shadowOpacity = 0.2
        btnHeart.layer.shadowOffset = CGSize(width: 2, height: 2)
        btnHeart.layer.shadowRadius = 4
        btnHeart.backgroundColor = .white
        btnHeart.setTitle("", for: .normal)
        upLable.text = "h_up_to".localized
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openStoneCard(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
}
