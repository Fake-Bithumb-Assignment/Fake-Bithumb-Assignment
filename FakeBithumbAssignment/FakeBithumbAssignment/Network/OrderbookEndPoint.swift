//
//  OrderbookEndPoint.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/04.
//

import Foundation

enum OrderbookEndPoint {
    case getOrderbookData(orderCurrency: String, paymentCurrency: String)
    
    var requestTimeOut: Float {
        return 20
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .getOrderbookData:
            return .GET
        }
    }
    
    var requestBody: Data? {
        switch self {
        case .getOrderbookData:
            return nil
        }
    }
    
    func getURL(from environment: HttpEnvironment) -> String {
        let baseUrl = environment.baseUrl
        switch self {
        case .getOrderbookData(let orderCurrency, let paymentCurrency):
            print("\(baseUrl)/orderbook/\(orderCurrency)_\(paymentCurrency)")
            return "\(baseUrl)/orderbook/\(orderCurrency)_\(paymentCurrency)"
        }
    }
    
    func createRequest(environment: HttpEnvironment) -> NetworkRequest {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        return NetworkRequest(url: getURL(from: environment),
                              headers: headers,
                              reqBody: requestBody,
                              reqTimeout: requestTimeOut,
                              httpMethod: httpMethod)
    }
}
