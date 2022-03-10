//
//  CoinSecondInformationView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/02.
//

import UIKit

import SnapKit
import Then

final class CoinSecondInformationView: UIView {
    
    private static let fontSize: CGFloat = 10.0
    private static let valueFormat: String = "%.1f"
    
    // MARK: - Instance Property
    
    var ticker: BTSocketAPIResponse.TickerResponse? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    private let sellVolumeTitleLabel = UILabel().then {
        $0.text = "매도누적"
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let sellVolumeValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    private let buyVolumeTitleLabel = UILabel().then {
        $0.text = "매수누적"
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let buyVolumeValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    private let prevClosePriceTitleLabel = UILabel().then {
        $0.text = "전일종가"
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let prevClosePriceValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    private let chgRateTitleLabel = UILabel().then {
        $0.text = "변동률"
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let chgRateValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    private let chgAmtTitleLabel = UILabel().then {
        $0.text = "변동액"
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let chgAmtValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    private let volumePowerTitleLabel = UILabel().then {
        $0.text = "체결강도"
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
    }
    private let volumePowerValueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: CoinSecondInformationView.fontSize)
        $0.textColor = .lightGray
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
        self.sellVolumeValueLabel.text = self.formatToString(of: ticker.content.sellVolume)
        self.buyVolumeValueLabel.text = self.formatToString(of: ticker.content.buyVolume)
        self.prevClosePriceValueLabel.text = self.formatToString(
            of: ticker.content.prevClosePrice
        )
        self.chgRateValueLabel.text = self.formatToString(of: ticker.content.chgRate)
        self.volumePowerValueLabel.text = self.formatToString(of: ticker.content.volumePower)
        self.chgAmtValueLabel.text = self.formatToString(of: ticker.content.chgAmt)
    }
    
    // MARK: - custom funcs

    func configUI() {
        let sellVolumeStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.sellVolumeTitleLabel, self.sellVolumeValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.sellVolumeValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.sellVolumeTitleLabel).multipliedBy(2)
        }
        let buyVolumeStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.buyVolumeTitleLabel, self.buyVolumeValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.buyVolumeValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.buyVolumeTitleLabel).multipliedBy(2)
        }
        let prevClosePriceStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.prevClosePriceTitleLabel, self.prevClosePriceValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.prevClosePriceValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.prevClosePriceTitleLabel).multipliedBy(2)
        }
        let chgRateStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.chgRateTitleLabel, self.chgRateValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.chgRateValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.chgRateTitleLabel).multipliedBy(2)
        }
        let volumePowerStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.volumePowerTitleLabel, self.volumePowerValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.volumePowerValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.volumePowerTitleLabel).multipliedBy(2)
        }
        let chgAmtStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.chgAmtTitleLabel, self.chgAmtValueLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.chgAmtValueLabel.snp.makeConstraints { make in
            make.width.equalTo(self.chgAmtTitleLabel).multipliedBy(2)
        }
        let wholeStackView: UIStackView = UIStackView(
            arrangedSubviews: [
                sellVolumeStackView,
                buyVolumeStackView,
                self.borderView,
                prevClosePriceStackView,
                volumePowerStackView,
                chgAmtStackView,
                chgRateStackView
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
                format: CoinSecondInformationView.valueFormat,
                number / 100000000.0
            ) + "억"
        } else {
            return String(format: CoinSecondInformationView.valueFormat, number)
        }
    }
}
