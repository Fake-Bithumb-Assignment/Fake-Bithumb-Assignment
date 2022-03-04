//
//  IntervalButton.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/05.
//

import UIKit

class IntervalButton: UIButton {
    let interval: BTCandleStickChartInterval
    
    init(interval: BTCandleStickChartInterval) {
        self.interval = interval
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.interval = ._1m
        super.init(coder: coder)
    }
}
