//
//  WebSocketWrapper.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/24.
//

import Foundation

import Starscream

/// 외부에서 Starscream을 의존하지 않도록 하는 wrapper struct
/// WebSocket과 동일한 역할을 하지만 특성 및 행동을 추가할 수 있음.
struct WebSocketWrapper {
    
    // MARK: - Instance Property
    
    /// wrapping 대상 인스턴스
    private let webSocket: WebSocket
    
    /// WebSocket을 통한 생성자.
    /// Optional type인 이유는 WebSocketService에서 Optional type으로 쓰이기 때문.
    init?(of webSocket: WebSocket?) {
        guard let webSocket = webSocket else {
            return nil
        }
        self.webSocket = webSocket
    }
    
    // MARK: - custom function
    
    /// 연결되어 있던 socket을 종료.
    func disconnect() {
        self.webSocket.disconnect()
    }
}
