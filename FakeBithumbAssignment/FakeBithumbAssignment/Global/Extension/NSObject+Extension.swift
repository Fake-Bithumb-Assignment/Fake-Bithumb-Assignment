//
//  NSObject+Extension.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
