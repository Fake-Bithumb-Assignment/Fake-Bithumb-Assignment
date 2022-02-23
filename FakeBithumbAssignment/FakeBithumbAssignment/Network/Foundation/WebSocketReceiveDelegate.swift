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
        case .text(let string):
            didReceive(with: string, client: client)
        case .error(let error):
            // TODO: 에러 처리
            break
        default:
            break
        }
    }
}
