//
//  BaseTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render() {
        // 레이아웃 구성 (ex. addSubView, autolayout 코드)
    }
    
    func configUI() {
        // 뷰 configuration (ex. view 색깔, 네비게이션바 설정 ..)
    }
}
