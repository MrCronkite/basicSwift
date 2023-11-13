//
//  MatchCell.swift
//  RareStones
//
//  Created by admin1 on 15.08.23.
//

import UIKit

protocol MatchCellDelegate: AnyObject {
    func showCart(id: Int)
}

final class MatchCell: UICollectionViewCell {
    
    var id = 0
    weak var delegate: MatchCellDelegate?
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var priceTxt: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let view = self.loadViewFromNib(nibName: "MatchCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.clipsToBounds = true
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        imgView.layer.cornerRadius = 14
        imgView.backgroundColor = .brown
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(togleView(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func togleView(_ sender: UITapGestureRecognizer) {
        delegate?.showCart(id: id)
    }
}
