//
//  ContracTransaction.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/08.
//

import Foundation

struct ContractTransaction {
    let price: String
    let amount: String
    let time: String
    let upDn: String?
    
    init(price: String, amount: String, time: String, upDn: String) {
        self.price = price
        self.amount = amount
        self.time = time
        self.upDn = upDn
    }
    
    init(price: String, amount: String, time: String) {
        self.price = price
        self.amount = amount
        self.time = time
        self.upDn = nil
    }
}
