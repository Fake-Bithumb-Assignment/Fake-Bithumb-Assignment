//
//  PriceInformationView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/02.
//

import UIKit

import SnapKit
import Then

final class PriceInformationView: UIView {
    
    // MARK: - Life Cycle func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        self.backgroundColor = .blue
    }
    
}

