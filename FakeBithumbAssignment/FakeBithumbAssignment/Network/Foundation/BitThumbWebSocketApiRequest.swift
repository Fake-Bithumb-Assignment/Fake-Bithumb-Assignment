//
//  WebSocketApiRequest.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

/// 빗썸 Web Socket API 요청 시 사용되는 필터
struct BitThumbWebSocketApiRequest: Encodable {
    
    // MARK: - Instance Property
    
    /// 구독 메시지 종류
    let type: RequestType
    /// 통화코드
    let symbols: [Symbol]
    /// tick 종류
    let tickTypes: [TickType]? = nil
    
    /// 구독 메시지 종류
    enum RequestType: String, Encodable {
        /// 현재가
        case ticker = "ticker"
        /// 체결
        case transaction = "transaction"
        /// 호가
        case orderBook = "orderbookdepth"
    }
    
    /// 통화코드
    enum Symbol: String, Encodable {
        case btc = "BTC_KRW"
        case eth = "ETH_KRW"
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
