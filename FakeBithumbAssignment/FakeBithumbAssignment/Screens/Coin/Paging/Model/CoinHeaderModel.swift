//
//  CoinHeaderViewModel.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/27.
//

import Foundation

struct CoinHeaderModel {
    let currentPrice: Int
    let fluctate: Int
    let fluctateUpDown: String
    let fluctateRate: Double
    
    init(currentPrice: Int, fluctate: Int, fluctateUpDown: String, fluctateRate: Double){
        self.currentPrice = currentPrice
        self.fluctate = fluctate
        self.fluctateUpDown = fluctateUpDown
        self.fluctateRate = fluctateRate
    }
}
