//
//  NavigationLogoTitleView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/09.
//

import UIKit

import SnapKit
import Then

final class NavigationLogoTitleView: UIView {

    // MARK: - Instance Property

    private let logoImageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - custom func

    private func configUI() {
        self.addSubview(logoImageView)
        self.logoImageView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(43)
        }
    }
}
