//
//  BitThumbWebSocketApiService.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/25.
//

import Foundation

struct BitThumbWebSocketApiService: BitThumbWebSocketApiServiceable {
    
    // MARK: - Instance Property
    
    private let baseUrl: URL? = URL(string: "wss://pubwss.bithumb.com/pub/ws")
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    private let webSocketService: WebSocketService = WebSocketService()
    
    // MARK: - custom func

    func connectTicker(symbols: [BitThumbWebSocketApiRequest.Symbol],
                       tickTypes: [BitThumbWebSocketApiRequest.TickType]?,
                       responseHandler: @escaping (BitThumbWebSocketApiResponse.TickerResponse, WebSocketWrapper?) -> Void) {
        let request = BitThumbWebSocketApiRequest(type: .ticker, symbols: symbols, tickTypes: tickTypes)
        guard let baseUrl = baseUrl, let filter = try? jsonEncoder.encode(request) else {
            return
        }
        webSocketService.subscribe(to: baseUrl, writeWith: filter, responseHandler)
    }
    
    func connectTransaction(symbols: [BitThumbWebSocketApiRequest.Symbol],
                            responseHandler: @escaping (BitThumbWebSocketApiResponse.TransactionResponse, WebSocketWrapper?) -> Void) {
        let request = BitThumbWebSocketApiRequest(type: .transaction, symbols: symbols, tickTypes: nil)
        guard let baseUrl = baseUrl, let filter = try? jsonEncoder.encode(request) else {
            return
        }
        webSocketService.subscribe(to: baseUrl, writeWith: filter, responseHandler)
    }
    
    func connectOrderBook(symbols: [BitThumbWebSocketApiRequest.Symbol],
                          responseHandler: @escaping (BitThumbWebSocketApiResponse.OrderBookResponse, WebSocketWrapper?) -> Void) {
        let request = BitThumbWebSocketApiRequest(type: .orderBook, symbols: symbols, tickTypes: nil)
        guard let baseUrl = baseUrl, let filter = try? jsonEncoder.encode(request) else {
            return
        }
        webSocketService.subscribe(to: baseUrl, writeWith: filter, responseHandler)
    }
}
