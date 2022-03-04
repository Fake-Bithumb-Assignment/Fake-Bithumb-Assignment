//
//  IntervalButton.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/05.
//

import UIKit

class IntervalButton: UIButton {
    let interval: BTCandleStickChartInterval
    
    init(title: String, interval: BTCandleStickChartInterval) {
        self.interval = interval
        super.init(frame: .zero)
        super.setTitle(title, for: .normal)
        super.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 10)
    }
    
    required init?(coder: NSCoder) {
        self.interval = ._1m
        super.init(coder: coder)
    }
}
