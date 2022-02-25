//
//  HeaderView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/24.
//

import UIKit

import SnapKit

final class HeaderView: UIView {

    // MARK: - Instance Property

    private let krwButton: UIButton = {
        let button = UIButton()
        button.setTitle("원화", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let favoritesButton: UIButton = {
        let button = UIButton()
        button.setTitle("관심", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "코인명 또는 심볼 검색"
        searchBar.barTintColor = .white
        return searchBar
    }()

    private let categoryView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .white
        return view
    }()

    private let settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("인기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .darkGray
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    private let columnNameView = ColumnNameView()

    // MARK: - Life Cycle func

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - custom func

    private func configUI() {
        configureSettingButton()
        configureStackViews()
        configureKRWButon()
        configureFavoritesButton()
    }

    private func configureStackViews() {
        let horizontalStackView = UIStackView(arrangedSubviews: [
            krwButton,
            favoritesButton,
            settingButton
        ])

        let stackView = UIStackView(arrangedSubviews: [
            self.searchBar,
            horizontalStackView,
            self.columnNameView
        ])

        stackView.axis = .vertical
        stackView.spacing = 10

        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.width.equalTo(self.krwButton).multipliedBy(4)
            make.width.equalTo(self.favoritesButton).multipliedBy(4)
        }
    }

    private func configureSettingButton() {
        settingButton.showsMenuAsPrimaryAction = true
        settingButton.menu = addSettingItems()
    }

    private func addSettingItems() -> UIMenu {
        let favorite = configureAction("인기")
        let name = configureAction("이름")
        let changeRate = configureAction("변동률")
        favorite.state = .on

        let items = UIMenu(
            title: "",
            options: .singleSelection,
            children: [favorite, name, changeRate]
        )

        return items
    }

    private func configureAction(_ title: String) -> UIAction {
        let action = UIAction(title: title) { [weak self] _ in
            self?.settingButton.setTitle(title, for: .normal)
        }

        return action
    }

    private func configureKRWButon() {
        self.krwButton.addTarget(self, action: #selector(tapKRWButton), for: .touchUpInside)
        setBottomBorder(to: self.krwButton)
    }

    private func configureFavoritesButton() {
        self.favoritesButton.addTarget(self, action: #selector(tapFavoritesButton), for: .touchUpInside)
    }
    
    private func setBottomBorder(to button: UIButton) {
        self.indicatorView.removeFromSuperview()
        button.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.leading.width.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
    }

    // MARK: - @objc

    @objc private func tapKRWButton() {
        self.krwButton.setTitleColor(.black, for: .normal)
        self.favoritesButton.setTitleColor(.lightGray, for: .normal)
        setBottomBorder(to: self.krwButton)
    }
    
    @objc private func tapFavoritesButton() {
        self.krwButton.setTitleColor(.lightGray, for: .normal)
        self.favoritesButton.setTitleColor(.black, for: .normal)
        setBottomBorder(to: self.favoritesButton)
    }
}
