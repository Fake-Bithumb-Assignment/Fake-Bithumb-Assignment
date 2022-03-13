//
//  DepositAndWithWithdrawalTableHeaderView.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/05.
//

import UIKit

final class DepositAndWithWithdrawalTableHeaderView: UIView {
    
    // MARK: - Instance Property
    
    private let coinKoreanColumnLabel: UILabel = UILabel().then {
        $0.text = "자산"
        $0.textColor = .darkGray
        $0.textAlignment = .left
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    private let emptyView: UIView = UIView()
    private let depositStatusColumnLabel: UILabel = UILabel().then {
        $0.text = "입금"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    private let withdrawalColumnStatus: UILabel = UILabel().then {
        $0.text = "출금"
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    // MARK: - Life Cycle func
    
    override func layoutSubviews() {
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [
                coinKoreanColumnLabel,
                emptyView,
                depositStatusColumnLabel,
                withdrawalColumnStatus
            ]
        )
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.width.equalTo(self.coinKoreanColumnLabel).multipliedBy(11/3.5)
            make.width.equalTo(self.emptyView).multipliedBy(11/2.5)
            make.width.equalTo(self.depositStatusColumnLabel).multipliedBy(11/2.5)
            make.width.equalTo(self.withdrawalColumnStatus).multipliedBy(11/2.5)
        }
    }
}
