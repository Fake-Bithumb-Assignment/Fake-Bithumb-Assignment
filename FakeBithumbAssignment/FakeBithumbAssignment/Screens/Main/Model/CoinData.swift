//
//  CoinData.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/01.
//

import Foundation

final class CoinData {
    let coinName: String
    var currentPrice: String
    var fluctuationRate: String
    var tradeValue: String
    var isInterested: Bool

    // MARK: - Initializer

    init(
        coinName: String,
        currentPrice: String,
        fluctuationRate: String,
        tradeValue: String,
        isInterested: Bool = false
    ) {
        self.coinName = coinName
        self.currentPrice = currentPrice
        self.fluctuationRate = fluctuationRate
        self.tradeValue = tradeValue
        self.isInterested = isInterested
    }
}

// MARK: - Hashable

extension CoinData: Hashable {
    static func == (lhs: CoinData, rhs: CoinData) -> Bool {
        return lhs.coinName == rhs.coinName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(coinName)
    }
}
