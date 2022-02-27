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
    
    private let menuCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .white
        collectionView.register(cell: CoinMenuCollectionViewCell.self)
        return collectionView
    }()
    
    private let pageView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        setDelegations()
    }
    
    override func render() {
        view.addSubViews([headerView, menuCollectionView, pageView])
       
        headerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(90)
        }
        
        menuCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(1)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(35)
        }
        
        pageView.snp.makeConstraints { make in
            make.top.equalTo(menuCollectionView.snp.bottom).offset(1)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configUI() {
        super.configUI()
    }
    
    
    // MARK: - custom func
    
    private func setDelegations() {
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
    }
}
