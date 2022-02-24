//
//  CoinCategoryCell.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/23.
//

import UIKit

import SnapKit

final class CoinCategoryCell: BaseCollectionViewCell {

    // MARK: - Instance Property

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .lightGray
        return label
    }()

    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()

    override var isSelected: Bool {
        didSet {
            self.categoryLabel.textColor = isSelected ? .black : .lightGray
            self.indicatorView.isHidden = isSelected ? false : true
        }
    }

    // MARK: - custom func

    override func render() {
        self.addSubViews([categoryLabel, indicatorView])

        categoryLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        indicatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(5)
            $0.bottom.equalToSuperview()
        }
    }

    func configureCategoryLabel(with model: String) {
        categoryLabel.text = model
    }
}
