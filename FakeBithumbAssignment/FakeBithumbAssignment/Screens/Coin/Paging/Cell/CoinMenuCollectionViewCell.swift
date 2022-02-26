//
//  CoinMenuCollectionViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/26.
//

import UIKit

import SnapKit
import Then

enum CoinMenuTitleEnum {
    case quoteInformation, graph, contractDetails
}

class CoinMenuCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Instance Property
    
    private var titleLabel = UILabel()
    
    private var bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    override func render() {
        contentView.addSubViews([titleLabel, bottomView])
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(5)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(contentView)
            make.height.equalTo(3)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                bottomView.backgroundColor = .black
            } else {
                bottomView.backgroundColor = .white
            }
        }
    }
    
    // MARK: - custom func
    
    func update(type: CoinMenuTitleEnum) {
        switch type {
        case .quoteInformation:
            titleLabel.text = "호가"
        case .graph:
            titleLabel.text = "차트"
        case .contractDetails:
            titleLabel.text = "시세"
        }
    }
}
