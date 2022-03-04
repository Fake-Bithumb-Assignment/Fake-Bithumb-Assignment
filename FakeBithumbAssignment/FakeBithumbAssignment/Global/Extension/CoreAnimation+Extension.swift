//
//  CoreAnimation+Extension.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/27.
//

import UIKit

extension CAShapeLayer {
    static func lineLayer(
        from: CGPoint,
        to: CGPoint,
        color: CGColor,
        width: CGFloat
    ) -> CAShapeLayer {
        let path = UIBezierPath().then {
            $0.move(to: from)
            $0.addLine(to: to)
        }
        let lineLayer = CAShapeLayer().then {
            $0.path = path.cgPath
            $0.fillColor = UIColor.clear.cgColor
            $0.strokeColor = color
            $0.lineWidth = width
        }
        return lineLayer
    }
}
