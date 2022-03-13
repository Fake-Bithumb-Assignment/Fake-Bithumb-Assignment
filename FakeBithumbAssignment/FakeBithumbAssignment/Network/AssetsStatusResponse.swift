//
//  BTAssetsStatusResponse.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/05.
//

import Foundation

struct AssetsStatusResponse: Decodable {
    
    // MARK: - Instance Property
    
    let depositStatus: Int
    let withdrawalStatus: Int
    
    // MARK: - Initializer
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        depositStatus = try container.decode(Int.self, forKey: .depositStatus)
        withdrawalStatus = try container.decode(Int.self, forKey: .withdrawalStatus)
    }

    enum CodingKeys: String, CodingKey {
        case depositStatus = "deposit_status"
        case withdrawalStatus = "withdrawal_status"
    }
}
