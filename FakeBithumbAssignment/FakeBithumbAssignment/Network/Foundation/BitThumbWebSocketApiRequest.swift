//
//  WebSocketApiRequest.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

/// 빗썸 Web Socket API 요청 시 사용되는 필터
struct BitThumbWebSocketApiRequest {
    /// 구독 메시지 종류
    enum RequestType: String {
        /// 현재가
        case ticker = "ticker"
        /// 체결
        case transaction = "transaction"
        /// 호가
        case orderBook = "orderbookdepth"
    }
    
    /// tick 종류
    enum TickType: String {
        case _30m = "30M"
        case _1h = "1H"
        case _12h = "12H"
        case _24h = "24H"
        case mid = "MID"
    }
    
    /// 통화코드
    enum Symbol: String {
        case btc = "BTC_KRW"
        case eth = "ETH_KRW"
    }
}
