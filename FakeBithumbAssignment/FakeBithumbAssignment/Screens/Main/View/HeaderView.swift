//
//  HeaderView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/24.
//

import UIKit

import SnapKit

final class HeaderView: UIView {
    private let categoryLabels = ["원화", "관심"]

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureSearchBar()
        configureCategories()
        configureSettingButton()
    }

    private func configureSearchBar() {
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide)
        }
    }

    private func configureCategories() {
        self.addSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().multipliedBy(0.7)
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
        setUpCategories()
    }

    private func setUpCategories() {
        categoryView.delegate = self
        categoryView.dataSource = self
        categoryView.register(
            CoinCategoryCell.self,
            forCellWithReuseIdentifier: CoinCategoryCell.identifier
        )

        let indexPath = IndexPath(item: 0, section: 0)
        categoryView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }

    private func configureSettingButton() {
        self.addSubview(settingButton)
        settingButton.showsMenuAsPrimaryAction = true
        settingButton.menu = addSettingItems()

        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(categoryView)
            make.trailing.equalToSuperview().offset(-10)
        }
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
}

extension HeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HeaderView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return categoryLabels.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CoinCategoryCell.identifier,
            for: indexPath
        ) as? CoinCategoryCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: categoryLabels[indexPath.row])
        return cell
    }
}

extension HeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let size = categoryView.frame.size.height / 2
        let topBottomInsets = (categoryView.frame.size.height - size ) / 2
        return UIEdgeInsets(top: topBottomInsets, left: 10, bottom: topBottomInsets, right: 10)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = categoryView.frame.size.height / 2
        return CGSize(width: size, height: size)
    }
}
