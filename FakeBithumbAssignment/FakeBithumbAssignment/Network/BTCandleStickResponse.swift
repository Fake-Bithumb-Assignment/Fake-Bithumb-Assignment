//
//  CandleStickResponse.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/03.
//

import Foundation

struct BTCandleStickResponse: Decodable {
    let date: Int
    let openingPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let tradePrice: Double
    let tradeVolume: Double
}
