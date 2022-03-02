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

    private var dataSource: UITableViewDiffableDataSource<Section, CoinData>?

    private var snapshot = NSDiffableDataSourceSnapshot<Section, CoinData>()

    private var coinData: [CoinData] = []

    private var selectedCategory = Category.krw

    private var btsocketAPIService = BTSocketAPIService()

    private let noInterestedCoinView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }

    private let noInterestedCoinLabel = UILabel().then {
        $0.text = "등록된 관심 가상자산이 없습니다."
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .darkGray
    }

    private let coinTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .white
    }

    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCoinData()
        setDelegations()
        fetchData()
    }

    // MARK: - custom func

    override func render() {
        configureUI()
    }

    private func configureUI() {
        configureNoInterestedCoinView()
        configureStackView()
    }

    private func fetchData() {
        fetchCurrentPrice()
        fetchChangeRate()
    }
    
    private func fetchChangeRate() {
        btsocketAPIService.subscribeTicker(
            orderCurrency: Array(Coin.allCases),
            paymentCurrency: .krw, tickTypes: [.mid]
        ) { [weak self] response in
            guard let self = self else {
                return
            }

            guard let coin = self.parseSymbol(symbol: response.content.symbol) else {
                return
            }

            self.updateCurrentChangeRate(coin: coin, data: response)
            self.updateSnapshot(accordingTo: self.selectedCategory)
        }
    }
    
    private func fetchCurrentPrice() {
        btsocketAPIService.subscribeTransaction(
            orderCurrency: Array(Coin.allCases),
            paymentCurrency: .krw
        ) { [weak self] response in
            guard let self = self else {
                return
            }

            guard let coin = self.parseSymbol(symbol: response.content.list.first?.symbol) else {
                return
            }

            self.updateCurrentPrice(coin: coin, data: response)
            self.updateSnapshot(accordingTo: self.selectedCategory)
        }
    }

    private func updateCurrentChangeRate(coin: Coin, data: BTSocketAPIResponse.TickerResponse) {
        guard let receivedCoinData = self.coinData.first(where: { $0.coinName.rawValue == coin.rawValue }) else {
            return
        }
        let currentChangeRate = data.content.chgRate
        receivedCoinData.changeRate = String(currentChangeRate) + "%"
    }

    private func updateCurrentPrice(coin: Coin, data: BTSocketAPIResponse.TransactionResponse) {
        guard let receivedCoinData = self.coinData.first(where: { $0.coinName.rawValue == coin.rawValue }) else {
            return
        }
        guard let currentPrice = data.content.list.first?.contPrice else {
            return
        }

        receivedCoinData.currentPrice = String(currentPrice)
    }
    
    private func updateSnapshot(accordingTo category: Category) {
        switch category {
        case .krw:
            self.updateSnapshot(self.coinData)
        case .interest:
            let interestedCoin = self.coinData.filter { $0.isInterested }
            self.updateSnapshot(interestedCoin)
        default:
            break
        }
    }

    private func parseSymbol(symbol: String?) -> Coin? {
        guard let symbol = symbol else {
            return nil
        }

        let endIndex = symbol.index(symbol.endIndex, offsetBy: -4)
        let parsedCoin = String(symbol[..<endIndex])
        
        return Coin(rawValue: parsedCoin)
    }

    private func configureStackView() {
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

    private func configureCoinData() {
        Coin.allCases.forEach {
            if UserDefaults.standard.string(forKey: $0.rawValue) != nil {
                coinData.append(
                    CoinData(
                        coinName: $0,
                        currentPrice: "",
                        changeRate: "",
                        tradeValue: "256,880백만",
                        isInterested: true
                    ))
            }
            else {
                coinData.append(
                    CoinData(
                        coinName: $0,
                        currentPrice: "",
                        changeRate: "",
                        tradeValue: "256,880백만"
                    ))
            }
        }
    }

    private func configureNoInterestedCoinView() {
        self.noInterestedCoinView.addSubview(noInterestedCoinLabel)
        self.noInterestedCoinLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        self.coinTableView.addSubview(noInterestedCoinView)
        noInterestedCoinView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }

    private func checkIfEmpty() {
        let beUpdatedData = coinData.filter { $0.isInterested }
        if beUpdatedData.isEmpty {
            noInterestedCoinView.isHidden = false
        }
        else {
            updateSnapshot(beUpdatedData)
        }
    }

    private func configurediffableDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: coinTableView)
        { [weak self] tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CoinTableViewCell.className,
                for: indexPath
            ) as? CoinTableViewCell
            
            cell?.configure(with: self?.coinData[indexPath.row])
            return cell
        }

        configureSnapshot()
    }
    
    private func configureSnapshot() {
        self.snapshot.deleteAllItems()
        self.snapshot.appendSections([.main])
        self.snapshot.appendItems(coinData)
        self.dataSource?.apply(self.snapshot)
    }
    
    private func updateSnapshot(_ beUpdatedData: [CoinData]) {
        guard let snapshot = dataSource?.snapshot() else {
            return
        }

        self.snapshot = snapshot
        self.snapshot.deleteItems(self.coinData)
        self.snapshot.appendItems(beUpdatedData)
        self.snapshot.reconfigureItems(beUpdatedData)
        self.dataSource?.apply(self.snapshot)
    }

    private func setDelegations() {
        configurediffableDataSource()
        coinTableView.dataSource = dataSource
        coinTableView.delegate = self
        headerView.delegate = self
    }

    private func updateInterestList(_ indexPath: IndexPath) {
        let targetCoinData: CoinData
        if selectedCategory == .interest {
            targetCoinData = coinData.filter { $0.isInterested }[indexPath.row]
        }
        else {
            targetCoinData = coinData[indexPath.row]
        }
        
        let targetCoin = targetCoinData.coinName
        
        if let alreadyRegisteredCoin = UserDefaults.standard.string(forKey: targetCoin.rawValue) {
            UserDefaults.standard.removeObject(forKey: alreadyRegisteredCoin)
            targetCoinData.isInterested.toggle()
            if selectedCategory == .interest {
                checkIfEmpty()
            }
        }
        else {
            UserDefaults.standard.set(targetCoin.rawValue, forKey: targetCoin.rawValue)
            targetCoinData.isInterested.toggle()
        }
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
            self?.updateInterestList(indexPath)
            completion(true)
        }

        if selectedCategory == .interest {
            interest.image = UIImage(named: "Interested")
        }

        else {
            if coinData[indexPath.row].isInterested {
                interest.image = UIImage(named: "Interested")
            }
            else {
                interest.image = UIImage(named: "Interest")
            }
        }

        return UISwipeActionsConfiguration(actions: [interest])
    }
}

// MARK: - HeaderViewDelegate

extension MainViewController: HeaderViewDelegate {
    func selectCategory(_ category: Category) {
        switch category {
        case .krw:
            self.selectedCategory = .krw
            noInterestedCoinView.isHidden = true
            configureSnapshot()
        case .interest:
            self.selectedCategory = .interest
            checkIfEmpty()
        default:
            break
        }
    }
}
