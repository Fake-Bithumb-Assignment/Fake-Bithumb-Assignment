//
//  DepositAndWithdrawalViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

class DepositAndWithdrawalViewController: BaseViewController {
    
    private let btAssetsStatusAPIService: BTAssetsStatusAPIService = BTAssetsStatusAPIService()
    private let searchBar: UISearchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
    }
    private let headerView: DepositAndWithWithdrawalTableHeaderView = DepositAndWithWithdrawalTableHeaderView()
    private let tableView: UITableView = UITableView().then {
        $0.register(
            DepositAndWithdrawalTableViewCell.self,
            forCellReuseIdentifier: DepositAndWithdrawalTableViewCell.className
        )
    }
    lazy var dataSource: UITableViewDiffableDataSource<AssetsStatusSection, AssetsStatus> = configureDataSource()
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetData()
    }
    
    // MARK: - custom func
    
    override func render() {
        let lineView: UIView = UIView().then {
            $0.backgroundColor = self.tableView.separatorColor
            $0.snp.makeConstraints { make in
                make.height.equalTo(1 / UIScreen.main.scale)
            }
        }
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [self.searchBar, self.headerView, lineView, self.tableView]
        ).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        self.headerView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(
                UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            )
        }
    }
    
    override func configUI() {
        self.view.backgroundColor = .white
        self.searchBar.placeholder = "검색"
        self.tableView.rowHeight = 50
        self.tableView.delegate = self
        self.tableView.separatorInset = UIEdgeInsets()
    }
}

// MARK: - Table view

extension DepositAndWithdrawalViewController {
    private func configureDataSource() -> UITableViewDiffableDataSource<AssetsStatusSection, AssetsStatus> {
        let dataSource = UITableViewDiffableDataSource<AssetsStatusSection, AssetsStatus>(
            tableView: self.tableView
        ) {  tableView, indexPath, assetsStatus in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DepositAndWithdrawalTableViewCell.className,
                for: indexPath
            ) as? DepositAndWithdrawalTableViewCell
            cell?.assetsStatus = assetsStatus
            return cell
        }
        var snapshot = NSDiffableDataSourceSnapshot<AssetsStatusSection, AssetsStatus>()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
        return dataSource
    }
    
    private func fetchData() {
        Coin.allCases.forEach { coin in
            Task {
                guard let response: BTAssetsStatusResponse = await btAssetsStatusAPIService.requestAssetsStatus(
                    of: coin
                ) else {
                    return
                }
                let depositStatus: Bool = response.depositStatus == 1
                let withdrawalStatus: Bool = response.withdrawalStatus == 1
                let assetsStatus: AssetsStatus = AssetsStatus(
                    coin: coin,
                    depositStatus: depositStatus,
                    withdrawalStatus: withdrawalStatus
                )
                var currentSnapshot = self.dataSource.snapshot()
                currentSnapshot.deleteItems([assetsStatus])
                currentSnapshot.appendItems([assetsStatus], toSection: .main)
                await self.dataSource.apply(currentSnapshot)
            }
        }
    }
    
    private func resetData() {
        var currentSnapshot = self.dataSource.snapshot()
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([.main])
        self.dataSource.apply(currentSnapshot)
    }
}

extension DepositAndWithdrawalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

enum AssetsStatusSection {
    case main
}

struct AssetsStatus: Hashable {
    let coin: Coin
    let depositStatus: Bool
    let withdrawalStatus: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coin)
    }
    static func == (lhs: AssetsStatus, rhs: AssetsStatus) -> Bool {
        return lhs.coin == rhs.coin
    }
}
