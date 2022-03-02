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

    private var snapshot = NSDiffableDataSourceSnapshot<Section, CoinData>()

    weak var delegate: CoinDelgate?

    private let noInterestedCoinView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }

    private let noInterestedCoinLabel = UILabel().then {
        $0.text = "등록된 관심 가상자산이 없습니다."
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .darkGray
    }
    
    var interestedCoinList: [CoinData] = [] {
        didSet {
            noInterestedCoinView.isHidden = !interestedCoinList.isEmpty
            configureSnapshot()
        }
    }

    private let interestedCoinListTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .white
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTotalCoinListTableView()
        configurediffableDataSource()
        configureNoInterestedCoinView()
        setUpInterestedCoinListTableView()
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
        self.addSubview(interestedCoinListTableView)
        interestedCoinListTableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    private func setUpInterestedCoinListTableView() {
        interestedCoinListTableView.delegate = self
        interestedCoinListTableView.dataSource = dataSource
    }

    private func configurediffableDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: interestedCoinListTableView)
        { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CoinTableViewCell.className,
                for: indexPath
            ) as? CoinTableViewCell
            
            cell?.configure(with: self.interestedCoinList[indexPath.row])
            return cell
        }

        configureSnapshot()
    }

    private func configureSnapshot() {
        self.snapshot.deleteAllItems()
        self.snapshot.appendSections([.main])
        self.snapshot.appendItems(interestedCoinList)
        self.dataSource?.apply(self.snapshot)
    }
}

// MARK: - UITableViewDelegate

extension InterestedCoinListView: UITableViewDelegate {
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
