//
//  SellGraphTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/02.
//

import UIKit

import SnapKit
import Then

class SellGraphTableViewCell: BaseTableViewCell {
    
    // MARK: - Instance Property
    
    private let sellPriceLabel = UILabel().then {
        $0.text = "0.0750"
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.textColor = .darkGray
    }
    
    private let sellGraphView = UIView().then {
        $0.backgroundColor = .blue
    }
    
    
    // MARK: - Life Cycle func
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.render()
        self.configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        self.contentView.addSubViews([self.sellGraphView, self.sellPriceLabel])
        
        self.sellGraphView.snp.makeConstraints { make in
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.height.equalTo(14)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(30)
        }
        
        self.sellPriceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    override func configUI() {
        self.contentView.backgroundColor = .white
    }
    
    
    // MARK: - custom funcs
    
    func update() {
        
    }
}
