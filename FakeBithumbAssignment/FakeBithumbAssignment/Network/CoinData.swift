//
//  CoinData.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/01.
//

import Foundation

struct CoinData: Hashable {
    static func == (lhs: CoinData, rhs: CoinData) -> Bool {
        return lhs.coinName == rhs.coinName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coinName)
    }
    
    let coinName: String
    var currentPrice: String
    var fluctuationRate: String
    var tradeValue: String
    var isInterested: Bool = false
}
