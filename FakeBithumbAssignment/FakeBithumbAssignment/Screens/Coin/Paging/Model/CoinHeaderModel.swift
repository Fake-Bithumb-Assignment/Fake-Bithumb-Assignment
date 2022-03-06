//
//  CoinHeaderViewModel.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/27.
//

import Foundation

struct CoinHeaderModel {
    let currentPrice: String
    let fluctate: String
    let fluctateRate: String
    
    init(currentPrice: String, fluctate: String, fluctateRate: String){
        self.currentPrice = currentPrice
        self.fluctate = fluctate
        self.fluctateRate = fluctateRate
    }
}
