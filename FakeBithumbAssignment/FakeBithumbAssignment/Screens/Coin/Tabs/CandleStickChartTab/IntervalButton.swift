//
//  IntervalButton.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/05.
//

import UIKit

final class IntervalButton: UIButton {
    
    // MARK: - Instance Property

    let interval: BTCandleStickChartInterval
    
    // MARK: - Initializer

    init(title: String, interval: BTCandleStickChartInterval) {
        self.interval = interval
        super.init(frame: .zero)
        super.setTitle(title, for: .normal)
        super.setTitleColor(.black, for: .normal)
        super.backgroundColor = UIColor.white
        super.titleLabel?.font = .systemFont(ofSize: 10)
        super.layer.cornerRadius = 3.0
    }
    
    required init?(coder: NSCoder) {
        self.interval = ._1m
        super.init(coder: coder)
    }

    // MARK: - custom func

    func select() {
        super.backgroundColor = UIColor(named: "buttonSelected")
    }
    
    func deselect() {
        super.backgroundColor = UIColor.white
    }
}
