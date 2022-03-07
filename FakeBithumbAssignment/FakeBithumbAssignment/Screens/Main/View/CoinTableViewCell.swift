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
    }

    private let changeRate = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    private let tradeValue = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.textAlignment = .right
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    // MARK: - custom func

    override func configUI() {
        self.backgroundColor = .clear
    }
    
    override func render() {
        configureStackView()
    }

    func configure(with model: CoinData?) {
        coinName.text = model?.coinName.rawValue
        currentPrice.text = model?.currentPrice
        changeRate.text = model?.changeRate
        tradeValue.text = model?.tradeValue
        
        if let changeRateString = model?.changeRate.replacingOccurrences(of: "%", with: ""),
        let changeRate = Double(changeRateString) {
            if changeRate < 0.0 {
                configureTextColor(.systemBlue)
            }
            else if changeRate > 0.0 {
                configureTextColor(.systemRed)
            }
            else {
                configureTextColor(.black)
            }
        }
    }
    
    private func configureTextColor(_ color: UIColor) {
        currentPrice.textColor = color
        changeRate.textColor = color
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
