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
    
    // MARK: - Instance Property
    
    private let previousTradingVolumeTextLabel = UILabel().then {
        $0.text = "전일거래량"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let previousTradingVolumeLabel = UILabel().then {
        $0.text = "5,562,495BTC"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    
    private let previousTradingAmountTextLabel = UILabel().then {
        $0.text = "전일거래금"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let previousTradingAmountLabel = UILabel().then {
        $0.text = "2,280,100KRW"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    
    private let highPriceTextLabel = UILabel().then {
        $0.text = "고가(52주)"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let highPriceLabel = UILabel().then {
        $0.text = "82,477,000"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    private let highPriceDateLabel = UILabel().then {
        $0.text = "2021-11-09"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    private let lowPriceTextLabel = UILabel().then {
        $0.text = "저가(52주)"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let lowPriceLabel = UILabel().then {
        $0.text = "33,700,000"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    private let lowPriceDateLabel = UILabel().then {
        $0.text = "2021-06-22"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    
    private let borderView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private let pageControlView = UIView().then {
        $0.backgroundColor = .red
    }
    
    
    // MARK: - Life Cycle func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - custom funcs
    
    func render() {
        self.addSubView(pageControlView)
        
        self.pageControlView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(20)
            make.bottom.equalTo(self)
        }
    }
    
    func configUI() {
        configStackView()
    }
    
    func configStackView() {
        let tradingVolumeStackView = UIStackView(arrangedSubviews: [
            previousTradingVolumeTextLabel,
            previousTradingVolumeLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let tradingAmountStackView = UIStackView(arrangedSubviews: [
            previousTradingAmountTextLabel,
            previousTradingAmountLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let highPriceStackView = UIStackView(arrangedSubviews: [
            highPriceTextLabel,
            highPriceLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let highPriceRateStackView = UIStackView(arrangedSubviews: [
            UIView(),
            highPriceDateLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let lowPriceStackView = UIStackView(arrangedSubviews: [
            lowPriceTextLabel,
            lowPriceLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let lowPriceRateStackView = UIStackView(arrangedSubviews: [
            UIView(),
            lowPriceDateLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let wholeStackView = UIStackView(arrangedSubviews: [
            tradingVolumeStackView,
            tradingAmountStackView,
            self.borderView,
            highPriceStackView,
            highPriceRateStackView,
            lowPriceStackView,
            lowPriceRateStackView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        self.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(2)
            make.trailing.equalTo(self).inset(2)
            make.top.equalTo(self.snp.top).offset(5)
        }
        
        self.borderView.snp.makeConstraints { make in
            make.height.equalTo(0.3)
        }
    }
}
