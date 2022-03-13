//
//  ContractTimeTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/07.
//

import UIKit

import SnapKit
import Then

enum APIType {
    case rest, websocket
}

class ContractTimeTableViewCell: BaseTableViewCell {
    
    // MARK: - Instance Property
    
    private let timeLabel = UILabel().then {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    override func render() {
        self.contentView.addSubView(timeLabel)
        
        self.timeLabel.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
        }
    }
    
    override func configUI() {
        self.timeLabel.textColor = .darkGray
    }
    
    
    // MARK: - custom funcs
    
    func update(to: TransactionAPIResponse, type: APIType) {
        switch type {
        case .rest:
            self.timeLabel.text = to.transactionDate
        case .websocket:
            self.timeLabel.text = self.configureWebsocketTransactionDate(to.transactionDate)
        }
    }

    private func configureWebsocketTransactionDate(_ date: String) -> String? {
        let splitedGivenDate = date.components(separatedBy: " ")
        var splitedTime = splitedGivenDate[1].components(separatedBy: ":")
        let hourString = splitedTime[0]
        guard var hour = Int(hourString) else {
            return nil
        }
        
        hour += 9
        
        if hour > 23 {
            hour -= 24
        }
        
        if hour < 10 {
            splitedTime[0] = "0\(hour)"
        }
        
        else {
            splitedTime[0] = "\(hour)"
        }

        return splitedTime.joined(separator: ":")
    }
}
