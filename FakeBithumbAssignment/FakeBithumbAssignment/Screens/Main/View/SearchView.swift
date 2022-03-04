//
//  SearchView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/03.
//

import UIKit

import SnapKit
import Then

class SearchView: UIView {

    let searchfield = UITextField().then {
        let placeholder = NSMutableAttributedString(string: "코인명 또는 심볼 검색")
        placeholder.addAttribute(
            .foregroundColor,
            value: UIColor.systemGray2,
            range: NSRange(0...11)
        )
        $0.attributedPlaceholder = placeholder
        $0.textColor = UIColor(named: "deep_gray")
    }

    private let searchButton = UIButton().then {
        $0.setImage(UIImage(named: "search"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }

    private let buttonSize: CGFloat = 30

    private let spaceForTopBottom: CGFloat = 8

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [
            self.searchfield,
            self.searchButton
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 10
        }

        stackView.setRoundedRectangle()
        stackView.backgroundColor = UIColor(named: "pale_gray")
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(spaceForTopBottom)
            make.leading.trailing.equalToSuperview().inset(spaceForTopBottom * 2)
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
        }
    }
}
