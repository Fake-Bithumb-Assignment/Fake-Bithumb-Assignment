//
//  TotalCoinListView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/02.
//

import UIKit

import SnapKit
import Then

final class TotalCoinListView: UIView {

    // MARK: - Instance Property

    private var dataSource: UITableViewDiffableDataSource<Section, CoinData>?

    private var snapshot = NSDiffableDataSourceSnapshot<Section, CoinData>()

    weak var delegate: CoinDelgate?

    var totalCoinList: [CoinData] = [] {
        didSet {
            configureSnapshot()
        }
    }

    private let totalCoinListTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .clear
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTotalCoinListTableView()
        configurediffableDataSource()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - custom func

    private func configureTotalCoinListTableView() {
        self.addSubview(totalCoinListTableView)
        totalCoinListTableView.delegate = self
        totalCoinListTableView.dataSource = dataSource
        totalCoinListTableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }

    private func setUpInterestedCoinListTableView() {
        totalCoinListTableView.delegate = self
        totalCoinListTableView.dataSource = dataSource
    }

    private func configurediffableDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: totalCoinListTableView)
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

// MARK: - UITableViewDelegate

extension TotalCoinListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
