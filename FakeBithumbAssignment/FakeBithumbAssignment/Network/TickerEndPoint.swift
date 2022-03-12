//
//  TickerEndPoint.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/05.
//

import Foundation

enum TickerEndPoint {
    case getTickerData(orderCurrency: String)
    case getOneTickerData(orderCurrency: String)
    
    var requestTimeOut: Float {
        return 20
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .getTickerData:
            return .GET
        case .getOneTickerData:
            return .GET
        }
    }
    
    var requestBody: Data? {
        switch self {
        case .getTickerData:
            return nil
        case .getOneTickerData:
            return nil
        }
    }
    
    func getURL(from environment: HttpEnvironment) -> String {
        let baseUrl = environment.baseUrl
        switch self {
        case .getTickerData(let orderCurrency):
            return "\(baseUrl)/ticker/\(orderCurrency)_KRW"
        case .getOneTickerData(let orderCurrency):
            return "\(baseUrl)/ticker/\(orderCurrency)_KRW"
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
