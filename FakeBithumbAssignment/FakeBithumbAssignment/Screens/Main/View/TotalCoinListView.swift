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

    weak var delegate: CoinDelgate?

    var totalCoinList: [CoinData] = [] {
        didSet {
            self.configurediffableDataSource()
            noInterestedCoinView.isHidden = !totalCoinList.isEmpty
        }
    }

    private let totalCoinListTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .clear
        $0.keyboardDismissMode = .onDrag
        $0.separatorInset = UIEdgeInsets()
    }

    private let noInterestedCoinLabel = UILabel().then {
        $0.text = "등록된 관심 가상자산이 없습니다."
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .darkGray
    }

    private let noInterestedCoinView = UIView().then {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureTotalCoinListTableView()
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

    private func configureTotalCoinListTableView() {
        self.addSubview(totalCoinListTableView)
        totalCoinListTableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }

    private func setUpInterestedCoinListTableView() {
        totalCoinListTableView.delegate = self
    }

    private func configurediffableDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: totalCoinListTableView)
        { tableView, indexPath, coinList in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CoinTableViewCell.className,
                for: indexPath
            ) as? CoinTableViewCell
            
            cell?.configure(with: coinList)
            return cell
        }

        self.totalCoinListTableView.dataSource = dataSource
        configureSnapshot()
    }
    
    func configureSnapshot() {
        guard var snapshot = self.dataSource?.snapshot() else {
            return
        }

        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(totalCoinList)
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

    // MARK: - @objc

    @objc private func sortTableView() {
        configurediffableDataSource()
    }
}

// MARK: - UITableViewDelegate

extension TotalCoinListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

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
