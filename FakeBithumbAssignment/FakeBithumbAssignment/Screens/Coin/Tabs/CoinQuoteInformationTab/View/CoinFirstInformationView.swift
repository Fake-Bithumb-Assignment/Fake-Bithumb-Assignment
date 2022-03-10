//
//  CoinFirstInformationView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/02.
//

import UIKit

import SnapKit
import Then

final class CoinFirstInformationView: UIView {
    
    private static let fontSize: CGFloat = 10.0
    private static let valueFormat: String = "%.1f"
    
    // MARK: - Instance Property
    
    var ticker: BTSocketAPIResponse.TickerResponse? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    private let valueTitleLabel = UILabel().then {
        $0.text = "거래금"
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let valueValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    private let volumeTitleLabel = UILabel().then {
        $0.text = "거래량"
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let volumeValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    private let openPriceTitleLabel = UILabel().then {
        $0.text = "시가"
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let openPriceValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    private let closePriceTitleLabel = UILabel().then {
        $0.text = "종가"
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let closePriceValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    private let lowPriceTitleLabel = UILabel().then {
        $0.text = "저가"
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = UIColor(named: "down")
    }
    private let lowPriceValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = UIColor(named: "down")
        $0.textAlignment = .right
    }
    private let highPriceTitleLabel = UILabel().then {
        $0.text = "고가"
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = UIColor(named: "up")
    }
    private let highPriceValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinFirstInformationView.fontSize)
        $0.textColor = UIColor(named: "up")
        $0.textAlignment = .right
    }
    private let borderView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    
    // MARK: - Life Cycle func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        guard let ticker = ticker else {
            return
        }
        self.valueValueLabel.text = self.formatToString(of: ticker.content.value)
        self.volumeValueLabel.text = self.formatToString(of: ticker.content.volume)
        self.openPriceValueLabel.text = self.formatToString(of: ticker.content.openPrice)
        self.closePriceValueLabel.text = self.formatToString(of: ticker.content.closePrice)
        self.highPriceValueLabel.text = self.formatToString(of: ticker.content.highPrice)
        self.lowPriceValueLabel.text = self.formatToString(of: ticker.content.lowPrice)
    }

    // MARK: - custom funcs
    
    func configUI() {
        let valueStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.valueTitleLabel, self.valueValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.valueValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.valueTitleLabel).multipliedBy(2)
        }
        let volumeStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.volumeTitleLabel, self.volumeValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.volumeValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.volumeTitleLabel).multipliedBy(2)
        }
        let openPriceStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.openPriceTitleLabel, self.openPriceValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.openPriceValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.openPriceTitleLabel).multipliedBy(2)
        }
        let closePriceStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.closePriceTitleLabel, self.closePriceValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.closePriceValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.closePriceTitleLabel).multipliedBy(2)
        }
        let highPriceStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.highPriceTitleLabel, self.highPriceValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.highPriceValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.highPriceTitleLabel).multipliedBy(2)
        }
        let lowPriceStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.lowPriceTitleLabel, self.lowPriceValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.lowPriceValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.lowPriceTitleLabel).multipliedBy(2)
        }
        let wholeStackView: UIStackView = UIStackView(
            arrangedSubviews: [
                valueStackView,
                volumeStackView,
                self.borderView,
                openPriceStackView,
                highPriceStackView,
                lowPriceStackView,
                closePriceStackView
            ]
        ).then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .fill
        }
        self.borderView.snp.makeConstraints { make in
            make.height.equalTo(0.3)
        }
        self.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: 5,
                    left: 5,
                    bottom: 5,
                    right: 5
                )
            )
        }
    }
    
    private func formatToString(of number: Double) -> String {
        if number > 100000000.0 {
            return String(
                format: CoinFirstInformationView.valueFormat,
                number / 100000000.0
            ) + "억"
        } else {
            return String(format: CoinFirstInformationView.valueFormat, number)
        }
    }
}
