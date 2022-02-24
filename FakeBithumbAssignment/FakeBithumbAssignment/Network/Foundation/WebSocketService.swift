//
//  WebSocketService.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/23.
//

import Foundation

import Starscream

class WebSocketService {
    
    // MARK: - Instance Property
    
    let timeOutInterval: TimeInterval = 5
    var socket: WebSocket? = nil
    
    // MARK: - custom func
    
    func connect<T: Decodable>(
        to url: URL,
        writeWith filter: Data?,
        _ responseHandler: @escaping (T) -> Void
    ) {
        if socket != nil {
            socket?.disconnect()
            socket = nil
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = timeOutInterval
        self.socket = WebSocket(request: request)
        guard let socket = self.socket else {
            return
        }
        socket.setOnEvent(of: filter, with: responseHandler)
        socket.connect()
    }
    
    func disconnect() {
        self.socket?.disconnect()
    }
}

extension WebSocket {
    
    // MARK: - custom func
    
    func setOnEvent<T:Decodable>(
        of filter: Data?,
        with responseHandler: @escaping (T) -> Void
    ) {
        self.onEvent = { [weak self] event in
            switch event {
            case .connected:
                guard let filter = filter else {
                    return
                }
                self?.write(data: filter)
            case .text(let jsonString):
                self?.handleStringResponse(of: jsonString, with: responseHandler)
            case .error(let error):
                self?.handleErrorResponse(of: error)
            default:
                break
            }
        }
    }
    
    private func handleStringResponse<T:Decodable>(
        of stringResponse: String,
        with responseHandler: (T) -> Void
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        guard let decodedResponse = jsonDecoder.decode(T.self, from: stringResponse) else {
            return
        }
        responseHandler(decodedResponse)
    }
    
    private func handleErrorResponse(of error: Error?) {
        // TODO: 에러 처리
        print(error!)
    }
}
