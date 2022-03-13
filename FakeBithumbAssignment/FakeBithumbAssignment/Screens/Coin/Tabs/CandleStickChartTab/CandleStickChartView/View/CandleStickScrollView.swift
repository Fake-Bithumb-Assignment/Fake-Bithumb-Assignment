//
//  CandleStickScrollView.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/07.
//

import UIKit

final class CandleStickScrollView: UIScrollView {
    
    // MARK: - Instance Property

    var touchEventDelegate: UIResponder? = nil

    // MARK: - custom func

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchEventDelegate?.touchesMoved(touches, with: event)
    }
}
