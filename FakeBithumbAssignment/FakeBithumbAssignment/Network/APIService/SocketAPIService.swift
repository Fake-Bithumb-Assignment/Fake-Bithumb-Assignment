//
//  BitThumbWebSocketApiService.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/25.
//

import Foundation

struct SocketAPIService {
    
    // MARK: - Instance Property
    
    private let baseURL: URL? = URL(string: "wss://pubwss.bithumb.com/pub/ws")
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    private var socketServiceByType: [SocketAPIRequest.RequestType: WebSocketService] = [:]
    
    // MARK: - custom func
    
    /// 현재가 ticker
    ///
    /// - Parameter orderCyrrency: 주문 통화 ["BTC", "ETH"], ...
    /// - Parameter paymentCurrency: 결제 통화
    /// - Parameter tickTypes: tick 종류
    /// - Parameter responseHander: 응답으로 온 Ticket의 핸들러
    mutating func subscribeTicker(
        orderCurrency: [Coin],
        paymentCurrency: SocketAPIRequest.PaymentCurrency,
        tickTypes: [SocketAPIRequest.TickType]?,
        responseHandler: @escaping (SocketAPIResponse.TickerResponse) -> Void
    ) {
        let request = SocketAPIRequest(
            type: .ticker,
            orderCurrency: orderCurrency,
            paymentCurrency: paymentCurrency,
            tickTypes: tickTypes
        )
        guard let filter = try? self.jsonEncoder.encode(request) else {
            return
        }
        self.subscribe(of: .ticker, writeWith: filter, responseHandler: responseHandler)
    }
    
    /// ticker 연결 해제
    mutating func disconnectTicker() {
        self.disconnect(of: .ticker)
    }
    
    /// 체결 transaction
    ///
    /// - Parameter orderCyrrency: 주문 통화 ["BTC", "ETH"], ...
    /// - Parameter paymentCurrency: 결제 통화
    /// - Parameter responseHander: 응답으로 온 Transaction의 핸들러
    mutating func subscribeTransaction(
        orderCurrency: [Coin],
        paymentCurrency: SocketAPIRequest.PaymentCurrency,
        responseHandler: @escaping (SocketAPIResponse.TransactionResponse) -> Void
    ) {
        let request = SocketAPIRequest(
            type: .transaction,
            orderCurrency: orderCurrency,
            paymentCurrency: paymentCurrency
        )
        guard let filter = try? self.jsonEncoder.encode(request) else {
            return
        }
        self.subscribe(of: .transaction, writeWith: filter, responseHandler: responseHandler)
    }
    
    /// transaction 연결 해제
    mutating func disconnectTransaction() {
        self.disconnect(of: .transaction)
    }

    /// 호가 orderbook
    ///
    /// - Parameter orderCyrrency: 주문 통화 ["BTC", "ETH"], ...
    /// - Parameter paymentCurrency: 결제 통화
    /// - Parameter responseHander: 응답으로 온 OrderBook의 핸들러
    mutating func subscribeOrderBook(
        orderCurrency: [Coin],
        paymentCurrency: SocketAPIRequest.PaymentCurrency,
        responseHandler: @escaping (SocketAPIResponse.OrderBookResponse) -> Void
    ) {
        let request = SocketAPIRequest(
            type: .orderBook,
            orderCurrency: orderCurrency,
            paymentCurrency: paymentCurrency
        )
        guard let filter = try? self.jsonEncoder.encode(request) else {
            return
        }
        self.subscribe(of: .orderBook, writeWith: filter, responseHandler: responseHandler)
    }
    
    /// orderbook 연결 해제
    mutating func disconnectOrderBook() {
        self.disconnect(of: .orderBook)
    }
    
    /// 전체 연결 해제
    func disconnectAll() {
        SocketAPIRequest.RequestType.allCases.forEach { requestType in
            self.disconnect(of: requestType)
        }
    }
    
    private func disconnect(of requestType: SocketAPIRequest.RequestType) {
        guard var socketService = self.socketServiceByType[requestType] else {
            return
        }
        socketService.disconnect()
    }
    
    private mutating func subscribe<T: Decodable>(
        of requestType: SocketAPIRequest.RequestType,
        writeWith filter: Data,
        responseHandler: @escaping (T) -> Void
    ) {
        guard let baseURL = self.baseURL else {
            return
        }
        if var socketService = self.socketServiceByType[requestType] {
            socketService.disconnect()
        } else {
            self.socketServiceByType[requestType] = WebSocketService()
        }
        self.socketServiceByType[requestType]?.connect(to: baseURL, writeWith: filter, responseHandler)
    }
}
