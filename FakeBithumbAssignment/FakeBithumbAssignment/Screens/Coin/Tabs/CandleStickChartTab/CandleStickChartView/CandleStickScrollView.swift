//
//  CandleStickScrollView.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/07.
//

import UIKit

class CandleStickScrollView: UIScrollView {
    var touchEventDelegate: UIResponder? = nil
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchEventDelegate?.touchesMoved(touches, with: event)
    }
}
