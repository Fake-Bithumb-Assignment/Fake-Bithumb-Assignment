//
//  TransactionTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/13.
//

import UIKit

final class TransactionTableViewCell: BaseTableViewCell {
    
    // MARK: - Instance Property
    
    var transaction: Transaction? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    private let dateLabel: UILabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.textColor = .darkGray
    }
    private let priceLabel: UILabel = RightPaddingLabel().then {
        $0.textAlignment = .right
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray5.cgColor
    }
    private let quantityLabel: UILabel = RightPaddingLabel().then {
        $0.textAlignment = .right
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    // MARK: - Lifecycle Func
    
    override func layoutSubviews() {
        guard let transaction = transaction else {
            return
        }
        guard let beforeDot: Substring = transaction.date.split(separator: ".").first,
              let afterSace: Substring = beforeDot.split(separator: " ").last,
              let quantityDouble: Double = Double(transaction.quantity)
        else {
            return
        }
        self.dateLabel.text = String(afterSace)
        self.priceLabel.textColor = self.getColor()
        self.priceLabel.text = transaction.price
        self.quantityLabel.textColor = self.getColor()
        self.quantityLabel.text = String(format: "%.4f", quantityDouble)
    }
    
    // MARK: - custom func
    
    override func configUI() {
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [self.dateLabel, self.priceLabel, self.quantityLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .fill
        }
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.equalTo(self.dateLabel).multipliedBy(5)
            make.width.equalTo(self.priceLabel).multipliedBy(2.5)
            make.width.equalTo(self.quantityLabel).multipliedBy(2.5)
            make.edges.equalTo(self)
        }
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    private func getColor() -> UIColor {
        guard let transactionType: Transaction.TransactionType = self.transaction?.transactionType else {
            return UIColor.black
        }
        switch transactionType {
        case .ask:
            return UIColor(named: "down") ?? UIColor.blue
        case .bid:
            return UIColor(named: "up") ?? UIColor.red
        }
    }
}

final class RightPaddingLabel: UILabel {
    
    // MARK: - Instance Property

    private var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10.0)
    
    // MARK: - Lifecycle func

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
