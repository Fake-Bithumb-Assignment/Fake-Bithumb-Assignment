//
//  TransactionAPIService.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/07.
//

import Foundation

struct TransAPIService {
    private let apiService: Requestable
    private let environment: HttpEnvironment

    init(apiService: Requestable, environment: HttpEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }
    
    func getTransData(orderCurrency: String, paymentCurrency: String) async throws -> [TransAPIResponse]? {
        let request = TransEndPoint
            .getTransData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
            .createRequest(environment: environment)
        return try await self.apiService.request(request)
    }
}
