//
//  NetworkStatus.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import Foundation

enum NetworkStatus: String {
    case okay = "0000"
    case badRequest = "5100"
    case notAMember = "5200"
    case invalidAPIKey = "5300"
    case MethodNotAllowed = "5302"
    case dataBaseFail = "5400"
    case invalidValue = "5500"
    case useError = "5600"
    case insufficientPurchase = "판매하려는 수량보다 구매수량이 부족합니다."
    case contractHistoryError = "체결내역을 불러올수 없습니다"
    case quoteInformationError = "호가정보를 가져올수 없습니다."
    case unknown = "5900"
}
