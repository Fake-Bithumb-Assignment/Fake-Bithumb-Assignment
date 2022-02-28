//
//  WebSocketApiRequest.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

/// 빗썸 Web Socket API 요청 시 사용되는 필터
struct BTSocketAPIRequest: Encodable {
    
    // MARK: - Instance Property
    
    /// 구독 메시지 종류
    let type: RequestType
    /// 통화코드
    let symbols: [String]
    /// tick 종류
    let tickTypes: [TickType]?
    
    // MARK: - Initializer
    
    init(
        type: RequestType,
        orderCyrrency: [String], // ["BTC", "ETH"], ...
        paymentCurrency: PaymentCurrency = .krw,
        tickTypes: [TickType]? = nil
    ) {
        self.type = type
        self.symbols = orderCyrrency.map{ "\($0)_\(paymentCurrency.rawValue)" }
        self.tickTypes = tickTypes
    }
    
    /// 구독 메시지 종류
    enum RequestType: String, Encodable, CaseIterable {
        /// 현재가
        case ticker = "ticker"
        /// 체결
        case transaction = "transaction"
        /// 호가
        case orderBook = "orderbookdepth"
    }
        
    enum PaymentCurrency: String, Encodable {
        case krw = "KRW"
        case btc = "BTC"
    }
    
    /// tick 종류
    enum TickType: String, Encodable {
        case _30m = "30M"
        case _1h = "1H"
        case _12h = "12H"
        case _24h = "24H"
        case mid = "MID"
    }
}
