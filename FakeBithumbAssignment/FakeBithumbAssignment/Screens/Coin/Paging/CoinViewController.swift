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
    
    private let menuCollectionView = UICollectionView(frame: CGRect.zero,
                                                      collectionViewLayout: UICollectionViewFlowLayout.init()).then {
        $0.backgroundColor = .white
        $0.register(cell: CoinMenuCollectionViewCell.self)
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
        setDelegations()
        setPageView()
        patchHeaderViewData()
    }
    
    override func render() {
        view.addSubViews([headerView, menuCollectionView, pageView])
        
        headerView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(90)
        }
        self.menuCollectionView.snp.makeConstraints { (make) in
            make.height.equalTo(35)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func patchHeaderViewData() {
        self.headerView.patchData(data: CoinHeaderModel(currentPrice: 4559400, fluctate: -1578000, fluctateUpDown: "up", fluctateRate: 3.35))
    }
    
    
    // MARK: - custom func
    
    func setDelegations() {
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
    }
    
    func setPageView() {
        pageViewController = CoinPagingViewController()
        
        if let pageViewController = pageViewController {
            addChild(pageViewController)
            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            pageView.addSubview(pageViewController.view)
            pageViewController.didMove(toParent: self)
        }
    }
}
