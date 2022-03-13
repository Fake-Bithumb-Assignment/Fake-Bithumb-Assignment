//
//  AssetsStatus.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/13.
//

import Foundation

struct AssetsStatus: Hashable {
    let coin: Coin
    let depositStatus: Bool
    let withdrawalStatus: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coin)
    }
    static func == (lhs: AssetsStatus, rhs: AssetsStatus) -> Bool {
        return lhs.coin == rhs.coin
    }
}
