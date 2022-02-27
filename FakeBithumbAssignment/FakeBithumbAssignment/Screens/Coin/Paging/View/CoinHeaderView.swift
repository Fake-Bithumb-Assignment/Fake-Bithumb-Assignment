//
//  CoinHeaderView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/26.
//

import UIKit

import SnapKit
import Then

class CoinHeaderView: UIView {
    
    // MARK: - Instance Property

    private let currentPriceLabel = UILabel().then {
        $0.text = "45,594,000"
        $0.font = .preferredFont(forTextStyle: .title2)
    }
    
    private let fluctateLabel = UILabel().then {
        $0.text = "-1,578,000"
        $0.font = .preferredFont(forTextStyle: .subheadline)
    }
    
    private let fluctateImageView = UIImageView().then {
        $0.image = UIImage(named: "up")
    }
    
    private let fluctateRateLabel = UILabel().then {
        $0.text = "3.35%"
        $0.font = .preferredFont(forTextStyle: .subheadline)
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
    
    
    // MARK: - custom func
    
    func render() {
        self.addSubViews([currentPriceLabel, fluctateLabel, fluctateImageView, fluctateRateLabel])
        
        currentPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(150)
        }
        
        fluctateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentPriceLabel.snp.bottom)
            make.leading.equalTo(self).offset(20)
        }
        
        fluctateImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(fluctateLabel)
            make.leading.equalTo(fluctateLabel.snp.trailing).offset(10)
            make.width.height.equalTo(10)
        }
        
        fluctateRateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentPriceLabel.snp.bottom)
            make.leading.equalTo(fluctateImageView.snp.trailing).offset(2)
        }
    }
    
    func configUI() {
        self.backgroundColor = .white
    }
}
