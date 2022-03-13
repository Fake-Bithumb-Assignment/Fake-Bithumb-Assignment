//
//  OrderbookAPIResponse.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/04.
//

import Foundation

struct OrderbookAPIResponse: Codable {
    
    // MARK: - Instance Property

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
    
    // MARK: - Instance Property

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
    var isEmptyQuote: Bool
    var transactionPrice: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case price, quantity
    }
    
    // MARK: - Initializer
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try values.decode(String.self, forKey: .price)
        self.quantity = try values.decode(String.self, forKey: .quantity)
        self.isEmptyQuote = false
    }
    
    init(price: String, quantity: String) {
        self.price = price
        self.quantity = quantity
        self.isEmptyQuote = false
    }
    
    // MARK: - custom func
    
    static func == (lhs: Quote, rhs: Quote) -> Bool {
        return lhs.price == rhs.price &&
        lhs.quantity == rhs.quantity &&
        lhs.prevClosePrice == rhs.prevClosePrice &&
        lhs.transactionPrice == rhs.transactionPrice
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.price)
    }
    
    static let asc: (Quote, Quote) -> Bool = { (lhs: Quote, rhs: Quote) in
        lhs.priceNumer <= rhs.priceNumer
    }
    
    static let desc: (Quote, Quote) -> Bool = { (lhs: Quote, rhs: Quote) in
        lhs.priceNumer >= rhs.priceNumer
    }

    static var emptyQuote: Quote {
        var quote = Quote(price: UUID().uuidString, quantity: "")
        quote.isEmptyQuote = true
        return quote
    }
    
    static func getEmptyQuoteList(number: Int) -> [Quote] {
        return (1...number).map { _ -> Quote in
            Quote.emptyQuote
        }
    }
 }
