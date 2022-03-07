//
//  QuoteTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/02.
//

import UIKit

import SnapKit
import Then

class QuoteTableViewCell: BaseTableViewCell {
    
    // MARK: - Instance Property
    
    private let priceLabel = UILabel().then {
        $0.text = "45,601,000"
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.textColor = UIColor(named: "down")
    }
    
    private let fluctateRateLabel = UILabel().then {
        $0.text = "-3.33%"
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = UIColor(named: "down")
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
                                                                               left: 0,
                                                                               bottom: 0.5,
                                                                               right: 0))
    }
    
    override func render() {
        self.contentView.addSubViews([self.priceLabel, self.fluctateRateLabel])
        
        self.priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.leading.equalTo(self.contentView.snp.leading).offset(5)
        }
        
        self.fluctateRateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.contentView.snp.trailing).inset(1)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    override func configUI() {
        self.contentView.backgroundColor = UIColor(named: "sellView")
    }
    
    
    // MARK: - custom funcs
    
    func update(quote: Quote) {
        self.priceLabel.text = quote.price
        self.fluctateRateLabel.text = quote.quantity
    }
    
    func setContentViewColor(to color: UIColor) {
        self.contentView.backgroundColor = color
    }
}
