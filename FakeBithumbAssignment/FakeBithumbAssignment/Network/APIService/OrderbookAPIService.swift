//
//  OrderbookAPIService.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/04.
//

import Foundation

struct OrderbookAPIService {
    private let apiService: HttpService
    private let environment: HttpEnvironment

    init(apiService: HttpService, environment: HttpEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }
    
    func getOrderbookData(orderCurrency: String, paymentCurrency: String) async throws -> OrderbookAPIResponse? {
        let request = OrderbookEndPoint
            .getOrderbookData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
            .createRequest(environment: environment)
        return try await self.apiService.request(request)
    }
}
