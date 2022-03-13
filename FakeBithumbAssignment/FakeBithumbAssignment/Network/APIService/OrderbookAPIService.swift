//
//  OrderbookAPIService.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/04.
//

import Foundation

struct OrderbookAPIService {
    
    // MARK: - Instance Property
    
    private let apiService: HttpService = HttpService()
    
    // MARK: - custom func
    
    func getOrderbookData(orderCurrency: String, paymentCurrency: String) async throws -> OrderbookAPIResponse? {
        let request = OrderbookEndPoint
            .getOrderbookData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
            .createRequest(environment: HttpEnvironment.development)
        return try await self.apiService.request(request)
    }
}
