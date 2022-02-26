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
    
    private let informationView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let currentPriceLabel = UILabel().then {
        $0.text = "45,594,000"
        $0.font = UIFont.systemFont(ofSize: 25)
    }
    
    private let fluctateLabel = UILabel().then {
        $0.text = "-1,578,000"
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    private let fluctateImageView = UIImageView().then {
        $0.image = UIImage()
    }
    
    private let fluctateRateLabel = UILabel().then {
        $0.text = "3.35%"
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    private let menuCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .blue
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.className)
        return collectionView
    }()
    
    let pageView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
    }
    
    override func render() {
        view.addSubViews([informationView, menuCollectionView, pageView])
        informationView.addSubViews([currentPriceLabel, fluctateLabel, fluctateImageView, fluctateRateLabel])
        
        informationView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        currentPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(informationView).offset(20)
            make.leading.equalTo(informationView).offset(20)
            make.width.equalTo(150)
        }
        
        fluctateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentPriceLabel.snp.bottom)
            make.leading.equalTo(informationView).offset(20)
        }
        
        fluctateImageView.snp.makeConstraints { (make) in
            make.top.equalTo(currentPriceLabel.snp.bottom)
            make.leading.equalTo(fluctateLabel.snp.trailing).offset(10)
            make.width.height.equalTo(18)
        }
        
        fluctateRateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentPriceLabel.snp.bottom)
            make.leading.equalTo(fluctateImageView.snp.trailing)
        }
        
        menuCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(informationView.snp.bottom).offset(1)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(35)
        }
        
        pageView.snp.makeConstraints { (make) in
            make.top.equalTo(menuCollectionView.snp.bottom).offset(1)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configUI() {
        super.configUI()
        view.backgroundColor = .gray
    }
    
    // MARK: - custom func
    
    // MARK: - @IBOutlets Action
    
    // MARK: - @objc
    
}
