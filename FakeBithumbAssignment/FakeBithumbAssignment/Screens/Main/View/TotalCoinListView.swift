//
//  KRWView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/02.
//

import UIKit

import SnapKit
import Then

protocol KRWViewDelegate: AnyObject {
    func updateInterestList(coin: CoinData)
    func showCoinInformation(coin: CoinData)
}

final class KRWView: UIView {

    private var dataSource: UITableViewDiffableDataSource<Section, CoinData>?

    private var snapshot = NSDiffableDataSourceSnapshot<Section, CoinData>()

    weak var delegate: KRWViewDelegate?

    var totalCoinList: [CoinData] = [] {
        didSet {
            print("didset")
            configureSnapshot()
        }
    }

    private let krwTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .red
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureKRWTable()
        configurediffableDataSource()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureKRWTable() {
        self.addSubview(krwTableView)
        krwTableView.delegate = self
        krwTableView.dataSource = dataSource
        krwTableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    private func configurediffableDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: krwTableView)
        { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CoinTableViewCell.className,
                for: indexPath
            ) as? CoinTableViewCell
            
            cell?.configure(with: self.totalCoinList[indexPath.row])
            return cell
        }

        configureSnapshot()
    }
    
    private func configureSnapshot() {
        self.snapshot.deleteAllItems()
        self.snapshot.appendSections([.main])
        self.snapshot.appendItems(totalCoinList)
        self.dataSource?.apply(self.snapshot)
    }
}

extension KRWView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.showCoinInformation(coin: totalCoinList[indexPath.row])
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let interest = UIContextualAction(
            style: .normal,
            title: nil
        ) { _, _, completion in
            self.delegate?.updateInterestList(coin: self.totalCoinList[indexPath.row])
            completion(true)
        }
        
        if self.totalCoinList[indexPath.row].isInterested {
            interest.image = UIImage(named: "Interested")
        }
        else {
            interest.image = UIImage(named: "Interest")
        }

        return UISwipeActionsConfiguration(actions: [interest])
    }
}
