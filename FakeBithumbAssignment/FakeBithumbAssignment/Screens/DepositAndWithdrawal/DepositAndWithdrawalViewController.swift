//
//  DepositAndWithdrawalViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

class DepositAndWithdrawalViewController: BaseViewController {
    
    private let btAssetsStatusAPIService: BTAssetsStatusAPIService = BTAssetsStatusAPIService()
    private let headerView: UIView = UIView()
    private let tableView: UITableView = UITableView().then {
        $0.register(
            DepositAndWithdrawalTableViewCell.self,
            forCellReuseIdentifier: DepositAndWithdrawalTableViewCell.className
        )
    }
    lazy var dataSource: UITableViewDiffableDataSource<AssetsStatusSection, AssetsStatus> = configureDataSource()
    private var assetsStatuses: [AssetsStatus] = []
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchInitialData()
        self.tableView.dataSource = self.dataSource
    }
    
    // MARK: - custom func
    
    override func render() {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [self.headerView, self.tableView]).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        self.view.addSubview(stackView)
        self.headerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(
                UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            )
        }
    }
    
    override func configUI() {
        self.view.backgroundColor = .white
        headerView.backgroundColor = .red
        self.tableView.rowHeight = 50
        self.tableView.delegate = self
        self.tableView.separatorInset = UIEdgeInsets()
    }
    
    
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
        snapshot.appendItems(self.assetsStatuses, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
        return dataSource
    }
    
    private func fetchInitialData() {
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
                self.assetsStatuses.append(assetsStatus)
                DispatchQueue.main.async {
                    var currentSnapshot = self.dataSource.snapshot()
                    currentSnapshot.appendItems([assetsStatus], toSection: .main)
                    self.dataSource.apply(currentSnapshot)
                }
            }
        }
    }
}

extension DepositAndWithdrawalViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
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
}
