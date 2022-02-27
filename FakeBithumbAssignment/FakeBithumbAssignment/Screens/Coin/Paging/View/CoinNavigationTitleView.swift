//
//  CoinNavigationTitleView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/26.
//

import UIKit

import SnapKit
import Then

class CoinNavigationTitleView: UIView {
    
    // MARK: - Instance Property
    
    let coinLabel = UILabel().then {
        $0.text = "비트코인"
        $0.font = .preferredFont(forTextStyle: .caption2)
    }
    
    let subCoinLabel = UILabel().then {
        $0.text = "BTC/KRW"
        $0.font = UIFont.systemFont(ofSize: 5)
        $0.textColor = .gray
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
        self.addSubViews([coinLabel, subCoinLabel])
        
        coinLabel.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(self)
        }
        
        subCoinLabel.snp.makeConstraints { (make) in
            make.top.equalTo(coinLabel)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
    
    func configUI() {
        
    }
}
