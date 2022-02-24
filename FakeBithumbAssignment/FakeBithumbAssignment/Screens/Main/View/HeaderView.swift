//
//  HeaderView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/02/24.
//

import UIKit

import SnapKit

final class HeaderView: UIView {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "코인명 또는 심볼 검색"
        searchBar.barTintColor = .white
        return searchBar
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
    }
    
    private func configureSearchBar() {
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
