//
//  Coin.swift
//  URLSession
//
//  Created by admin1 on 24.01.23.
//

import Foundation


// MARK: - Coin
struct Coin: Codable {
    let code: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let time: Int
    let symbol, buy, sell, changeRate: String
    let changePrice, high, low, vol: String
    let volValue, last, averagePrice, takerFeeRate: String
    let makerFeeRate, takerCoefficient, makerCoefficient: String
}
