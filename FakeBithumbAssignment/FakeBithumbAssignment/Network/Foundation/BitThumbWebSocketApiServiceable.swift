//
//  WebSocketApiServiceable.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

/// 빗썸 web socket api의 선언부가 있는 프로토콜
protocol BitThumbWebSocketApiServiceable {
    /// 현재가 ticker
    ///
    /// - Parameter symbols 통화코드
    /// - Parameter tickTypes: tick 종류
    /// - Parameter responseHander: web socket response와 disconnnect할 WebSocketWrapper 파라미터 타입의 클로져
    func connectTicker(symbols: [BitThumbWebSocketApiRequest.Symbol],
                       tickTypes: [BitThumbWebSocketApiRequest.TickType]?,
                       responseHandler: @escaping (BitThumbWebSocketApiResponse.TickerResponse, WebSocketWrapper?) -> Void)
    
    /// 체결 transaction
    ///
    /// - Parameter symbols: 통화코드
    /// - Parameter responseHander: web socket response와 disconnnect할 WebSocketWrapper 파라미터 타입의 클로져
    func connectTransaction(symbols: [BitThumbWebSocketApiRequest.Symbol],
                            responseHandler: @escaping (BitThumbWebSocketApiResponse.TransactionResponse, WebSocketWrapper?) -> Void)
    
    /// 호가 orderbook
    ///
    /// - Parameter symbols: 통화코드
    /// - Parameter responseHander: web socket response와 disconnnect할 WebSocketWrapper 파라미터 타입의 클로져
    func connectOrderBook(symbols: [BitThumbWebSocketApiRequest.Symbol],
                          responseHandler: @escaping (BitThumbWebSocketApiResponse.OrderBookResponse, WebSocketWrapper?) -> Void)
}
