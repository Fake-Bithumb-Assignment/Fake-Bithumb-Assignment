//
//  IntegerType+Extension.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/27.
//

import UIKit

extension String {
    func insertComma(value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedString = numberFormatter.string(from: NSNumber(value: value)) else { return "0" }
        return formattedString
    }
}
