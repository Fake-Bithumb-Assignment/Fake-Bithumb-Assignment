//
//  NavigationLogoTitleView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/09.
//

import UIKit

import SnapKit
import Then

class NavigationLogoTitleView: UIView {
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configUI() {
        self.addSubview(logoImageView)
        self.logoImageView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(43)
        }
    }
}
