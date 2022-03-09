//
//  OrderbookAPIResponse.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/04.
//

import Foundation

struct OrderbookAPIResponse: Codable {
    let timestamp: String
    let paymentCurrency: String
    let orderCurrency: String
    let bids: [Quote]
    let asks: [Quote]

    enum CodingKeys: String, CodingKey {
        case timestamp
        case paymentCurrency = "payment_currency"
        case orderCurrency = "order_currency"
        case bids, asks
    }
}

/// 주문
struct Quote: Codable, Hashable {
    var price: String
    var quantity: String
    var prevClosePrice: Double? = nil
    var priceNumer: Double {
        get {
            return Double(self.price) ?? 0.0
        }
    }
    var quantityNumber: Double {
        get {
            return Double(self.quantity) ?? 0.0
        }
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.price)
    }
    
    static func == (lhs: Quote, rhs: Quote) -> Bool {
        return lhs.price == rhs.price && lhs.quantity == rhs.quantity && lhs.prevClosePrice == rhs.prevClosePrice
    }
    
    static let asc: (Quote, Quote) -> Bool = { (lhs: Quote, rhs: Quote) in
        lhs.priceNumer <= rhs.priceNumer
    }
    
    static let desc: (Quote, Quote) -> Bool = { (lhs: Quote, rhs: Quote) in
        lhs.priceNumer >= rhs.priceNumer
    }
 }
