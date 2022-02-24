//
//  WebSocketApiServiceable.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

/// 빗썸 web socket api의 선언부가 있는 프로토콜
protocol BTSocketApiServiceable {
    /// 현재가 ticker
    ///
    /// - Parameter symbols 통화코드
    /// - Parameter tickTypes: tick 종류
    /// - Parameter responseHander: web socket response -> Void 파라미터 타입의 클로져
    mutating func connectTicker(
        symbols: [BTSocketApiRequest.Symbol],
        tickTypes: [BTSocketApiRequest.TickType]?,
        responseHandler: @escaping (BTSocketApiResponse.TickerResponse) -> Void)
    
    /// 체결 transaction
    ///
    /// - Parameter symbols: 통화코드
    /// - Parameter responseHander: web socket response -> Void 파라미터 타입의 클로져
    mutating func connectTransaction(
        symbols: [BTSocketApiRequest.Symbol],
        responseHandler: @escaping (BTSocketApiResponse.TransactionResponse) -> Void)
    
    /// 호가 orderbook
    ///
    /// - Parameter symbols: 통화코드
    /// - Parameter responseHander: web socket response -> Void 파라미터 타입의 클로져
    mutating func connectOrderBook(
        symbols: [BTSocketApiRequest.Symbol],
        responseHandler: @escaping (BTSocketApiResponse.OrderBookResponse) -> Void)
}
