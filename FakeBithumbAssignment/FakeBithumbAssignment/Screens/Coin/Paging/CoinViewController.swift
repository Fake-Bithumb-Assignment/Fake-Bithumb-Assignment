//
//  CoinViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

final class CoinViewController: BaseViewController {
    
    // MARK: - Instance Property
    
    let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    private let headerView = CoinHeaderView()
    
    let quoteButton = UIButton().then {
        $0.setTitle("호가", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let graphButton = UIButton().then {
        $0.setTitle("차트", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let contractDetailsButton = UIButton().then {
        $0.setTitle("시세", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private let indicatorView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let pageView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var pageViewController: CoinPagingViewController?
    
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        setPageView()
        patchHeaderViewData()
    }
    
    override func render() {
        self.view.addSubViews([headerView, pageView])
        
        self.headerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(90)
        }
        
        self.pageView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.bottom.trailing.equalTo(self.view)
        }
    }
    
    override func configUI() {
        super.configUI()
        self.configStackView()
        self.configMenuButtons()
    }
    
    
    // MARK: - custom func

    private func configStackView() {
        let menuStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.quoteButton, self.graphButton, self.contractDetailsButton]
        ).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 1
        }
        
        self.view.addSubview(menuStackView)
        
        menuStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [self.headerView, menuStackView, self.pageView]
        ).then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.spacing = 1
        }
        
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configMenuButtons() {
        self.graphButton.addTarget(self, action: #selector(self.tapGraphButton), for: .touchUpInside)
        self.setBottomBorder(to: self.graphButton)
        
        self.contractDetailsButton.addTarget(self, action: #selector(self.tapContractDetailsButton), for: .touchUpInside)
        self.setBottomBorder(to: self.contractDetailsButton)
        
        self.quoteButton.addTarget(self, action: #selector(self.tapQuoteButton), for: .touchUpInside)
        self.setBottomBorder(to: self.quoteButton)
    }
    
    private func setPageView() {
        self.pageViewController = CoinPagingViewController()
        
        if let pageViewController = pageViewController {
            self.addChild(pageViewController)
            self.pageView.addSubview(pageViewController.view)
            pageViewController.didMove(toParent: self)
        }
    }
    
    private func setBottomBorder(to button: UIButton) {
        self.indicatorView.removeFromSuperview()
        button.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.leading.width.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
    }
    
    private func patchHeaderViewData() {
        self.headerView.patchData(data: CoinHeaderModel(currentPrice: 4559400,
                                                        fluctate: -1578000,
                                                        fluctateUpDown: "up",
                                                        fluctateRate: 3.35))
    }
    
    
    // MARK: - @objc
    
    @objc private func tapQuoteButton(sender: UIButton) {
        setBottomBorder(to: self.quoteButton)
        pageViewController?.setTabViewController(to: .quote)
    }
    
    @objc private func tapGraphButton() {
        setBottomBorder(to: self.graphButton)
        pageViewController?.setTabViewController(to: .graph)
    }
    
    @objc private func tapContractDetailsButton() {
        setBottomBorder(to: self.contractDetailsButton)
        pageViewController?.setTabViewController(to: .contractDetails)
    }
}
