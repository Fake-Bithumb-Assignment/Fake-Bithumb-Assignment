//
//  TransactionAPIResponse.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/08.
//

import Foundation

struct TransAPIResponse: Codable {
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

