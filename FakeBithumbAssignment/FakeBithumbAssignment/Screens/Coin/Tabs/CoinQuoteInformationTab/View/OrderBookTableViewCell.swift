//
//  OrderBookTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/09.
//

import UIKit

class OrderBookTableViewCell: BaseTableViewCell {
    
    // MARK: - Instance Property
    
    private var type: OrderType = .ask
    private var quote: Quote?
    private var maxQuantity: Double?
    private let valueView: UIView = UIView()
    private let valuePriceLabel: UILabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    private let valuePercentabeLabel: UILabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
    }
    private let graphView: UIView = UIView()
    private let graphQuantityLabel: UILabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.textColor = .darkGray
        $0.numberOfLines = 0 
    }
    private let graphStickLayer: CALayer = CALayer()
    private var wholeStackView: UIStackView? = nil
    private var cellColor: UIColor {
        get {
            switch self.type {
            case .ask:
                return UIColor(named: "sellView") ?? UIColor.blue
            case .bid:
                return UIColor(named: "buyView") ?? UIColor.red
            }
        }
    }
    private var graphColor: UIColor {
        get {
            switch self.type {
            case .ask:
                return UIColor(named: "sellGraphView") ?? UIColor.white
            case .bid:
                return UIColor(named: "buyGraphView") ?? UIColor.white
            }
        }
    }
    private var graphTextAlignment: NSTextAlignment {
        get {
            switch self.type {
            case .ask:
                return .right
            case .bid:
                return .left
            }
        }
    }
    private let inset: CGFloat = 0.5
    
    // MARK: - Life Cycle func
    
    override func render() {
        let valueStackView: UIStackView = UIStackView(
            arrangedSubviews: [
                self.valuePriceLabel,
                self.valuePercentabeLabel
            ]
        ).then {
                $0.axis = .horizontal
                $0.alignment = .center
        }
        self.valueView.addSubview(valueStackView)
        valueStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: 0,
                    left: 10,
                    bottom: 0,
                    right: 2
                )
            )
        }
        self.graphView.layer.addSublayer(self.graphStickLayer)
        self.graphView.addSubview(self.graphQuantityLabel)
        self.graphQuantityLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: 0,
                    left: 5,
                    bottom: 0,
                    right: 5
                )
            )
        }
        self.wholeStackView = UIStackView(
            arrangedSubviews: self.type == .ask ?
            [self.graphView, self.valueView] : [self.valueView, self.graphView]
        ).then {
            $0.axis = .horizontal
            $0.spacing = self.inset * 2
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
        guard let wholeStackView = wholeStackView else {
            return
        }
        self.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: self.inset,
                    left: self.inset,
                    bottom: self.inset,
                    right: self.inset
                )
            )
        }
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        guard let quote = quote,
              let maxQuantity = maxQuantity,
              let wholeStackView = wholeStackView,
              let lastView: UIView = wholeStackView.arrangedSubviews.last
        else {
            return
        }
        if self.type == .bid && lastView !== self.graphView {
            wholeStackView.removeArrangedSubview(self.graphView)
            wholeStackView.addArrangedSubview(self.graphView)
        }
        self.graphQuantityLabel.textAlignment = self.graphTextAlignment
        self.valueView.backgroundColor = self.cellColor
        self.graphView.backgroundColor = self.cellColor
        self.graphStickLayer.backgroundColor = self.graphColor.cgColor
        guard !quote.isEmptyQuote else {
            self.valuePriceLabel.text = ""
            self.graphQuantityLabel.text = ""
            self.valuePercentabeLabel.text = ""
            self.graphStickLayer.frame = .zero
            CATransaction.commit()
            return
        }
        self.valuePriceLabel.text = String.insertComma(value: quote.priceNumer)
        self.graphQuantityLabel.text = String.insertComma(value: quote.quantityNumber)
        self.setValuePercentage()
        let graphWidth: CGFloat = self.graphView.bounds.width * (quote.quantityNumber / maxQuantity)
        self.graphStickLayer.frame = CGRect(
            x: type == .ask ? self.graphView.bounds.width - graphWidth : 0,
            y: self.graphView.bounds.height / 3,
            width: graphWidth,
            height: self.graphView.bounds.height / 3
        )
        CATransaction.commit()
    }
        
    // MARK: - custom funcs
    
    func update(type: OrderType, quote: Quote, maxQuantity: Double) {
        self.type = type
        self.quote = quote
        self.maxQuantity = maxQuantity
        self.layoutIfNeeded()
    }
    
    private func setValuePercentage() {
        guard let quote = quote,
              let prevClosePrice = quote.prevClosePrice
        else {
            return
        }
        let percentage: Double = ((quote.priceNumer - prevClosePrice) / prevClosePrice) * 100
        let percentageString: String = String(format: "%.2f", percentage)
        if percentageString == "0.00" {
            self.valuePercentabeLabel.text = "\(percentageString)%"
            self.valuePercentabeLabel.textColor = .black
            self.valuePriceLabel.textColor = .black
        } else if percentage >= 0.0 {
            self.valuePercentabeLabel.text = "+\(percentageString)%"
            self.valuePercentabeLabel.textColor = UIColor(named: "up") ?? .red
            self.valuePriceLabel.textColor = UIColor(named: "up") ?? .red
        } else {
            self.valuePercentabeLabel.text = "\(percentageString)%"
            self.valuePercentabeLabel.textColor = UIColor(named: "down") ?? .blue
            self.valuePriceLabel.textColor = UIColor(named: "down") ?? .blue
        }
    }
}
