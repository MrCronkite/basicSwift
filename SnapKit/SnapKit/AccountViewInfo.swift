//
//  AccountViewInfo.swift
//  SnapKitProgect
//
//  Created by admin1 on 13.02.23.
//

import UIKit

struct AccountViewInfo {
    let currency: Currency
    let amount: Int
    let accountName: String
    let cards: [CardThumbnailInfo]
}

enum Currency {
    case rub
    case usd
    case eur
}

struct CardThumbnailInfo {
    let image: UIImage
    let id: String
}
