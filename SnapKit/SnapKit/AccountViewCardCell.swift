//
//  AccountViewCardCell.swift
//  SnapKitProgect
//
//  Created by admin1 on 13.02.23.
//

import SnapKit
import UIKit

class AccountViewCardCell: UICollectionViewCell {
    //MARK: - Public
    func configure(with image: UIImage) {
        imageView.image = image
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
}


private extension AccountViewCardCell {
    func initialize() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
