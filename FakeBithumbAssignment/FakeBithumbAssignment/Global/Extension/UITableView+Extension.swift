//
//  UITableView+Extension.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/02.
//

import UIKit

extension UITableView {
    func register<T>(
        cell: T.Type,
        forCellReuseIdentifier reuseIdentifier: String = T.className
    ) where T: UITableViewCell {
        register(cell, forCellReuseIdentifier: reuseIdentifier)
    }
}
