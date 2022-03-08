//
//  ContractTimeTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/07.
//

import UIKit

import SnapKit
import Then

class ContractTimeTableViewCell: BaseTableViewCell {
    
    // MARK: - Instance Property
    
    private let timeLabel = UILabel().then {
        $0.text = "19:20:20"
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
        self.contentView.addSubView(timeLabel)
        
        self.timeLabel.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
        }
    }
    
    override func configUI() {
        self.contentView.backgroundColor = UIColor(named: "sellView")
    }
    
    
    // MARK: - custom funcs
    
    func update(to: TransactionAPIResponse) {
        self.timeLabel.text = to.transactionDate
    }
}
