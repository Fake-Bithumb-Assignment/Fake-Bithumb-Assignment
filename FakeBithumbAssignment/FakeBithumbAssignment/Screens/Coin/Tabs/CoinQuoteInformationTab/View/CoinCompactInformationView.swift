//
//  CoinFirstInformationView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/02.
//

import UIKit

import SnapKit
import Then

final class CoinCompactInformationView: UIView {
    
    private static let fontSize: CGFloat = 10.0
    
    // MARK: - Instance Property

    var informtion: CoinInformation = CoinInformation(rows: []) {
        didSet {
            self.setNeedsLayout()
        }
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .lightGray
        $0.snp.makeConstraints { make in
            make.height.equalTo(0.3)
        }
    }
    private var stackView: UIStackView? = nil
    
    // MARK: - Life Cycle func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        guard !self.informtion.rows.isEmpty else {
            return
        }
        let stackView : UIStackView = UIStackView(
            arrangedSubviews: self.informtion.rows.map { row -> UIView in
                switch row.type {
                case .info:
                    let titleLabel: UILabel = UILabel().then {
                        $0.text = row.title
                        $0.font = UIFont.systemFont(ofSize: CoinCompactInformationView.fontSize)
                        $0.textColor = row.color
                    }
                    let valueLabel: UILabel = UILabel().then {
                        $0.text = self.formatToString(of: row.value)
                        $0.font = UIFont.systemFont(ofSize: CoinCompactInformationView.fontSize)
                        $0.textColor = row.color
                        $0.textAlignment = .right
                    }
                    let rowStackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel]).then {
                        $0.axis = .horizontal
                        $0.alignment = .center
                    }
                    valueLabel.snp.makeConstraints { make in
                        make.width.equalTo(titleLabel).multipliedBy(1.5)
                    }
                    return rowStackView
                case .line:
                    return self.lineView
                }
            }
        ).then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .fill
        }
        self.stackView?.removeFromSuperview()
        self.stackView = stackView
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: 5,
                    left: 5,
                    bottom: 5,
                    right: 5
                )
            )
        }
    }

    // MARK: - custom funcs
    
    private func formatToString(of number: Double) -> String {
        if number > 100000000.0 {
            return String(
                format: "%.1f",
                number / 100000000.0
            ) + "억"
        } else {
            return String.insertComma(value: number)
        }
    }
}

struct CoinInformation {
    let rows: [Row]
    
    struct Row {
        let title: String
        let value: Double
        var color: UIColor
        var type: RowType = .info
        
        static let line: Row = {
            var line = Row(title: "", value: 0.0, color: .lightGray)
            line.type = .line
            return line
        }()
    }

    enum RowType {
        case info, line
    }
}
