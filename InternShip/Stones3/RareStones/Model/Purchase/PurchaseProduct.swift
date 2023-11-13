

import Foundation

struct PurchaseProduct: Codable {
    let products: [Products]
    
    enum CodingKeys: String, CodingKey {
        case products
    }
}

struct Products: Codable {
    let productID: String
    let price: Double
    let currencyCode: String
}
