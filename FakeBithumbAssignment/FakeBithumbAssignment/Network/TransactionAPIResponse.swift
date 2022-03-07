//
//  TransactionAPIResponse.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/08.
//

import Foundation

struct TransactionAPIResponse: Decodable {
    let transactionDate: String
    let type: String
    let unitsTraded: String
    let price: String
    let total: String
    
    enum CodingKeys: String, CodingKey {
        case transactionDate = "transaction_date"
        case type
        case unitsTraded = "units_traded"
        case price
        case total
    }
}

