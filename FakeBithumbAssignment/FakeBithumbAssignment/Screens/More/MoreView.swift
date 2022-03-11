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
    
    private let characterImageView = UIImageView()
    
    private let nameLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .title3)
        $0.textColor = UIColor(named: "primaryBlack")
    }
    
    private let mbtiLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textColor = UIColor.gray
    }
    
    private let githubLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textColor = UIColor.gray
    }
    
    private let commentLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .callout)
        $0.textColor = UIColor.gray
    }
    
    
    // MARK: - Life Cycle func
    
    func render() {
        self.addSubViews([characterImageView, nameLabel, mbtiLabel, githubLabel, commentLabel])
        
        self.characterImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.height.equalTo(100)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.characterImageView).offset(20)
        }
        
        self.mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.bottom).offset(5)
            make.leading.equalTo(self.characterImageView).offset(20)
        }
        
        self.githubLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mbtiLabel.bottom).offset(5)
            make.leading.equalTo(self.characterImageView).offset(20)
        }
        
        self.commentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.githubLabel.bottom).offset(10)
            make.leading.equalTo(self.characterImageView).offset(20)
        }
    }
    
    func configUI() {
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(named: "bithumbColor")?.cgColor
    }
}
