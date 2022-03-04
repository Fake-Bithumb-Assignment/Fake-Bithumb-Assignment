//
//  UIScrollView+Extension.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/03.
//

import UIKit

extension UIScrollView {
    func scrollToCenter() {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2)
        setContentOffset(centerOffset, animated: false)
    }
}

