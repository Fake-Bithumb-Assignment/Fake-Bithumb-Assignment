//
//  CoinDelgate.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/03.
//

import Foundation
import UIKit

protocol CoinDelgate: AnyObject {
    func updateInterestList(coin: CoinData)
    func showCoinInformation(coin: CoinData)
}
