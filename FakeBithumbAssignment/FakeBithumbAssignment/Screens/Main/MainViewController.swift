//
//  MainViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

final class MainViewController: BaseViewController {

    // MARK: - Instance Property

    private let headerView = HeaderView()

    private var dataSource: UITableViewDiffableDataSource<Int, UUID>?

    private let coinTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
    }

    // MARK: - custom func

    override func render() {
        configureHeaderView()
        configureTableView()
    }

    private func configureHeaderView() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.lessThanOrEqualTo(200)
        }
    }

    private func configurediffableDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: coinTableView)
        { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CoinTableViewCell.className,
                for: indexPath
            )
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        snapshot.appendSections([0])
        
        /// 디버깅 용 코드
        var uuidArray: [UUID] = []
        for _ in 0..<50 {
            uuidArray.append(UUID())
        }
        ///
        snapshot.appendItems(uuidArray)
        self.dataSource?.apply(snapshot)
    }

    private func configureTableView() {
        configurediffableDataSource()
        coinTableView.dataSource = dataSource
        coinTableView.delegate = self

        view.addSubview(coinTableView)
        guard let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        else {
            return
        }

        coinTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(tabBarHeight)
        }
    }
    
    private func updateInterestList() {
        
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = CoinViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let interest = UIContextualAction(
            style: .normal,
            title: nil
        ) { [weak self] _, _, completion in
            self?.updateInterestList()
            completion(true)
        }
        interest.image = UIImage(named: "Interest")

        return UISwipeActionsConfiguration(actions: [interest])
    }
}
