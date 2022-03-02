//
//  BuyGraphTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/02.
//

import UIKit

import SnapKit
import Then

class BuyGraphTableViewCell: BaseTableViewCell {
    
    // MARK: - Instance Property
    
    private let buyPriceLabel = UILabel().then {
        $0.text = "0.0750"
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.textColor = .darkGray
    }
    
    private let buyGraphView = UIView().then {
        $0.backgroundColor = UIColor(named: "buyGraphView")
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0.5,
                                                                               left: 0.5,
                                                                               bottom: 0.5,
                                                                               right: 0.5))
    }
    
    override func render() {
        self.contentView.addSubViews([self.buyGraphView, self.buyPriceLabel])
        
        self.buyGraphView.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading)
            make.height.equalTo(14)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(50)
        }
        
        self.buyPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.contentView.snp.leading)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    override func configUI() {
        self.contentView.backgroundColor = UIColor(named: "buyView")
    }
    
    
    // MARK: - custom funcs
    
    func update() {
        
    }
}

