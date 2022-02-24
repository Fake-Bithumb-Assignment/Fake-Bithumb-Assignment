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
    
    // MARK: - custom func
    
    func subscribe<T: Decodable>(to url: URL,
                                 writeWith filter: String?,
                                 _ responseHandler: @escaping (T, WebSocketWrapper?) -> Void) {
        var request = URLRequest(url: url)
        request.timeoutInterval = timeOutInterval
        let socket = WebSocket(request: request)
        socket.setOnEvent(with: responseHandler)
        socket.connect()
    }
}

extension WebSocket {
    func setOnEvent<T:Decodable>(with responseHandler: @escaping (T, WebSocketWrapper?) -> Void) {
        self.onEvent = { [weak self] event in
            switch event {
            case .text(let jsonString):
                self?.handleStringResponse(of: jsonString, with: responseHandler)
            case .error(let error):
                self?.handleErrorResponse(of: error)
            default:
                break
            }
        }
    }
    
    private func handleStringResponse<T:Decodable>(of stringResponse: String,
                                                   with responseHandler: (T, WebSocketWrapper?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let decodedResponse = jsonDecoder.decode(T.self, from: stringResponse) else {
            return
        }
        responseHandler(decodedResponse, WebSocketWrapper(of: self))
    }
    
    private func handleErrorResponse(of error: Error?) {
        // TODO: 에러 처리
        print(error!)
    }
}
