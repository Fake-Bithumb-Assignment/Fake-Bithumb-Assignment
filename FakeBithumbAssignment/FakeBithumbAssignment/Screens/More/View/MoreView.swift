//
//  MoreView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/11.
//

import UIKit

import SnapKit
import Then

final class MoreView: UIView {
    
    // MARK: - Instance Property
    
    private let characterImageView: UIImageView = UIImageView()
    private let nameLabel: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = UIColor(named: "primaryBlack")
    }
    private let mbtiLabel: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textColor = UIColor.gray
    }
    private let githubLabel: UILabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textColor = UIColor.gray
    }
    private let commentLabel: UILabel = UILabel().then {
        let matrix: CGAffineTransform = CGAffineTransform(
            a: 1,
            b: 0,
            c: CGFloat(tanf(12 * 3.141592653589793 / 180 )),
            d: 1,
            tx: 0,
            ty: 0
        )
        let descriptor: UIFontDescriptor = UIFontDescriptor.init(
            name: "AppleSDGothicNeo-Regular",
            matrix: matrix
        )
        $0.font = UIFont(descriptor: descriptor, size: 14)
        $0.textColor = .darkGray
        $0.numberOfLines = 0
    }
    
    // MARK: - Life Cycle func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.render()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: custom func
    
    private func render() {
        self.addSubViews(
            [self.characterImageView,
             self.nameLabel,
             self.mbtiLabel,
             self.githubLabel,
             self.commentLabel
            ]
        )
        
        self.characterImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.height.equalTo(150)
            make.leading.equalTo(self.snp.leading)
        }
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.characterImageView.snp.trailing).offset(15)
            make.top.equalTo(self.characterImageView.snp.top)
            make.trailing.equalTo(self.snp.trailing)
        }
        self.mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(3)
            make.leading.equalTo(self.characterImageView.snp.trailing).offset(15)
            make.trailing.equalTo(self.snp.trailing)
        }
        self.githubLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mbtiLabel.snp.bottom).offset(0)
            make.leading.equalTo(self.characterImageView.snp.trailing).offset(15)
            make.trailing.equalTo(self.snp.trailing)
        }
        self.commentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.githubLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.characterImageView.snp.trailing).offset(15)
            make.trailing.equalTo(self.snp.trailing).inset(10)
        }
    }
        
    func patchData(data: MoreModel) {
        self.characterImageView.image = data.characterImage
        self.nameLabel.text = data.name
        self.mbtiLabel.text = data.mbti
        self.githubLabel.text = data.github
        self.commentLabel.text = data.comment
    }
}
