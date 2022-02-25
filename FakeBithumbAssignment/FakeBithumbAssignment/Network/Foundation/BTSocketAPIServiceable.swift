//
//  WebSocketApiServiceable.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

/// 빗썸 web socket api의 선언부가 있는 프로토콜
protocol BTSocketAPIServiceable {
    /// 현재가 ticker
    ///
    /// - Parameter symbols 통화코드
    /// - Parameter tickTypes: tick 종류
    /// - Parameter responseHander: web socket response -> Void 파라미터 타입의 클로져
    mutating func subscribeTicker(
        symbols: [BTSocketAPIRequest.Symbol],
        tickTypes: [BTSocketAPIRequest.TickType]?,
        responseHandler: @escaping (BTSocketAPIResponse.TickerResponse) -> Void)
    
    /// ticket 연결 해제
    mutating func disconnectTicker()
    
    /// 체결 transaction
    ///
    /// - Parameter symbols: 통화코드
    /// - Parameter responseHander: web socket response -> Void 파라미터 타입의 클로져
    mutating func subscribeTransaction(
        symbols: [BTSocketAPIRequest.Symbol],
        responseHandler: @escaping (BTSocketAPIResponse.TransactionResponse) -> Void)
    
    /// transaction 연결 해제
    mutating func disconnectTransaction()
    
    /// 호가 orderbook
    ///
    /// - Parameter symbols: 통화코드
    /// - Parameter responseHander: web socket response -> Void 파라미터 타입의 클로져
    mutating func subscribeOrderBook(
        symbols: [BTSocketAPIRequest.Symbol],
        responseHandler: @escaping (BTSocketAPIResponse.OrderBookResponse) -> Void)
    
    /// orderbook 연결 해제
    mutating func disconnectOrderBook()
    
    /// 전체 연결 해제
    func disconnectAll()
}
