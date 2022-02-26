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
    
    private let informationView = UIView()
    private let pageView = UIView()
    
    private let menuCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.className)
        return collectionView
    }()
    
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
    }
    
    override func render() {
        view.addSubViews([currentPriceLabel, fluctateLabel, fluctateImageView, fluctateRateLabel, pageView])
        
        currentPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(150)
        }
        
        fluctateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentPriceLabel.snp.bottom)
            make.leading.equalTo(view).offset(20)
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
    }
    
    override func configUI() {
        super.configUI()
    }
    
    // MARK: - custom func
    
    // MARK: - @IBOutlets Action
    
    // MARK: - @objc
    
}
