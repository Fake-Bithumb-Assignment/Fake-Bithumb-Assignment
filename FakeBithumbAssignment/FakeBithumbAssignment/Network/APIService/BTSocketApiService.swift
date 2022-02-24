//
//  BitThumbWebSocketApiService.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/25.
//

import Foundation

struct BTSocketApiService: BTSocketApiServiceable {
    
    // MARK: - Instance Property
    
    private let baseUrl: URL? = URL(string: "wss://pubwss.bithumb.com/pub/ws")
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    private let webSocketService: WebSocketService = WebSocketService()
    
    // MARK: - custom func
    
    func connectTicker(
        symbols: [BTSocketApiRequest.Symbol],
        tickTypes: [BTSocketApiRequest.TickType]?,
        responseHandler: @escaping (BTSocketApiResponse.TickerResponse, WebSocketWrapper?) -> Void
    ) {
        let request = BTSocketApiRequest(type: .ticker, symbols: symbols, tickTypes: tickTypes)
        guard let baseUrl = baseUrl, let filter = try? jsonEncoder.encode(request) else {
            return
        }
        webSocketService.subscribe(to: baseUrl, writeWith: filter, responseHandler)
    }
    
    func connectTransaction(
        symbols: [BTSocketApiRequest.Symbol],
        responseHandler: @escaping (BTSocketApiResponse.TransactionResponse, WebSocketWrapper?) -> Void
    ) {
        let request = BTSocketApiRequest(type: .transaction, symbols: symbols, tickTypes: nil)
        guard let baseUrl = baseUrl, let filter = try? jsonEncoder.encode(request) else {
            return
        }
        webSocketService.subscribe(to: baseUrl, writeWith: filter, responseHandler)
    }
    
    func connectOrderBook(
        symbols: [BTSocketApiRequest.Symbol],
        responseHandler: @escaping (BTSocketApiResponse.OrderBookResponse, WebSocketWrapper?) -> Void
    ) {
        let request = BTSocketApiRequest(type: .orderBook, symbols: symbols, tickTypes: nil)
        guard let baseUrl = baseUrl, let filter = try? jsonEncoder.encode(request) else {
            return
        }
        webSocketService.subscribe(to: baseUrl, writeWith: filter, responseHandler)
    }
}
