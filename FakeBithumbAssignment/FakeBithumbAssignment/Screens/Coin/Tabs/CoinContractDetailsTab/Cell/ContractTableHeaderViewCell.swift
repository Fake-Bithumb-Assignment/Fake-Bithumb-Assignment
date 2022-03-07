//
//  ContractTableHeaderViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/07.
//

import UIKit

import SnapKit
import Then

class ContractTableHeaderViewCell: UITableViewHeaderFooterView {
    
    // MARK: - Instance Property
    
    let titleLabel = UILabel().then {
        $0.text = "가격"
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.textColor = .darkGray
    }
    
    
    // MARK: - Life Cycle func
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.render()
        print("?")
    }
    
    func render() {
        self.contentView.addSubView(titleLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
        }
    }
    
    
    // MARK: - custom funcs
    
    func setHeaderViewTitle(to type: ContractHeader) {
        switch type {
        case .time:
            self.titleLabel.text = "시간"
        case .price:
            self.titleLabel.text = "가격"
        case .volume:
            self.titleLabel.text = "체결량"
        }
    }
}

