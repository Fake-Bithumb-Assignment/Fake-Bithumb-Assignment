//
//  CoinMenuCollectionViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/26.
//

import UIKit

import SnapKit
import Then

enum CoinMenuTitle {
    case quoteInformation, graph, contractDetails
}

final class CoinMenuCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Instance Property
    
    private var titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
    }
    
    private var bottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    override func render() {
        contentView.addSubViews([titleLabel, bottomView])
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(5)
        }
        
        self.bottomView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(contentView)
            make.height.equalTo(3)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.bottomView.backgroundColor = .black
            } else {
                self.bottomView.backgroundColor = .white
            }
        }
    }
    
    // MARK: - custom func
    
    func update(to type: CoinMenuTitle) {
        switch type {
        case .quoteInformation:
            self.titleLabel.text = "호가"
        case .graph:
            self.titleLabel.text = "차트"
        case .contractDetails:
            self.titleLabel.text = "시세"
        }
    }
}
