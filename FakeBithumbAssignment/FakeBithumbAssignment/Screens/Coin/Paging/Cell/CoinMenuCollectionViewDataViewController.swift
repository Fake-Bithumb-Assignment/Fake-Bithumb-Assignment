//
//  CoinMenCollectionViewDataViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/26.
//

import UIKit

extension CoinViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CoinMenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        switch indexPath.row {
        case 0:
            cell.update(to: .quoteInformation)
            collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
            cell.isSelected = true
        case 1:
            cell.update(to: .graph)
        case 2:
            cell.update(to: .contractDetails)
        default:
            cell.update(to: .quoteInformation)
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


