//
//  TransactionAPIService.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/08.
//

import Foundation

struct TransactionAPIService {
    
    // MARK: - Instance Property
    
    private let apiService: HttpService = HttpService()
    
    // MARK: - custom func
    
    func requestTransactionHistory(of orderCurrency: Coin) async -> [TransactionAPIResponse]? {
        let url: String = "\(HttpEnvironment.development.baseUrl)/transaction_history/\(String(describing: orderCurrency))_KRW?count=100"
        let request: NetworkRequest = NetworkRequest(
            url: url,
            headers: nil,
            reqBody: nil,
            reqTimeout: nil,
            httpMethod: .GET
        )
        do {
            return try await apiService.request(request)
        } catch {
            return nil
        }
    }
}
