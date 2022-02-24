//
//  BitThumbWebSocketApiService.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/25.
//

import Foundation

struct BTSocketApiService: BTSocketApiServiceable {
    
    // MARK: - Instance Property
    
    private let baseURL: URL? = URL(string: "wss://pubwss.bithumb.com/pub/ws")
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    private var socketServiceByType: [BTSocketApiRequest.RequestType: WebSocketService] = [:]
    
    // MARK: - custom func
    
    mutating func connectTicker(
        symbols: [BTSocketApiRequest.Symbol],
        tickTypes: [BTSocketApiRequest.TickType]?,
        responseHandler: @escaping (BTSocketApiResponse.TickerResponse, WebSocketWrapper?) -> Void
    ) {
        let request = BTSocketApiRequest(type: .ticker, symbols: symbols, tickTypes: tickTypes)
        guard let filter = try? self.jsonEncoder.encode(request) else {
            return
        }
        self.subscribe(of: .ticker, writeWith: filter, responseHandler: responseHandler)
    }
    
    mutating func connectTransaction(
        symbols: [BTSocketApiRequest.Symbol],
        responseHandler: @escaping (BTSocketApiResponse.TransactionResponse, WebSocketWrapper?) -> Void
    ) {
        let request = BTSocketApiRequest(type: .transaction, symbols: symbols, tickTypes: nil)
        guard let filter = try? self.jsonEncoder.encode(request) else {
            return
        }
        self.subscribe(of: .transaction, writeWith: filter, responseHandler: responseHandler)
    }
    
    mutating func connectOrderBook(
        symbols: [BTSocketApiRequest.Symbol],
        responseHandler: @escaping (BTSocketApiResponse.OrderBookResponse, WebSocketWrapper?) -> Void
    ) {
        let request = BTSocketApiRequest(type: .orderBook, symbols: symbols, tickTypes: nil)
        guard let filter = try? self.jsonEncoder.encode(request) else {
            return
        }
        self.subscribe(of: .orderBook, writeWith: filter, responseHandler: responseHandler)
    }
    
    func disconnect(of requestType: BTSocketApiRequest.RequestType) {
        guard let socketService = self.socketServiceByType[requestType] else {
            return
        }
        socketService.disconnect()
    }
    
    func disconnectAll() {
        BTSocketApiRequest.RequestType.allCases.forEach { requestType in
            self.disconnect(of: requestType)
        }
    }
    
    private mutating func subscribe<T: Decodable>(
        of requestType: BTSocketApiRequest.RequestType,
        writeWith filter: Data,
        responseHandler: @escaping (T, WebSocketWrapper?) -> Void
    ) {
        guard let baseURL = self.baseURL else {
            return
        }
        if let socketService = self.socketServiceByType[requestType] {
            socketService.disconnect()
        } else {
            self.socketServiceByType[requestType] = WebSocketService()
        }
        self.socketServiceByType[requestType]?.subscribe(to: baseURL, writeWith: filter, responseHandler)
    }
}
