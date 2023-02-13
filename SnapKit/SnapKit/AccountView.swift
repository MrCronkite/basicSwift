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
    
    //MARK: - Private constants
    private enum UIConstants {
        static let cardWidth: CGFloat = 45
        static let cardHeight: CGFloat = 30
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
    private var cards: [CardThumbnailInfo] = []
}


private extension AccountView {
    func initialize() {
        backgroundColor = .clear
        
        let yStack = UIStackView()
        yStack.axis = .vertical
        yStack.addArrangedSubview(amountLabel)
        yStack.addArrangedSubview(accountNameLabel)
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        yStack.addArrangedSubview(collectionView)
    }
}


extension AccountView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}


extension AccountView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIConstants.cardWidth, height: UIConstants.cardHeight)
    }
}
