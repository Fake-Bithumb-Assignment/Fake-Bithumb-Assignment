//
//  DepositAndWithdrawalViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

final class DepositAndWithdrawalViewController: BaseViewController {
    
    // MARK: - Instance Property
    
    private let btAssetsStatusAPIService: AssetsStatusAPIService = AssetsStatusAPIService()
    private let searchBar: UISearchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
    }
    private let headerView: DepositAndWithWithdrawalTableHeaderView =
    DepositAndWithWithdrawalTableHeaderView()
    let tableView: UITableView = UITableView().then {
        $0.register(
            DepositAndWithdrawalTableViewCell.self,
            forCellReuseIdentifier: DepositAndWithdrawalTableViewCell.className
        )
        $0.keyboardDismissMode = .onDrag
    }
    private var assetStatuses: [AssetsStatus] = []
    private lazy var dataSource: UITableViewDiffableDataSource<AssetsStatusSection, AssetsStatus> =
    self.configureDataSource()
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetData()
        self.searchBar.text = ""
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
        super.configUI()
        self.configureSearchBar()
        self.configureTableView()
        self.configureNavigation()
    }
    
    private func configureSearchBar() {
        self.searchBar.placeholder = "검색"
        self.searchBar.delegate = self
        
        if let textField = self.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .clear
            textField.borderStyle = .none
            let attributedString = NSAttributedString(
                string: "코인명 또는 심볼 검색",
                attributes: [
                    .foregroundColor: UIColor.gray,
                    .font: UIFont.systemFont(ofSize: 15)
                ]
            )
            textField.attributedPlaceholder = attributedString
        }
        
        self.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.setUpSearchClearButton()
    }
    
    private func configureTableView() {
        self.tableView.rowHeight = 50
        self.tableView.delegate = self
        self.tableView.dataSource = self.dataSource
        self.tableView.separatorInset = UIEdgeInsets()
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "입출금 현황"
    }

    private func setUpSearchClearButton() {
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField,
           let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton {
            clearButton.addTarget(
                self,
                action: #selector(clearButtonClicked),
                for: .touchUpInside
            )
        }
    }

    // MARK: - @objc

    @objc private func clearButtonClicked() {
        self.view.endEditing(true)
    }
}

// MARK: - extension

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
        snapshot.appendItems(assetStatuses, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
        return dataSource
    }
    
    private func fetchData() {
        Task {
            guard let response: [String: AssetsStatusResponse] = await
                    btAssetsStatusAPIService.requestAllAssetsStatus()
            else {
                return
            }
            var result: [AssetsStatus] = []
            response.keys.forEach { symbol in
                guard let coin: Coin = Coin(symbol: symbol) else {
                    return
                }
                guard let assetStatus: AssetsStatusResponse = response[symbol] else {
                    return
                }
                let depositStatus: Bool = assetStatus.depositStatus == 1
                let withdrawalStatus: Bool = assetStatus.withdrawalStatus == 1
                let assetsStatus: AssetsStatus = AssetsStatus(
                    coin: coin,
                    depositStatus: depositStatus,
                    withdrawalStatus: withdrawalStatus
                )
                result.append(assetsStatus)
            }
            var currentSnapshot = self.dataSource.snapshot()
            self.assetStatuses = result
            currentSnapshot.appendItems(result, toSection: .main)
            await self.dataSource.apply(currentSnapshot, animatingDifferences: false)
        }
    }
    
    private func resetData() {
        self.assetStatuses.removeAll()
        var currentSnapshot = self.dataSource.snapshot()
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([.main])
        self.dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(to: [AssetsStatus]) {
        var currentSnapshot = self.dataSource.snapshot()
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(to, toSection: .main)
        self.dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension DepositAndWithdrawalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.view.endEditing(true)
        return nil
    }
}

extension DepositAndWithdrawalViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.updateSnapshot(to: self.assetStatuses)
            return
        }
        let filtered: [AssetsStatus] = self.assetStatuses.filter {
            $0.coin.rawValue.contains(searchText.uppercased()) ||
            String(describing: $0.coin).contains(searchText.uppercased())
        }
        self.updateSnapshot(to: filtered)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
