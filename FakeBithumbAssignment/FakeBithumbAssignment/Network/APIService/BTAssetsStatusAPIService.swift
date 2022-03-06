//
//  BTAssetsStatusAPIService.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/05.
//

import Foundation

struct BTAssetsStatusAPIService {
    private let httpService: HttpService = HttpService()
    
    func requestAssetsStatus(
        of orderCurrency: Coin
    ) async -> BTAssetsStatusResponse? {
        let url: String = "https://api.bithumb.com/public/assetsstatus/\(String(describing: orderCurrency))"
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
