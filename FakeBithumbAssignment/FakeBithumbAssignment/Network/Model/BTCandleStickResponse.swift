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
    
    func copy(to object: BTCandleStick, orderCurrency: String, chartIntervals: String) {
        object.date = Int64(self.date)
        object.openingPrice = self.openingPrice
        object.highPrice = self.highPrice
        object.lowPrice = self.lowPrice
        object.tradePrice = self.tradePrice
        object.tradePrice = self.tradePrice
        object.orderCurrency = orderCurrency
        object.chartIntervals = chartIntervals
    }
}
