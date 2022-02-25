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
        let stackView = UIStackView(arrangedSubviews: [
            self.coinNameLabel,
            self.currentPriceLabel,
            self.fluctuationRateLabel,
            self.tradeValueLabel
        ])
        stackView.alignment = .center

        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.width.equalTo(self.coinNameLabel).multipliedBy(4)
            make.width.equalTo(self.currentPriceLabel).multipliedBy(4)
            make.width.equalTo(self.fluctuationRateLabel).multipliedBy(5)
        }
    }
}
