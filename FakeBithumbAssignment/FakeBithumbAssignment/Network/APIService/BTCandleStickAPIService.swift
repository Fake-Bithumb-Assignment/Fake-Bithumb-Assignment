//
//  BTCandleStickApiService.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/03.
//

import Foundation

struct BTCandleStickAPIService {
    private let httpService: HttpService = HttpService()
    
    func requestCandleStick(
        of orderCurrency: String,
        interval: BTCandleStickChartInterval
    ) async -> [BTCandleStickResponse] {
        let url: String = "https://api.bithumb.com/public/candlestick/\(orderCurrency)_KRW/\(interval.rawValue)"
        let request: NetworkRequest = NetworkRequest(
            url: url,
            headers: nil,
            reqBody: nil,
            reqTimeout: nil,
            httpMethod: .GET
        )
        do {
            guard let rawResponse: [[StringOrInt]] = try await httpService.request(request) else {
                return []
            }
            let result: [BTCandleStickResponse] = try rawResponse.map { rawCandleStick in
                guard let openingPrice = Double(rawCandleStick[1].stringValue),
                      let tradePrice = Double(rawCandleStick[2].stringValue),
                      let highPrice = Double(rawCandleStick[3].stringValue),
                      let lowPrice = Double(rawCandleStick[4].stringValue),
                      let tradeVolume = Double(rawCandleStick[5].stringValue) else {
                          throw BTCandleStickAPIError.unknownError
                      }
                return BTCandleStickResponse(
                    date: rawCandleStick[0].intValue,
                    openingPrice: openingPrice,
                    highPrice: highPrice,
                    lowPrice: lowPrice,
                    tradePrice: tradePrice,
                    tradeVolume: tradeVolume
                )
            }
            return result
        } catch {
            return []
        }
    }
}

enum BTCandleStickAPIError: Error {
    case unknownError
}

enum BTCandleStickChartInterval: String {
    case _1m = "1m"
    case _3m = "3m"
    case _5m = "5m"
    case _10m = "10m"
    case _30m = "30m"
    case _1h = "1h"
    case _6h = "6h"
    case _12h = "12h"
    case _24h = "24h"
}
