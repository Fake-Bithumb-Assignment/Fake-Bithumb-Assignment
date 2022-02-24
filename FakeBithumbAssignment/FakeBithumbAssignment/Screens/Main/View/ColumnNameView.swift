//
//  ColumnNameView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/24.
//

import UIKit

import SnapKit

final class ColumnNameView: UIView {

    // MARK: - Instance Property

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
        label.textAlignment = .right
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
        label.textAlignment = .right
        return label
    }()

    // MARK: - Life Cycle func

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - custom func

    private func configUI() {
        configureCoinNameLabel()
        configureCurrentPriceLabel()
        configureFluctuationRateLabel()
        configureTradeValueLabel()
    }

    private func configureCoinNameLabel() {
        self.addSubview(coinNameLabel)
        coinNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalToSuperview().dividedBy(2)
        }
    }

    private func configureCurrentPriceLabel() {
        self.addSubview(currentPriceLabel)
        currentPriceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(coinNameLabel.snp.trailing)
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalToSuperview().dividedBy(2)
        }
    }

    private func configureFluctuationRateLabel() {
        self.addSubview(fluctuationRateLabel)
        fluctuationRateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(currentPriceLabel.snp.trailing)
            $0.width.equalToSuperview().dividedBy(5)
            $0.height.equalToSuperview().dividedBy(2)
        }
    }

    private func configureTradeValueLabel() {
        self.addSubview(tradeValueLabel)
        tradeValueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(fluctuationRateLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalToSuperview().dividedBy(2)
        }
    }
}
