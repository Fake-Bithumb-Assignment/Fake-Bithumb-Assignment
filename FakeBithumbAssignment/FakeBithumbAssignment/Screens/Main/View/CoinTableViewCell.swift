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

    private let coinName: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "primaryBlack")
        $0.numberOfLines = 2
    }
    private let coinSymbol: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption2)
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "line")
        $0.numberOfLines = 0
    }
    private let currentPrice: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textAlignment = .right
        $0.textColor = UIColor(named: "primaryBlack")
        $0.numberOfLines = 0
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.sizeToFit()
    }
    private let changeRate: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textAlignment = .right
        $0.textColor = UIColor(named: "primaryBlack")
        $0.layer.borderColor = UIColor.clear.cgColor
    }
    private let tradeValue: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textAlignment = .right
        $0.textColor = UIColor(named: "primaryBlack")
        $0.numberOfLines = 0
    }
    private let changeAmount: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption2)
        $0.textAlignment = .right
        $0.textColor = UIColor(named: "primaryBlack")
        $0.numberOfLines = 0
    }
    private lazy var changeView: UIStackView = configureChangeView()
    private lazy var coinView: UIStackView = configureCoinView()
    private var priceIncrement: Bool = false

    // MARK: - custom func

    override func configUI() {
        self.backgroundColor = .white
    }
    
    override func render() {
        self.configureStackView()
    }

    func configure(with model: CoinData?) {
        guard let model = model else {
            return
        }

        self.checkChangePrice(of: model)

        self.coinName.text = model.coinName.rawValue
        self.coinSymbol.text = "\(model.coinName)/KRW"
        self.currentPrice.text = model.currentPrice
        self.changeRate.text = model.changeRate + "%"
        self.changeAmount.text = model.changeAmount
        self.tradeValue.text = model.tradeValue + "백만"

        let changeRateString: String = model.changeRate

        if let changeRate = Double(changeRateString) {
            self.configureTextColor(changeRate)
        }
    }

    private func checkChangePrice(of model: CoinData) {
        let previousPriceString: String = model.previousPrice.replacingOccurrences(of: ",", with: "")
        let currentPriceString: String = model.currentPrice.replacingOccurrences(of: ",", with: "")

        guard let previousPrice = Double(previousPriceString),
              let currentPrice = Double(currentPriceString)
        else {
            return
        }

        if previousPrice != currentPrice {
            self.priceIncrement = previousPrice < currentPrice ? true : false
            guard let color = priceIncrement ? UIColor(named: "up") : UIColor(named: "down")
            else {
                return
            }

            self.currentPrice.animateBorderColor(toColor: color, duration: 0.1)
        }
    }

    private func configureTextColor(_ changeRate: Double) {
        let changeRate: Int = Int(changeRate * 100)

        if changeRate < 0 {
            let color: UIColor = UIColor(named: "down") ?? .systemBlue
            self.currentPrice.textColor = color
            self.changeRate.textColor = color
            self.changeAmount.textColor = color
        } else if changeRate > 0 {
            let color: UIColor = UIColor(named: "up") ?? .systemRed
            self.currentPrice.textColor = color
            self.changeRate.textColor = color
            self.changeAmount.textColor = color

            if let changeRate = self.changeRate.text,
               let changeAmount = self.changeAmount.text {
                self.changeRate.text = "+" + changeRate
                self.changeAmount.text = "+" + changeAmount
            }
        } else {
            self.changeRate.text = "0.00%"
            self.changeRate.textColor = .black
            self.currentPrice.textColor = .black
            self.changeAmount.textColor = .black
        }
    }

    private func configureStackView() {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            self.coinView,
            self.currentPrice,
            self.changeView,
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

    private func configureChangeView() -> UIStackView {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            self.changeRate,
            self.changeAmount
        ]).then {
            $0.spacing = 5
            $0.axis = .vertical
            $0.alignment = .trailing
        }

        return stackView
    }

    private func configureCoinView() -> UIStackView {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            self.coinName,
            self.coinSymbol
        ]).then {
            $0.spacing = 5
            $0.axis = .vertical
            $0.alignment = .fill
        }

        return stackView
    }
}
