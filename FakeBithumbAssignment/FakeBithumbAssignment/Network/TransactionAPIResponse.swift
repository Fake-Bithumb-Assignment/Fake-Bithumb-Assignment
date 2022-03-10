//
//  TransactionResponse.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/04.
//

import Foundation

struct TransactionAPIResponse: Codable {
    var transactionDate: String
    var type: String?
    var unitsTraded: String
    var price: String
    var total: String?
    var upDn: String?
    
    enum CodingKeys: String, CodingKey {
        case transactionDate = "transaction_date"
        case type
        case unitsTraded = "units_traded"
        case price
        case total
        case upDn
    }
    
    init(transactionDate: String, unitsTraded: String, price: String, upDn: String) {
        self.transactionDate = transactionDate
        self.unitsTraded = unitsTraded
        self.price = price
        self.upDn = upDn
    }
}
