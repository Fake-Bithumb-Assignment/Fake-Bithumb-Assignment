//
//  CoinQuoteInformationTabViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

class CoinQuoteInformationTabViewController: BaseViewController {
    
    // MARK: - Instance Property
    
    let labelOne = UILabel().then { make in
        make.text = "Scroll Top"
        make.backgroundColor = .red
    }
    
    let labelTwo = UILabel().then { make in
        make.text = "Scroll Top"
        make.backgroundColor = .green
    }
    
    let scrollView = UIScrollView().then { make in
        make.backgroundColor = .cyan
    }
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    override func render() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self.view)
        }
        
        self.scrollView.addSubview(self.labelOne)
        
        self.labelOne.snp.makeConstraints { make in
            make.leading.top.equalTo(self.scrollView).offset(16)
            
        }
        
        self.scrollView.addSubview(self.labelTwo)
        
        self.labelTwo.snp.makeConstraints { make in
            make.leading.equalTo(self.scrollView).offset(200)
            make.top.equalTo(self.scrollView).offset(1000)
            make.trailing.bottom.equalTo(self.scrollView).inset(16)
        }
    }
    
    override func configUI() {
        
    }
}
