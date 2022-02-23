//
//  BaseModel.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import Foundation

struct BaseModel<T: Decodable>: Decodable {
    var status: String?
    var data: T?
    var message: String?
    
    var statusCase: NetworkStatus? {
        return NetworkStatus(rawValue: status ?? "5900")
    }
}
