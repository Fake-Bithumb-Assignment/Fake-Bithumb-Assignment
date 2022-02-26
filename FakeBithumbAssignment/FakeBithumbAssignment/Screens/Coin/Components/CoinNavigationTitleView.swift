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
    let coinLabel = UILabel().then {
        $0.text = "비트코인"
        $0.font = UIFont.systemFont(ofSize: 10)
    }
    
    let subCoinLabel = UILabel().then {
        $0.text = "BTC/KRW"
        $0.font = UIFont.systemFont(ofSize: 5)
        $0.textColor = .gray
    }
    
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
