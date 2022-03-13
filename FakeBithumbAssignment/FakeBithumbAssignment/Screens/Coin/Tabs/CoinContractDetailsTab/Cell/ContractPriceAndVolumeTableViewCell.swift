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
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.textColor = .darkGray
        $0.textAlignment = .right
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
            make.top.bottom.leading.equalTo(self)
            make.trailing.equalTo(self).inset(5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0.5,
                                                                               left: 0.5,
                                                                               bottom: 0.5,
                                                                               right: 0.5))
    }
    
    
    // MARK: - custom funcs
    
    func update(to: TransactionAPIResponse, type: ContractTableLabelType) {
        self.setLabelColor(to: to)
        switch type {
        case .price:
            self.contentLabel.text = self.configurePrice(to.price)
        case .volume:
            self.contentLabel.text = self.configureTrade(to.unitsTraded)
        }
    }
    
    private func setLabelColor(to: TransactionAPIResponse) {
        guard let type = to.type else { return }
        switch type {
        case "ask":
            self.contentLabel.textColor = UIColor(named: "down")
        case "bid":
            self.contentLabel.textColor = UIColor(named: "up")
        default:
            self.contentLabel.textColor = .black
        }
    }
    
    private func configurePrice(_ price: String) -> String? {
        guard let givenPrice = Double(price) else {
            return nil
        }

        if givenPrice > 1000.0 {
             return String.insertComma(value: Int(givenPrice))
        }

        return String.insertComma(value: givenPrice)
    }
    
    private func configureTrade(_ price: String) -> String? {
        guard var givenPrice = Double(price) else {
            return nil
        }
        
        givenPrice = round(givenPrice*10000)/10000
        
        if givenPrice > 1000.0 {
             return String.insertComma(value: Int(givenPrice))
        }
        
        return String(format: "%.4f", givenPrice)
    }
}

