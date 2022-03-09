//
//  CoinData.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/01.
//

import Foundation

final class CoinData {
    let coinName: Coin
    var currentPrice: String
    var changeRate: String
    var tradeValue: String
    var isInterested: Bool
    var popularity: Int

    // MARK: - Initializer

    init(
        coinName: Coin,
        currentPrice: String,
        changeRate: String,
        tradeValue: String,
        isInterested: Bool = false,
        popularity: Int
    ) {
        self.coinName = coinName
        self.currentPrice = currentPrice
        self.changeRate = changeRate
        self.tradeValue = tradeValue
        self.isInterested = isInterested
        self.popularity = popularity
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
