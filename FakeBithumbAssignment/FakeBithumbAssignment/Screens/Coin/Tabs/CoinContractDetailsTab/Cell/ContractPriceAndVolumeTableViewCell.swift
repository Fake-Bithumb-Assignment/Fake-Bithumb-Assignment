//
//  ContractPriceAndVolumeTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/07.
//

import UIKit

import SnapKit
import Then

enum ContractTableLabelType {
    case price, volume
}

class ContractPriceAndVolumeTableViewCell: BaseTableViewCell {
    
    // MARK: - Instance Property
    
    private let contentLabel = UILabel().then {
        $0.text = "40,000,000"
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.textColor = .darkGray
    }
    
    
    // MARK: - Life Cycle func
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        self.contentView.addSubView(self.contentLabel)
        
        self.contentLabel.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
        }
    }
    
    
    // MARK: - custom funcs
    
    func update(to: TransactionAPIResponse, type: ContractTableLabelType) {
        switch type {
        case .price:
            self.contentLabel.text = to.price
        case .volume:
            self.contentLabel.text = to.unitsTraded
        }
    }
}

