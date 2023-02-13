//
//  AccountView.swift
//  SnapKit
//
//  Created by admin1 on 13.02.23.
//

import SnapKit
import UIKit

class AccountView: UIView {
    
    func configure(with info: AccountViewInfo) {
        
    }
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let currencyImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let accountNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var collectionView: UICollectionView!
}


private extension AccountView {
    func initialize() {
        backgroundColor = .clear
    }
}
