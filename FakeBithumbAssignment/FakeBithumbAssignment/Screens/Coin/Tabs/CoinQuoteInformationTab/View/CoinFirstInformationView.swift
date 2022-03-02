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
    
    // MARK: - Instance Property
    
    private let tradingVolumeTextLabel = UILabel().then {
        $0.text = "거래량"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let tradingVolumeLabel = UILabel().then {
        $0.text = "4,974,938 BTC"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    
    private let tradingAmountTextLabel = UILabel().then {
        $0.text = "거래금"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let tradingAmountLabel = UILabel().then {
        $0.text = "2,280,100 억"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    
    private let previousPriceTextLabel = UILabel().then {
        $0.text = "전일종가"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let previousPriceLabel = UILabel().then {
        $0.text = "47,172,000"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    
    private let startPriceTextLabel = UILabel().then {
        $0.text = "시가(당일)"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let startPriceLabel = UILabel().then {
        $0.text = "47,171,000"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
        $0.textAlignment = .right
    }
    
    private let highPriceTextLabel = UILabel().then {
        $0.text = "고가(당일)"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let highPriceLabel = UILabel().then {
        $0.text = "47,188,000"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = UIColor(named: "up")
        $0.textAlignment = .right
    }
    
    private let highPriceRateLabel = UILabel().then {
        $0.text = "1.31%"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = UIColor(named: "up")
        $0.textAlignment = .left
    }
    
    private let lowPriceTextLabel = UILabel().then {
        $0.text = "저가(당일)"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
    }
    
    private let lowPriceLabel = UILabel().then {
        $0.text = "44,676,000"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = UIColor(named: "down")
        $0.textAlignment = .right
    }
    
    private let lowPriceRateLabel = UILabel().then {
        $0.text = "-5.29%"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = UIColor(named: "down")
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
            tradingVolumeTextLabel,
            tradingVolumeLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let tradingAmountStackView = UIStackView(arrangedSubviews: [
            tradingAmountTextLabel,
            tradingAmountLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let previousPriceStackView = UIStackView(arrangedSubviews: [
            previousPriceTextLabel,
            previousPriceLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let startPriceStackView = UIStackView(arrangedSubviews: [
            startPriceTextLabel,
            startPriceLabel
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
            highPriceRateLabel
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
            lowPriceRateLabel
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.distribution = .fill
        }
        
        let wholeStackView = UIStackView(arrangedSubviews: [
            tradingVolumeStackView,
            tradingAmountStackView,
            self.borderView,
            previousPriceStackView,
            startPriceStackView,
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
            make.bottom.equalTo(self.pageControlView).inset(5)
        }
        
        self.borderView.snp.makeConstraints { make in
            make.height.equalTo(0.3)
        }
    }
}
