//
//  MoreModel.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/11.
//

import UIKit

struct MoreModel {
    let characterImage: UIImage
    let name: String
    let mbti: String
    let github: String
    let comment: String
    
    init(characterImage: UIImage, name: String, mbti: String, github: String, comment: String) {
        self.characterImage = characterImage
        self.name = name
        self.mbti = mbti
        self.github = github
        self.comment = comment
    }
}
