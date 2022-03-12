//
//  TransactionAPIService.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/08.
//

import Foundation

struct TransactionAPIService {
    private let apiService: Requestable
    private let environment: HttpEnvironment

    init(apiService: Requestable, environment: HttpEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }
    
    func getTransactionData(orderCurrency: String, paymentCurrency: String) async throws -> [TransactionAPIResponse]? {
        let request = TransactionEndPoint
            .getTransactionData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
            .createRequest(environment: environment)
        return try await self.apiService.request(request)
    }
    
    func requestTransactionHistory(of orderCurrency: Coin) async -> [TransactionAPIResponse]? {
        let url: String = "https://api.bithumb.com/public/transaction_history/\(String(describing: orderCurrency))_krw"
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
