//
//  TickerAPIService.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/05.
//

import Foundation

struct TickerAPIService {
    
    // MARK: - Instance Property
    
    private let apiService: HttpService = HttpService()
    
    // MARK: - custom func
    
    func getTickerData(orderCurrency: String) async throws -> AllTickerResponse? {
        let request = TickerEndPoint
            .getTickerData(orderCurrency: orderCurrency)
            .createRequest(environment: HttpEnvironment.development)
        return try await self.apiService.request(request)
    }
    
    func getOneTickerData(orderCurrency: String) async throws -> Item? {
        let request = TickerEndPoint
            .getOneTickerData(orderCurrency: orderCurrency)
            .createRequest(environment: HttpEnvironment.development)
        return try await self.apiService.request(request)
    }
}
