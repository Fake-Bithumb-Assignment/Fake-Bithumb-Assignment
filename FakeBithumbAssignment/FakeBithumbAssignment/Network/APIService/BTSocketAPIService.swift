//
//  BitThumbWebSocketApiService.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/25.
//

import Foundation

struct BTSocketAPIService: BTSocketAPIServiceable {
    
    // MARK: - Instance Property
    
    private let baseURL: URL? = URL(string: "wss://pubwss.bithumb.com/pub/ws")
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    private var socketServiceByType: [BTSocketAPIRequest.RequestType: WebSocketService] = [:]
    
    // MARK: - custom func
    
    mutating func connectTicker(
        symbols: [BTSocketAPIRequest.Symbol],
        tickTypes: [BTSocketAPIRequest.TickType]?,
        responseHandler: @escaping (BTSocketAPIResponse.TickerResponse) -> Void
    ) {
        let request = BTSocketAPIRequest(type: .ticker, symbols: symbols, tickTypes: tickTypes)
        guard let filter = try? self.jsonEncoder.encode(request) else {
            return
        }
        self.subscribe(of: .ticker, writeWith: filter, responseHandler: responseHandler)
    }
    
    mutating func connectTransaction(
        symbols: [BTSocketAPIRequest.Symbol],
        responseHandler: @escaping (BTSocketAPIResponse.TransactionResponse) -> Void
    ) {
        let request = BTSocketAPIRequest(type: .transaction, symbols: symbols, tickTypes: nil)
        guard let filter = try? self.jsonEncoder.encode(request) else {
            return
        }
        self.subscribe(of: .transaction, writeWith: filter, responseHandler: responseHandler)
    }
    
    mutating func connectOrderBook(
        symbols: [BTSocketAPIRequest.Symbol],
        responseHandler: @escaping (BTSocketAPIResponse.OrderBookResponse) -> Void
    ) {
        let request = BTSocketAPIRequest(type: .orderBook, symbols: symbols, tickTypes: nil)
        guard let filter = try? self.jsonEncoder.encode(request) else {
            return
        }
        self.subscribe(of: .orderBook, writeWith: filter, responseHandler: responseHandler)
    }
    
    func disconnect(of requestType: BTSocketAPIRequest.RequestType) {
        guard let socketService = self.socketServiceByType[requestType] else {
            return
        }
        socketService.disconnect()
    }
    
    func disconnectAll() {
        BTSocketAPIRequest.RequestType.allCases.forEach { requestType in
            self.disconnect(of: requestType)
        }
    }
    
    private mutating func subscribe<T: Decodable>(
        of requestType: BTSocketAPIRequest.RequestType,
        writeWith filter: Data,
        responseHandler: @escaping (T) -> Void
    ) {
        guard let baseURL = self.baseURL else {
            return
        }
        if let socketService = self.socketServiceByType[requestType] {
            socketService.disconnect()
        } else {
            self.socketServiceByType[requestType] = WebSocketService()
        }
        self.socketServiceByType[requestType]?.connect(to: baseURL, writeWith: filter, responseHandler)
    }
}
