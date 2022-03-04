//
//  HTTPTransactionResponse.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/04.
//

import Foundation

struct HTTPTransactionResponse: Decodable {
    let status: NetworkStatus
    let data: [TransactionData]
}

struct TransactionData: Decodable {
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
