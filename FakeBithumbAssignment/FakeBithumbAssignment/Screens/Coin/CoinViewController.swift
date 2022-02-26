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
        $0.image = UIImage(named: "up")
    }
    
    private let fluctateRateLabel = UILabel().then {
        $0.text = "3.35%"
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    private let menuCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .white
        collectionView.register(CoinMenuCollectionViewCell.self, forCellWithReuseIdentifier: CoinMenuCollectionViewCell.className)
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
        setDelegations()
    }
    
    override func render() {
        view.addSubViews([informationView, menuCollectionView, pageView])
        informationView.addSubViews([currentPriceLabel, fluctateLabel, fluctateImageView, fluctateRateLabel])
        
        informationView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(90)
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
            make.centerY.equalTo(fluctateLabel)
            make.leading.equalTo(fluctateLabel.snp.trailing).offset(10)
            make.width.height.equalTo(10)
        }
        
        fluctateRateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentPriceLabel.snp.bottom)
            make.leading.equalTo(fluctateImageView.snp.trailing).offset(2)
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
    
    func setDelegations() {
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
    }
    
    // MARK: - @IBOutlets Action
    
    // MARK: - @objc
    
}

extension CoinViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CoinMenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinMenuCollectionViewCell.className, for: indexPath) as! CoinMenuCollectionViewCell
        switch indexPath.row {
        case 0:
            cell.update(type: .quoteInformation)
            collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
            cell.isSelected = true
        case 1:
            cell.update(type: .graph)
        case 2:
            cell.update(type: .contractDetails)
        default:
            cell.update(type: .quoteInformation)
        }
        return cell
    }
}

extension CoinViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
                let height = collectionView.frame.height
                let itemsPerRow: CGFloat = 3
                let widthPadding = sectionInsets.left * (itemsPerRow + 1)
                let itemsPerColumn: CGFloat = 1
                let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
                let cellWidth = (width - widthPadding) / itemsPerRow
                let cellHeight = (height - heightPadding) / itemsPerColumn
                
                return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension CoinViewController: UICollectionViewDelegateFlowLayout {
}
