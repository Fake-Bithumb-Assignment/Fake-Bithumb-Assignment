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
    func sorted(by sortOption: SortOption)
}

final class HeaderView: UIView {
    
    // MARK: - Instance Property
    
    weak var delegate: HeaderViewDelegate?
    
    private let krwCoinListButton = UIButton()
    
    private let interestCoinListButton = UIButton()
    
    private var searchBarBorderLayer: CALayer?
    
    let searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "코인명 또는 심볼 검색"
    }
    
    private let settingButton = UIButton().then {
        var configuration  = UIButton.Configuration.plain()
        configuration.buttonSize = .small
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.imagePlacement = .trailing
        configuration.baseForegroundColor = .gray
        configuration.imagePadding = 5
        
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.darkGray
        var attributedText = AttributedString.init(SortOption.sortedBypopular.rawValue, attributes: attributes)
        attributedText.font = .preferredFont(forTextStyle: .footnote)
        configuration.attributedTitle = attributedText
        
        $0.configuration = configuration
        $0.setTitleColor(UIColor.darkGray, for: .normal)
    }
    
    private let indicatorView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let columnNameView = ColumnNameView()
    
    private let bottomBorderView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        configureSearchBar()
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
            subStackview,
            self.columnNameView,
            self.bottomBorderView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
        }
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        self.bottomBorderView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    private func configureSubStackView() -> UIStackView {
        let emptyView = UIView()
        emptyView.backgroundColor = .red
        
        let stackView = UIStackView(arrangedSubviews: [
            self.krwCoinListButton,
            self.interestCoinListButton,
            UIView(),
            UIView(),
            UIView(),
            self.settingButton
        ]).then {
            $0.alignment = .center
            $0.distribution = .fill
        }
        
        return stackView
    }
    
    private func configureSettingButton() {
        settingButton.showsMenuAsPrimaryAction = true
        settingButton.menu = addSettingItems()
    }
    
    private func configureSearchBar() {
        if let textField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .clear
            textField.borderStyle = .none
            let attributedString = NSAttributedString(string: "코인명 또는 심볼 검색",
                                                      attributes: [.foregroundColor : UIColor.gray,
                                                                   .font : UIFont.systemFont(ofSize: 15)])
            textField.attributedPlaceholder = attributedString
            
            if let border = searchBarBorderLayer {
                border.frame = CGRect(x: 0, y: textField.frame.size.height, width: textField.frame.width, height: 1)
                border.backgroundColor = UIColor.darkGray.cgColor
                border.masksToBounds = true
                textField.layer.addSublayer(border)
            }
        }
    }
    
    private func addSettingItems() -> UIMenu {
        let popular = configureAction(.sortedBypopular)
        let name = configureAction(.sortedByName)
        let changeRate = configureAction(.sortedByChangeRate)
        popular.state = .on
        
        let items = UIMenu(
            title: "",
            options: .singleSelection,
            children: [popular, name, changeRate]
        )
        
        return items
    }
    
    private func configureAction(_ option: SortOption) -> UIAction {
        let action = UIAction(title: option.rawValue) { _ in
            var configuration  = UIButton.Configuration.plain()
            configuration.buttonSize = .small
            configuration.image = UIImage(systemName: "chevron.down")
            configuration.imagePlacement = .trailing
            configuration.baseForegroundColor = .gray
            configuration.imagePadding = 5
            
            var attributes = AttributeContainer()
            attributes.foregroundColor = UIColor.darkGray
            var attributedText = AttributedString.init(option.rawValue, attributes: attributes)
            attributedText.font = .preferredFont(forTextStyle: .footnote)
            configuration.attributedTitle = attributedText
            
            self.settingButton.configuration = configuration
            self.settingButton.setTitleColor(UIColor.darkGray, for: .normal)

            self.delegate?.sorted(by: option)
        }
        
        return action
    }
    
    private func configureKRWButon() {
        var configuration  = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.black
        var attributedText = AttributedString.init("원화", attributes: attributes)
        attributedText.font = .preferredFont(forTextStyle: .headline)
        configuration.attributedTitle = attributedText
        
        self.krwCoinListButton.configuration = configuration
        self.krwCoinListButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.krwCoinListButton.addTarget(
            self,
            action: #selector(tapKRWButton),
            for: .touchUpInside
        )
        setBottomBorder(to: self.krwCoinListButton)
    }
    
    private func configureFavoritesButton() {
        var configuration  = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.black
        var attributedText = AttributedString.init("관심", attributes: attributes)
        attributedText.font = .preferredFont(forTextStyle: .headline)
        configuration.attributedTitle = attributedText
        
        self.interestCoinListButton.configuration = configuration
        self.interestCoinListButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.interestCoinListButton.addTarget(
            self,
            action: #selector(tapFavoritesButton),
            for: .touchUpInside
        )
    }
    
    private func setBottomBorder(to button: UIButton) {
        self.indicatorView.removeFromSuperview()
        button.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(7)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(2)
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
        
        var configuration  = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.black
        var attributedText = AttributedString.init("원화", attributes: attributes)
        attributedText.font = .preferredFont(forTextStyle: .headline)
        configuration.attributedTitle = attributedText
        
        self.krwCoinListButton.configuration = configuration
        self.krwCoinListButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        delegate?.selectCategory(.krw)
    }
    
    @objc private func tapFavoritesButton() {
        var configuration  = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        
        var attributes = AttributeContainer()
        attributes.foregroundColor = UIColor.black
        var attributedText = AttributedString.init("관심", attributes: attributes)
        attributedText.font = .preferredFont(forTextStyle: .headline)
        configuration.attributedTitle = attributedText
        
        self.interestCoinListButton.configuration = configuration
        self.interestCoinListButton.setTitleColor(UIColor.darkGray, for: .normal)

        setBottomBorder(to: self.interestCoinListButton)
        delegate?.selectCategory(.interest)
    }
}

