//
//  CoinTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/26.
//

import UIKit

import SnapKit
import Then

class CoinTableViewCell: BaseTableViewCell {

    // MARK: - Instance Property

    private let coinName = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.textAlignment = .left
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    private let currentPrice = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.textAlignment = .right
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
    }

    private let changeRate = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
    }

    private let tradeValue = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.textAlignment = .right
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    private var priceIncrement = false

    // MARK: - custom func

    override func configUI() {
        self.backgroundColor = .clear
    }
    
    override func render() {
        configureStackView()
    }

    func configure(with model: CoinData?) {
        guard let model = model else {
            return
        }
        
        self.checkChangeRate(of: model)

        self.coinName.text = model.coinName.rawValue
        self.currentPrice.text = model.currentPrice
        self.changeRate.text = model.changeRate + "%"
        self.tradeValue.text = model.tradeValue + "백만"
        
        let changeRateString = model.changeRate

        if let changeRate = Double(changeRateString) {
            self.configureTextColor(changeRate)
            guard let color = priceIncrement ? UIColor(named: "up") : UIColor(named: "down")
            else {
                return
            }

            self.currentPrice.animateBorderColor(toColor: color, duration: 0.1)
            self.changeRate.animateBorderColor(toColor: color, duration: 0.1)
        }
    }

    private func checkChangeRate(of model: CoinData) {
        guard var previousChangeRateString = self.changeRate.text else {
            return
        }
        
        previousChangeRateString.removeLast()
        
        guard let previousChangeRate = Double(previousChangeRateString),
              let updatedChangeRate = Double(model.changeRate) else {
                  return
              }

        self.priceIncrement = previousChangeRate < updatedChangeRate ? true : false
    }

    private func configureTextColor(_ changeRate: Double) {
        let changeRate = Int(changeRate * 100)

        if changeRate < 0 {
            let color = UIColor(named: "down") ?? .systemBlue
            self.currentPrice.textColor = color
            self.changeRate.textColor = color
        }
        else if changeRate > 0 {
            let color = UIColor(named: "up") ?? .systemRed
            self.currentPrice.textColor = color
            self.changeRate.textColor = color
        }
        else {
            self.changeRate.textColor = .black
            self.currentPrice.textColor = .black
        }
    }

    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            self.coinName,
            self.currentPrice,
            self.changeRate,
            self.tradeValue
        ]).then {
            $0.spacing = 10
            $0.axis = .horizontal
            $0.alignment = .center
        }

        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.width.equalTo(self.coinName).multipliedBy(4)
            make.width.equalTo(self.currentPrice).multipliedBy(4)
            make.width.equalTo(self.changeRate).multipliedBy(5)
        }
    }
}
