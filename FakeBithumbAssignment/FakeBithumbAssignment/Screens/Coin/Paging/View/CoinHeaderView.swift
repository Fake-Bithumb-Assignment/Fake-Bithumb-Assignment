//
//  CoinHeaderView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/26.
//

import UIKit

import SnapKit
import Then

final class CoinHeaderView: UIView {
    
    // MARK: - Instance Property

    private let currentPriceLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title2)
    }
    
    private let fluctateLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
    }
    
    private let fluctateImageView = UIImageView().then {
        $0.image = UIImage()
    }
    
    private let fluctateRateLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
    }
    
    
    // MARK: - Life Cycle func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.render()
        self.configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - custom func
    
    private func render() {
        self.addSubViews([currentPriceLabel, fluctateLabel, fluctateImageView, fluctateRateLabel])
        
        self.snp.makeConstraints { make in
            make.height.equalTo(90)
        }
        
        self.currentPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.leading.equalTo(self).offset(20)
            make.width.equalTo(150)
        }
        
        self.fluctateLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPriceLabel.snp.bottom)
            make.leading.equalTo(self).offset(20)
        }
        
        self.fluctateImageView.snp.makeConstraints { make in
            make.centerY.equalTo(fluctateLabel)
            make.leading.equalTo(fluctateLabel.snp.trailing).offset(10)
            make.width.height.equalTo(10)
        }
        
        self.fluctateRateLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPriceLabel.snp.bottom)
            make.leading.equalTo(fluctateImageView.snp.trailing).offset(2)
        }
    }
    
    private func configUI() {
        self.backgroundColor = .white
    }
    
    func patchData(data: CoinHeaderModel) {
        self.currentPriceLabel.text = String.insertComma(value: Double(data.currentPrice)!)
        self.fluctateLabel.text = String.insertComma(value: Double(data.fluctate)!)
        self.fluctateRateLabel.text = String.insertComma(value: Double(data.fluctateRate)!) + "%"
        self.setLabelColor(data: data)
    }
    
    private func setLabelColor(data: CoinHeaderModel) {
        guard let fluctateRate = Double(data.fluctateRate) else { return }
        if fluctateRate > 0 {
            self.currentPriceLabel.textColor = UIColor(named: "up")
            self.fluctateLabel.textColor = UIColor(named: "up")
            self.fluctateRateLabel.textColor = UIColor(named: "up")
            self.fluctateImageView.image = UIImage(named: "up")
        } else if fluctateRate < 0 {
            self.currentPriceLabel.textColor = UIColor(named: "down")
            self.fluctateLabel.textColor = UIColor(named: "down")
            self.fluctateRateLabel.textColor = UIColor(named: "down")
            self.fluctateImageView.image = UIImage(named: "down")
        } else {
            self.currentPriceLabel.textColor = .black
            self.fluctateLabel.textColor = .black
            self.fluctateRateLabel.textColor = .black
            self.fluctateImageView.image = UIImage()
        }
    }
}
