//
//  UIView+Extension.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

extension UIView {
    func addSubView<T: UIView>(_ subview: T, completionHandler closure: ((T) -> Void)? = nil) {
        self.addSubview(subview)
        closure?(subview)
    }
    
    func addSubViews<T: UIView>(_ subviews: [T], completionHandler closure: (([T]) -> Void)? = nil) {
        subviews.forEach { addSubview($0) }
        closure?(subviews)
    }

    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.clear.cgColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        self.layer.add(animation, forKey: "borderColor")
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
