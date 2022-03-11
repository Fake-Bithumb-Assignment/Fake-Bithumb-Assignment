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
        $0.font = .preferredFont(forTextStyle: .headline)
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
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = UIColor.darkGray
    }
    
    
    // MARK: - Life Cycle func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.render()
        self.configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func render() {
        self.addSubViews([characterImageView, nameLabel, mbtiLabel, githubLabel, commentLabel])
        
        self.characterImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.height.equalTo(150)
            make.leading.equalTo(self.snp.leading)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.characterImageView.snp.trailing).offset(15)
            make.top.equalTo(self.characterImageView.snp.top)
        }
        
        self.mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.characterImageView.snp.trailing).offset(15)
        }
        
        self.githubLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mbtiLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.characterImageView.snp.trailing).offset(15)
        }
        
        self.commentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.githubLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.characterImageView.snp.trailing).offset(15)
        }
    }
    
    // MARK: - custom funcs
    
    func patchData(data: MoreModel) {
        self.characterImageView.image = data.characterImage
        self.nameLabel.text = data.name
        self.mbtiLabel.text = data.mbti
        self.githubLabel.text = data.github
        self.commentLabel.text = data.comment
    }
}
