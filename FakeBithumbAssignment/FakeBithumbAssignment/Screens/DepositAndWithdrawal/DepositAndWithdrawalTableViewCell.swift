//
//  DepositAndWithdrawalTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/05.
//

import UIKit

import Then

class DepositAndWithdrawalTableViewCell: BaseTableViewCell {
    
    // MARK: - Instance Property
    
    var assetsStatus: AssetsStatus? {
        didSet {
            self.configUI()
        }
    }
    private let coinKoreanLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(named: "primaryBlack")
        $0.textAlignment = .left
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
    private let coinEnglishLabel: UILabel = UILabel().then {
        $0.textColor = .gray
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    private let depositStatusLabel: UILabel = UILabel().then {
        $0.textColor = UIColor(named: "primaryBlack")
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
    private let withdrawalStatus: UILabel = UILabel().then {
        $0.textColor = UIColor(named: "primaryBlack")
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
    }
    private var depositStatusAttributedString: NSAttributedString? {
        get {
            guard let assetsStatus = self.assetsStatus else {
                return nil
            }
            return self.getCircleAttatchment(
                of: assetsStatus.depositStatus ? self.normalColor : self.abnormalColor
            )
        }
    }
    private var withdrawalStatusAttributedString: NSAttributedString? {
        get {
            guard let assetsStatus = self.assetsStatus else {
                return nil
            }
            return self.getCircleAttatchment(
                of: assetsStatus.depositStatus ? self.normalColor : self.abnormalColor
            )
        }
    }
    private var depositStatusLabelText: String {
        get {
            guard let assetsStatus = self.assetsStatus else {
                return abnormalText
            }
            return assetsStatus.depositStatus ? normalText : abnormalText
        }
    }
    private var withdrawalStatusLabelText: String {
        get {
            guard let assetsStatus = self.assetsStatus else {
                return abnormalText
            }
            return assetsStatus.withdrawalStatus ? normalText : abnormalText
        }
    }
    private let normalText: String = "정상"
    private let abnormalText: String = "비정상"
    private let normalColor: UIColor = .blue
    private let abnormalColor: UIColor = .red
    private let spaceAttributedString: NSAttributedString = NSAttributedString(string: " ")
    
    // MARK: - custom func
    
    override func render() {
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [
                self.coinKoreanLabel,
                self.coinEnglishLabel,
                self.depositStatusLabel,
                self.withdrawalStatus
            ]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
        }
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.width.equalTo(self.coinKoreanLabel).multipliedBy(11/3.5)
            make.width.equalTo(self.coinEnglishLabel).multipliedBy(11/2.5)
            make.width.equalTo(self.depositStatusLabel).multipliedBy(11/2.5)
            make.width.equalTo(self.withdrawalStatus).multipliedBy(11/2.5)
        }
    }
    
    override func configUI() {
        guard let assetsStatus = self.assetsStatus else {
            return
        }
        coinKoreanLabel.text = assetsStatus.coin.rawValue
        coinEnglishLabel.text = String(describing: assetsStatus.coin)
        let depositStatusString: NSMutableAttributedString = NSMutableAttributedString()
        if let depositStatusAttatchment = self.depositStatusAttributedString {
            depositStatusString.append(depositStatusAttatchment)
            depositStatusString.append(spaceAttributedString)
        }
        depositStatusString.append(NSAttributedString(string: self.depositStatusLabelText))
        depositStatusLabel.attributedText = depositStatusString
        let withdrawalStatusString: NSMutableAttributedString = NSMutableAttributedString()
        if let withdrawalStatusAttatchment = self.withdrawalStatusAttributedString {
            withdrawalStatusString.append(withdrawalStatusAttatchment)
            withdrawalStatusString.append(spaceAttributedString)
        }
        withdrawalStatusString.append(NSAttributedString(string: self.withdrawalStatusLabelText))
        withdrawalStatus.attributedText = withdrawalStatusString
    }
    
    private func getCircleAttatchment(of color: UIColor) -> NSAttributedString? {
        guard let image: UIImage = UIImage(systemName: "circle.fill")?.withTintColor(color)
        else {
            return nil
        }
        let attatchment: NSTextAttachment = NSTextAttachment().then {
            $0.image = image
        }
        return NSAttributedString(attachment: attatchment)
    }
}
