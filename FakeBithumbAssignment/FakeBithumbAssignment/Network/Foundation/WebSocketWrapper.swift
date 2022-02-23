//
//  WebSocketWrapper.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/24.
//

import Foundation

import Starscream

/// 외부에서 Starscream을 의존하지 않도록 하는 wrapper struct
struct WebSocketWrapper {
    private let webSocket: WebSocket
    
    init?(of webSocket: WebSocket?) {
        guard let webSocket = webSocket else {
            return
        }
        self.webSocket = webSocket
    }
    
    // MARK: custom function
    
    func disconnect() {
        self.webSocket.disconnect()
    }
}
