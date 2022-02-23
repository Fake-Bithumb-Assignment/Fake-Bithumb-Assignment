//
//  WebSocketService.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

import Starscream

class WebSocketService {
    let timeOutInterval: TimeInterval = 5
    
    func request(to url: URL, responseHandler: WebSocketReceiveDelegate) {
        var request = URLRequest(url: url)
        request.timeoutInterval = timeOutInterval
        let socket = WebSocket(request: request)
        socket.delegate = responseHandler
        socket.connect()
    }
}
