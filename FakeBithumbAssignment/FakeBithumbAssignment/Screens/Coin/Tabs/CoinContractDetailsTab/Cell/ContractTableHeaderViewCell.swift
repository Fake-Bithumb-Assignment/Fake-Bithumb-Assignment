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
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        $0.textColor = .darkGray
    }
    
    
    // MARK: - Life Cycle func
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.render()
        self.configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        self.contentView.addSubView(titleLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
        }
    }
    
    func configUI() {
        self.titleLabel.textColor = .black
        self.backgroundColor = .white
    }
    
    
    // MARK: - custom funcs
    
    func setHeaderViewTitle(to type: ContractHeader, coin: Coin) {
        switch type {
        case .time:
            self.titleLabel.text = "시간"
        case .price:
            self.titleLabel.text = "가격(KRW)"
        case .volume:
            self.titleLabel.text = "체결량(\(String(describing: coin)))"
        }
    }
}

