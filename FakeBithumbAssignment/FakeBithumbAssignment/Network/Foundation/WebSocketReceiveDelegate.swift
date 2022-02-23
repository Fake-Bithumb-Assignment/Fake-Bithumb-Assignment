//
//  WebSocketReceivable.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

import Starscream

protocol WebSocketReceiveDelegate: WebSocketDelegate {
    func didReceive(with response: String, client: WebSocket)
}

extension WebSocketReceiveDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
//            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
//            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            didReceive(with: string, client: client)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
//            isConnected = false
            break
        case .error(let error):
//            isConnected = false
//            handleError(error)
            break
        }
    }
}
