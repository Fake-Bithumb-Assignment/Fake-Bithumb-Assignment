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

    private let krwCoinListButton = UIButton()

    private let InterestCoinListButton = UIButton()

    private let searchView = SearchView()

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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
            self.searchView,
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
            make.width.equalTo(self.krwCoinListButton).multipliedBy(4)
            make.width.equalTo(self.InterestCoinListButton).multipliedBy(4)
        }
    }

    private func configureSubStackView() -> UIStackView {
        let emptyView = UIView()

        let stackView = UIStackView(arrangedSubviews: [
            self.krwCoinListButton,
            self.InterestCoinListButton,
            emptyView,
            self.settingButton
        ]).then {
            $0.alignment = .center
        }

        self.krwCoinListButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.InterestCoinListButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
        self.krwCoinListButton.configuration = setConfiguration(.tinted(), image: "won", title: "원화")
        self.krwCoinListButton.addTarget(self, action: #selector(tapKRWButton), for: .touchUpInside)
        setBottomBorder(to: self.krwCoinListButton)
    }

    private func configureFavoritesButton() {
        self.InterestCoinListButton.configuration = setConfiguration(.gray(), image: "star", title: "관심")
        self.InterestCoinListButton.addTarget(
            self,
            action: #selector(tapFavoritesButton),
            for: .touchUpInside
        )
    }
    
    private func setBottomBorder(to button: UIButton) {
        self.indicatorView.removeFromSuperview()
        button.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.leading.width.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
    }

    private func setConfiguration(
        _ config: UIButton.Configuration,
        image: String,
        title: String
    ) -> UIButton.Configuration {
        var config = config
        config.image = UIImage(named: image)
        config.title = title
        config.imagePlacement = .trailing
        config.imagePadding = 10
        config.buttonSize = .small
        config.cornerStyle = .small
        return config
    }

    // MARK: - @objc

    @objc private func tapKRWButton() {
        setBottomBorder(to: self.krwCoinListButton)
        self.krwCoinListButton.configuration = setConfiguration(.tinted(), image: "won", title: "원화")
        self.InterestCoinListButton.configuration = setConfiguration(.gray(), image: "star", title: "관심")
        delegate?.selectCategory(.krw)
    }

    @objc private func tapFavoritesButton() {
        self.krwCoinListButton.configuration = setConfiguration(.gray(), image: "won", title: "원화")
        self.InterestCoinListButton.configuration = setConfiguration(.tinted(), image: "star", title: "관심")
        setBottomBorder(to: self.InterestCoinListButton)
        delegate?.selectCategory(.interest)
    }
}
