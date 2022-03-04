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
        configureUI()
    }

    override func configUI() {
        super.configUI()
        setDelegations()
    }

    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [
            self.headerView, self.coinTableView
        ]).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }

        self.view.addSubview(stackView)
        self.headerView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(200)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
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

    private func setDelegations() {
        configurediffableDataSource()
        coinTableView.dataSource = dataSource
        coinTableView.delegate = self
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
