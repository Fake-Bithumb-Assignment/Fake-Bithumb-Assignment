//
//  InterestedCoinListView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/03.
//

import UIKit

import SnapKit
import Then

final class InterestedCoinListView: UIView {

    // MARK: - Instance Property

    private var dataSource: UITableViewDiffableDataSource<Section, CoinData>?

    weak var delegate: CoinDelgate?

    private let noInterestedCoinView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }

    private let noInterestedCoinLabel = UILabel().then {
        $0.text = "등록된 관심 가상자산이 없습니다."
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .darkGray
    }
    
    var interestedCoinList: [CoinData] = [] {
        didSet {
            self.configurediffableDataSource()
            noInterestedCoinView.isHidden = !interestedCoinList.isEmpty
        }
    }

    private let interestedCoinListTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .clear
        $0.keyboardDismissMode = .onDrag
        $0.separatorInset = UIEdgeInsets()
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureInterestedCoinListTableView()
        self.configureNoInterestedCoinView()
        self.configureNotificationCenter()
        self.setUpInterestedCoinListTableView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - custom func

    private func configureNoInterestedCoinView() {
        noInterestedCoinView.addSubview(noInterestedCoinLabel)
        noInterestedCoinLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.addSubview(noInterestedCoinView)
        noInterestedCoinView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    private func configureInterestedCoinListTableView() {
        self.addSubview(interestedCoinListTableView)
        interestedCoinListTableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    private func setUpInterestedCoinListTableView() {
        interestedCoinListTableView.delegate = self
    }

    private func configurediffableDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: interestedCoinListTableView)
        { tableView, indexPath, coinList in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CoinTableViewCell.className,
                for: indexPath
            ) as? CoinTableViewCell
            
            cell?.configure(with: coinList)
            return cell
        }

        self.interestedCoinListTableView.dataSource = dataSource
        configureSnapshot()
    }

    func configureSnapshot() {
        guard var snapshot = self.dataSource?.snapshot() else {
            return
        }

        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(interestedCoinList)
        self.dataSource?.apply(snapshot)
    }
    
    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sortTableView),
            name: .updateTableView,
            object: nil
        )
    }
    
    func updateSnapshot(of coin: CoinData) {
        guard var snapshot = self.dataSource?.snapshot() else {
            return
        }

        snapshot.reconfigureItems([coin])
        self.dataSource?.apply(snapshot)
    }
    
    func insertNewInterestedCoin(_ coin: CoinData) {
        guard var snapshot = self.dataSource?.snapshot() else {
            return
        }

        snapshot.appendItems([coin])
        self.dataSource?.apply(snapshot)
    }
    
    func deleteInterestedCoin(_ coin: CoinData) {
        guard var snapshot = self.dataSource?.snapshot() else {
            return
        }

        snapshot.deleteItems([coin])
        self.dataSource?.apply(snapshot)
    }

    // MARK: - @objc

    @objc private func sortTableView() {
        configurediffableDataSource()
    }
}

// MARK: - UITableViewDelegate

extension InterestedCoinListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let interest = UIContextualAction(
            style: .normal,
            title: nil
        ) { _, _, completion in
            self.delegate?.updateInterestList(coin: self.interestedCoinList[indexPath.row])
            completion(true)
        }

        interest.image = UIImage(named: "Interested")

        return UISwipeActionsConfiguration(actions: [interest])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.showCoinInformation(coin: self.interestedCoinList[indexPath.row])
    }
}
