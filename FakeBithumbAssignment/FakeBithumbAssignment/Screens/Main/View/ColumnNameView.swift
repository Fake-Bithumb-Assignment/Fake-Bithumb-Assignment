//
//  ColumnNameView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/24.
//

import UIKit

import SnapKit

class ColumnNameView: UIView {

    private let coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "가상자산명"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "현재가"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let fluctuationRateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "변동률"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let tradeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "거래금액"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureCoinNameLabel()
        configureCurrentPriceLabel()
        configureFluctuationRateLabel()
        configureTradeValueLabel()
    }

    private func configureCoinNameLabel() {
        self.addSubview(coinNameLabel)
        coinNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().dividedBy(2)
        }
    }

    private func configureCurrentPriceLabel() {
        self.addSubview(currentPriceLabel)
        currentPriceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(coinNameLabel.snp.trailing)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().dividedBy(2)
        }
    }

    private func configureFluctuationRateLabel() {
        self.addSubview(fluctuationRateLabel)
        fluctuationRateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(currentPriceLabel.snp.trailing)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().dividedBy(2)
        }
    }

    private func configureTradeValueLabel() {
        self.addSubview(tradeValueLabel)
        tradeValueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(fluctuationRateLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalToSuperview().dividedBy(2)
        }
    }
}
