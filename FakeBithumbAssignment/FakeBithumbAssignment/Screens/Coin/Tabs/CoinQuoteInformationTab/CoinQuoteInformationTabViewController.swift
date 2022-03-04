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
    
    let sellGraphTableViewController = SellGraphTableViewController()
    let buyGraphTableViewController = BuyGraphTableViewController()
    let quoteTableViewController = QuoteTableViewController()
    let coinFirstInformationView = CoinFirstInformationView()
    let coinSecondInformationView = CoinSecondInformationView()
    
    let scrollView = UIScrollView().then { make in
        make.backgroundColor = .white
    }
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.scrollToCenter()
    }
    
    override func render() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configUI() {
        configStackView()
    }
    
    func configStackView() {
        let leftStackView = UIStackView(arrangedSubviews: [
            sellGraphTableViewController.view,
            coinSecondInformationView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 1
            $0.distribution = .fillEqually
        }
        
        let rightStackView = UIStackView(arrangedSubviews: [
            coinFirstInformationView,
            buyGraphTableViewController.view
        ]).then {
            $0.axis = .vertical
            $0.spacing = 1
            $0.distribution = .fillEqually
        }
        
        let wholeStackView = UIStackView(arrangedSubviews: [
            leftStackView,
            quoteTableViewController.view,
            rightStackView
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 1
        }
        
        self.scrollView.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
            make.height.equalTo(2100)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.width.equalTo(wholeStackView).multipliedBy(0.35)
        }
        
        rightStackView.snp.makeConstraints { make in
            make.width.equalTo(wholeStackView).multipliedBy(0.33)
        }
    }
}
