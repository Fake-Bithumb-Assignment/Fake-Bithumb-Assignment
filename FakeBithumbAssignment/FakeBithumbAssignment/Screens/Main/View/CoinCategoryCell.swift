//
//  CoinCategoryCell.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/23.
//

import UIKit

import SnapKit

final class CoinCategoryCell: BaseCollectionViewCell {

    static let identifier = "CoinCategoryCell"

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .lightGray
        return label
    }()

    override var isSelected: Bool {
        didSet {
            self.categoryLabel.textColor = isSelected ? .black : .lightGray
        }
    }

    override func render() {
        self.addSubview(categoryLabel)
        self.categoryLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func configure(with model: String) {
        self.categoryLabel.text = model
    }
}
