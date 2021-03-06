//
//  BaseTableViewCell.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.render()
        self.configUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - custom func
    
    func render() {
        // 레이아웃 구성 (ex. addSubView, autolayout 코드)
    }
    
    func configUI() {
        // 뷰 configuration (ex. view 색깔, 네비게이션바 설정 ..)
    }
}
