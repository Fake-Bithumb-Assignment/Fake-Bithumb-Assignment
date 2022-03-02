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
        make.backgroundColor = .white
    }
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
    }
    
    override func render() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(self.view)
        }
    }
    
    override func configUI() {
        configStackView()
    }
    
    func configStackView() {
        let leftStackView = UIStackView(arrangedSubviews: [
            SellGraphTableViewController().view,
            ConclusionTableViewController().view
        ]).then {
            $0.axis = .vertical
            $0.spacing = 1
            $0.distribution = .fillEqually
        }
        
        leftStackView.snp.makeConstraints { make in
        }
        
        let rightStackView = UIStackView(arrangedSubviews: [
            PriceInformationTableViewController().view,
            BuyGraphTableViewController().view
        ]).then {
            $0.axis = .vertical
            $0.spacing = 1
            $0.distribution = .fillEqually
        }
        
        let wholeStackView = UIStackView(arrangedSubviews: [
            leftStackView,
            QuoteTableViewController().view,
            rightStackView
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 1
            $0.distribution = .fillEqually
        }
        
        scrollView.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(self.scrollView.safeAreaLayoutGuide)
        }
    }
}
