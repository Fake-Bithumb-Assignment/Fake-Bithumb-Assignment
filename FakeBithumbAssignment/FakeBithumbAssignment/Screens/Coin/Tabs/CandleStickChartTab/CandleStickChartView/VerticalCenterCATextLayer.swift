//
//  VerticalCenterCATextLayer.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/07.
//

import UIKit

class VerticalCenterCATextLayer : CATextLayer {
    override func draw(in context: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height-fontSize)/2 - fontSize/10
        context.saveGState()
        context.translateBy(x: 0, y: yDiff)
        super.draw(in: context)
        context.restoreGState()
    }
}
