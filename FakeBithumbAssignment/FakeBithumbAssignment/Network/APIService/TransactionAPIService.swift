//
//  TransactionAPIService.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/08.
//

import Foundation

struct TransactionAPIService {
    private let httpService = HttpService()

    func requestTransactionHistory(of orderCurrency: Coin) async -> [TransactionResponse]? {
        let url: String = "https://api.bithumb.com/public/transaction_history/\(String(describing: orderCurrency))"
        let request: NetworkRequest = NetworkRequest(
            url: url,
            headers: nil,
            reqBody: nil,
            reqTimeout: nil,
            httpMethod: .GET
        )
        do {
            return try await httpService.request(request)
        } catch {
            return nil
        }
    }
}
