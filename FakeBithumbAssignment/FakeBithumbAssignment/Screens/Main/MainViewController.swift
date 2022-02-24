//
//  MainViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit

final class MainViewController: BaseViewController {

    private let headerView = HeaderView()

    override func render() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().dividedBy(5)
        }
    }
}
