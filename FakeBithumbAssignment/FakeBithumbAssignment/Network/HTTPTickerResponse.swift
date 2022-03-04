//
//  HTTPTickerResponse.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/04.
//

import Foundation

struct HTTPTickerResponse: Decodable {
    let status: NetworkStatus
    let data: TikerData
}

struct TikerData: Decodable {
    let openingPrice: String
    let closingPrice: String
    let minPrice: String
    let maxPrice: String
    let unitsTraded: String
    let accTradeValue: String
    let prevClosingPrice: String
    let fluctate24H: String
    let fluctateRate24H: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case openingPrice = "opening_price"
        case closingPrice = "closing_price"
        case minPrice = "min_price"
        case maxPrice = "max_price"
        case unitsTraded = "units_traded"
        case accTradeValue = "acc_trade_value"
        case prevClosingPrice = "prev_closing_price"
        case fluctate24H = "fluctate_24H"
        case fluctateRate24H = "fluctate_rate_24H"
        case date
    }
}
