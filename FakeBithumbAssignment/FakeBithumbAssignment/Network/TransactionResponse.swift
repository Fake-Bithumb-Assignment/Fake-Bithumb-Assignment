//
//  TransactionResponse.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/04.
//

import Foundation

struct TransactionResponse: Decodable {
    let transactionDate: String
    let type: String
    let unitsTraded: String
    let price: String
    let total: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transactionDate = try container.decode(String.self, forKey: .transactionDate)
        type = try container.decode(String.self, forKey: .type)
        unitsTraded = try container.decode(String.self, forKey: .unitsTraded)
        price = try container.decode(String.self, forKey: .price)
        total = try container.decode(String.self, forKey: .total)
    }

    enum CodingKeys: String, CodingKey {
        case transactionDate = "transaction_date"
        case unitsTraded = "units_traded"
        case type, price, total
    }
}
