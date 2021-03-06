//
//  ColumnNameView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/24.
//

import UIKit

import SnapKit
import Then

final class ColumnNameView: UIView {

    // MARK: - Instance Property

    private let coinNameLabel: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.text = "가상자산명"
        $0.textColor = .gray
        $0.textAlignment = .left
    }
    private let currentPriceLabel: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.text = "현재가"
        $0.textColor = .gray
        $0.textAlignment = .right
    }
    private let changeRateLabel: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.text = "변동률"
        $0.textColor = .gray
        $0.textAlignment = .right
    }
    private let tradeValueLabel: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.text = "거래금액"
        $0.textColor = .gray
        $0.textAlignment = .right
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - custom func

    private func configUI() {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            self.coinNameLabel,
            self.currentPriceLabel,
            self.changeRateLabel,
            self.tradeValueLabel
        ]).then {
            $0.alignment = .center
            $0.spacing = 10
        }

        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.width.equalTo(self.coinNameLabel).multipliedBy(4)
            make.width.equalTo(self.currentPriceLabel).multipliedBy(4)
            make.width.equalTo(self.changeRateLabel).multipliedBy(5)
        }
    }
}
