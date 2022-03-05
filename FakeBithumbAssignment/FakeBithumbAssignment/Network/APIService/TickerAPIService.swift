//
//  TickerAPIService.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/05.
//

import Foundation

struct TickerAPIService {
    private let apiService: Requestable
    private let environment: HttpEnvironment

    init(apiService: Requestable, environment: HttpEnvironment) {
        self.apiService = apiService
        self.environment = environment
    }
    
    func getTickerData(orderCurrency: String, paymentCurrency: String) async throws -> AllTickerResponse? {
        let request = TickerEndPoint
            .getTickerData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
            .createRequest(environment: environment)
        return try await self.apiService.request(request)
    }
    
    func getOneTickerData(orderCurrency: String, paymentCurrency: String) async throws -> Item? {
        let request = TickerEndPoint
            .getOneTickerData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
            .createRequest(environment: environment)
        return try await self.apiService.request(request)
    }
}
