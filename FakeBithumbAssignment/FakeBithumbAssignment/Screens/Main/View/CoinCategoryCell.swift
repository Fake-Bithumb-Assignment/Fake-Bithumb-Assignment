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

    override func render() {
        self.addSubview(categoryLabel)
        self.categoryLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(5)
            make.bottom.equalToSuperview()
        }
    }

    func configure(with model: String) {
        self.categoryLabel.text = model
    }
}
