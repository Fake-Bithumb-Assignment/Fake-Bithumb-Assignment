//
//  HeaderView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/24.
//

import UIKit

import SnapKit
import Then

// MARK: - HeaderViewDelegateProtocol

protocol HeaderViewDelegate: AnyObject {
    func selectCategory(_ category: Category)
}

final class HeaderView: UIView {

    // MARK: - Instance Property

    weak var delegate: HeaderViewDelegate?

    private let krwButton = UIButton().then {
        $0.setTitle("원화", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    private let favoritesButton = UIButton().then {
        $0.setTitle("관심", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
    }
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "코인명 또는 심볼 검색"
        $0.barTintColor = .white
    }

    private let settingButton = UIButton().then {
        $0.setTitle("인기", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = .darkGray
        $0.semanticContentAttribute = .forceRightToLeft
    }
    
    private let indicatorView = UIView().then {
        $0.backgroundColor = .black
    }

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
        let subStackview = configureSubStackView()

        let stackView = UIStackView(arrangedSubviews: [
            self.searchBar,
            subStackview,
            self.columnNameView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
        }

        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }

        subStackview.snp.makeConstraints { make in
            make.width.equalTo(self.krwButton).multipliedBy(4)
            make.width.equalTo(self.favoritesButton).multipliedBy(4)
        }
    }

    private func configureSubStackView() -> UIStackView {
        let emptyView = UIView()

        let stackView = UIStackView(arrangedSubviews: [
            self.krwButton,
            self.favoritesButton,
            emptyView,
            self.settingButton
        ]).then {
            $0.alignment = .center
        }

        self.krwButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.favoritesButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.settingButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        emptyView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return stackView
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
        delegate?.selectCategory(.krw)
    }
    
    @objc private func tapFavoritesButton() {
        self.krwButton.setTitleColor(.lightGray, for: .normal)
        self.favoritesButton.setTitleColor(.black, for: .normal)
        setBottomBorder(to: self.favoritesButton)
        delegate?.selectCategory(.interest)
    }
}
