//
//  TotalCoinListView.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/02.
//

import UIKit

import SnapKit
import Then

final class MainCoinTableView: UIView {

    // MARK: - Instance Property
    
    var isInterestView: Bool = false {
        didSet {
            noInterestedCoinView.isHidden = coinDatas.isEmpty ? false : true
        }
    }
    private var dataSource: UITableViewDiffableDataSource<Section, CoinData>?
    weak var delegate: CoinDelgate?
    var coinDatas: [CoinData] = [] {
        didSet {
            noInterestedCoinView.isHidden = coinDatas.isEmpty ? false : true
            self.configureSnapshot()
        }
    }
    let tableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .clear
        $0.keyboardDismissMode = .onDrag
        $0.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
        self.configUI()
        self.configurediffableDataSource()
        self.tableView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - custom func

    private func configUI() {
        noInterestedCoinView.addSubview(noInterestedCoinLabel)
        noInterestedCoinLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.addSubview(noInterestedCoinView)
        noInterestedCoinView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }

    private func configurediffableDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: tableView)
        { tableView, indexPath, coinList in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CoinTableViewCell.className,
                for: indexPath
            ) as? CoinTableViewCell

            let backgroundView = UIView()
            backgroundView.backgroundColor = .white
            cell?.selectedBackgroundView = backgroundView

            cell?.configure(with: coinList)
            return cell
        }
        self.tableView.dataSource = dataSource
        configureSnapshot()
    }
    
    func configureSnapshot() {
        guard var snapshot = self.dataSource?.snapshot() else {
            return
        }
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.coinDatas)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate

extension MainCoinTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.showCoinInformation(coin: coinDatas[indexPath.row])
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        if self.isInterestView {
            let interest = UIContextualAction(
                style: .normal,
                title: nil
            ) { _, _, completion in
                self.delegate?.updateInterestList(coinData: self.coinDatas[indexPath.row])
                completion(true)
            }
            interest.image = UIImage(named: "Interested")
            return UISwipeActionsConfiguration(actions: [interest])
        } else {
            let interest = UIContextualAction(
                style: .normal,
                title: nil
            ) { _, view, completion in
                self.delegate?.updateInterestList(coinData: self.coinDatas[indexPath.row])
                let star = self.coinDatas[indexPath.row].isInterested ?
                "Interested" : "Interest"
                let closingImageView = UIImageView(image: UIImage(named: star))
                view.addSubView(closingImageView) {
                    $0.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                    }
                }
                completion(true)
            }
            if self.coinDatas[indexPath.row].isInterested {
                interest.image = UIImage(named: "Interested")
            }
            else {
                interest.image = UIImage(named: "Interest")
            }
            return UISwipeActionsConfiguration(actions: [interest])
        }
    }
}
