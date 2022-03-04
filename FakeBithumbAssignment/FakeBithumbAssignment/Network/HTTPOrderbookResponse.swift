//
//  HTTPOrderbookResponse.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/04.
//

import Foundation

struct HTTPOrderbookResponse: Decodable {
    let status: NetworkStatus
    let data: OrderbookData
}

struct OrderbookData: Decodable {
    let timestamp: String
    let paymentCurrency: String
    let orderCurrency: String
    let bids: [Currency]
    let asks: [Currency]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case paymentCurrency = "payment_currency"
        case orderCurrency = "order_currency"
        case bids
        case asks
    }
}

struct Currency: Decodable {
    let quantity: String
    let price: String
}
