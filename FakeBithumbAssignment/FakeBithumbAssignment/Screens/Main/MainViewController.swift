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

    private let headerView: HeaderView = HeaderView()
    private var totalCoins: [Coin: CoinData] = [:]
    lazy var totalCoinTableView: MainCoinTableView = MainCoinTableView()
    lazy var interestedCoinTableView: MainCoinTableView = MainCoinTableView().then {
        $0.isInterestView = true
    }
    private var tickerMidWebSocket: SocketAPIService = SocketAPIService()
    private var ticker24WebSocket: SocketAPIService = SocketAPIService()
    private let tickerAPIService: TickerAPIService = TickerAPIService()
    private let transactionAPIService: TransactionAPIService = TransactionAPIService()
    private var searchText: String? = nil
    private var sortOption: SortOption = SortOption.sortedBypopular
    private let sortedBy: [SortOption: (CoinData, CoinData) -> Bool] = {
        let byPopularity: (CoinData, CoinData) -> Bool = { $0.popularity < $1.popularity }
        let byName: (CoinData, CoinData) -> Bool = { $0.coinName.rawValue < $1.coinName.rawValue }
        let byChangeRate: (CoinData, CoinData) -> Bool = {
            guard let firstChangeRate = Double($0.changeRate),
                  let secondChangeRate = Double($1.changeRate)
            else {
                return $0.changeRate > $1.changeRate
            }
            return firstChangeRate > secondChangeRate
        }
        return [
            SortOption.sortedBypopular: byPopularity,
            SortOption.sortedByName: byName,
            SortOption.sortedByChangeRate: byChangeRate
        ]
    }()
    private let loadingAlert: UIAlertController = UIAlertController(
        title: "",
        message: nil,
        preferredStyle: .alert
    )
    private var isInitialState: Bool = true
    
    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.configureSearchController()
        self.setUpSearchClearButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isInitialState {
            self.present(self.loadingAlert, animated: true, completion: nil)
        }
        self.fetchTickerAPIData(orderCurrency: "ALL", paymentCurrency: "KRW")
        if self.isInitialState {
            self.fetchTransactionAPIData()
            self.isInitialState = false
        }
        self.fetchTickerSocketData()
        self.fetchTickerAmountSocketData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ticker24WebSocket.disconnectAll()
        self.tickerMidWebSocket.disconnectAll()
    }
    
    // MARK: - configuration
    
    override func render() {
        self.navigationItem.titleView = NavigationLogoTitleView()
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            self.headerView,
            self.totalCoinTableView,
            self.interestedCoinTableView
        ]).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        self.interestedCoinTableView.isHidden = true
        self.view.addSubview(stackView)
        self.headerView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(200)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.configureIndicator()
    }
    
    private func setDelegates() {
        self.headerView.delegate = self
        self.totalCoinTableView.delegate = self
        self.interestedCoinTableView.delegate = self
    }

    private func configureIndicator() {
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        
        self.loadingAlert.view.addSubview(loadingIndicator)
        self.loadingAlert.view.tintColor = .black
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func configureSearchController() {
        self.headerView.searchController.searchResultsUpdater = self
        self.navigationItem.searchController = headerView.searchController
    }

    private func setUserDefaults(_ coinName: String) {
        if let alreadyInterestedCoin = UserDefaults.standard.string(forKey: coinName) {
            UserDefaults.standard.removeObject(forKey: alreadyInterestedCoin)
        } else {
            UserDefaults.standard.set(coinName, forKey: coinName)
        }
    }

    private func setUpSearchClearButton() {
        if let searchTextField = self.headerView.searchController.searchBar.value(
            forKey: "searchField"
        ) as? UITextField,
           let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton {
            clearButton.addTarget(
                self,
                action: #selector(clearButtonClicked),
                for: .touchUpInside
            )
        }
    }

    // MARK: - update tableView

    func updateTotalCoinTableView() {
        guard let sortedBy: (CoinData, CoinData) -> Bool =
                self.self.sortedBy[self.sortOption] else {
                    return
                }
        let targetCoins: [CoinData] = self.totalCoins.values
            .filter(self.isSearchMatches())
            .sorted(by: sortedBy)
        self.totalCoinTableView.coinDatas = targetCoins
    }

    func updateInterestCoinTableView() {
        guard let sortedBy: (CoinData, CoinData) -> Bool =
                self.self.sortedBy[self.sortOption] else {
                    return
                }
        let targetCoins: [CoinData] = self.totalCoins.values
            .filter(self.isSearchMatches())
            .filter { $0.isInterested }
            .sorted(by: sortedBy)
        self.interestedCoinTableView.coinDatas = targetCoins
    }

    // MARK: - fetch from API
    
    private func fetchTickerAmountSocketData() {
        self.ticker24WebSocket.subscribeTicker(
            orderCurrency: Array(Coin.allCases),
            paymentCurrency: .krw, tickTypes: [._24h]
        ) { response in
            guard let coin = self.parseSymbol(symbol: response.content.symbol) else {
                return
            }
            self.updateTickerAmount(coin: coin, data: response)
        }
    }

    private func fetchTickerSocketData() {
        self.tickerMidWebSocket.subscribeTicker(
            orderCurrency: Array(Coin.allCases),
            paymentCurrency: .krw, tickTypes: [.mid]
        ) { response in
            guard let coin = self.parseSymbol(symbol: response.content.symbol) else {
                return
            }
            self.updateTicker(coin: coin, data: response)
        }
    }

    private func fetchTickerAPIData(orderCurrency: String, paymentCurrency: String) {
        Task {
            do {
                let tickerData: AllTickerResponse? = try await tickerAPIService.getTickerData(
                    orderCurrency: orderCurrency
                )
                if let tickerData: AllTickerResponse = tickerData {
                    try tickerData.allProperties().forEach({
                        if let coinName: Coin = Coin(rawValue: $0.key.uppercased()) {
                            self.configureCoinData(coin: coinName, value: $0.value)
                        }
                    })
                } else {
                   // TODO: 에러 처리 얼럿 띄우기
                    print("tickerData is nil")
                }

                self.updateTotalCoinTableView()
                self.updateInterestCoinTableView()
                self.loadingAlert.dismiss(animated: true, completion: nil)
            } catch HttpServiceError.serverError {
                print("serverError")
            } catch HttpServiceError.clientError(let message) {
                print("clientError:\(String(describing: message))")
            }
        }
    }

    private func fetchTransactionAPIData() {
        Coin.allCases.forEach { coin in
            Task {
                guard let response = await transactionAPIService.requestTransactionHistory(
                    of: coin
                ) else {
                    return
                }
                if let findedCoin = self.totalCoins[coin],
                   let latestTransactions: [String] =
                    response.last?.transactionDate.components(separatedBy: " "),
                   let oldestTransactions: [String] =
                    response.first?.transactionDate.components(separatedBy: " ") {
                    let latestTransaction: String = latestTransactions[1]
                    let oldestTransaction: String = oldestTransactions[1]
                    findedCoin.popularity = self.calculatePopularity(
                        latestTransaction: latestTransaction,
                        oldestTransaction: oldestTransaction
                    )
                }
            }
        }
    }

    // MARK: - custom func
    
    private func isSearchMatches() -> (CoinData) -> Bool {
        guard let searchText: String = self.searchText, !searchText.isEmpty else {
            return { _ in true }
        }
        return { $0.coinName.rawValue.contains(searchText.uppercased()) ||
            String(describing: $0.coinName).contains(searchText.uppercased())
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.headerView.searchController.dismiss(animated: true, completion: nil)
    }

    private func updateTickerAmount(
        coin: Coin,
        data: SocketAPIResponse.TickerResponse
    ) {
        guard let coinData: CoinData = self.totalCoins[coin] else {
            return
        }
        let currentTradeValue: Int = Int(data.content.value) / 1000000
        coinData.tradeValue = String.insertComma(value: Double(currentTradeValue))
    }

    private func updateTicker(
        coin: Coin, data:
        SocketAPIResponse.TickerResponse
    ) {
        let originCoinData: CoinData? = self.totalCoins[coin]
        let currentPriceResponse: Double = data.content.closePrice
        let currentPrice: String = floor(currentPriceResponse) == currentPriceResponse ?
        String.insertComma(value: Int(currentPriceResponse)) : String(currentPriceResponse)
        let coinData: CoinData = CoinData(
            coinName: coin,
            currentPrice: currentPrice,
            changeRate: String.insertComma(value: data.content.chgRate),
            tradeValue: originCoinData?.tradeValue ?? "0",
            isInterested: originCoinData?.isInterested ?? false,
            popularity: originCoinData?.popularity ?? 172800,
            changeAmount: String.insertComma(value: data.content.chgAmt),
            previousPrice: originCoinData?.currentPrice ?? ""
        )
        self.totalCoins[coin] = coinData
        self.updateTotalCoinTableView()
        self.updateInterestCoinTableView()

    }

    private func parseSymbol(symbol: String?) -> Coin? {
        guard let symbol = symbol else {
            return nil
        }
        let endIndex: String.Index = symbol.index(symbol.endIndex, offsetBy: -4)
        let parsedCoin: String = String(symbol[..<endIndex])
        return Coin(rawValue: parsedCoin)
    }

    private func configureCoinData(coin: Coin, value: AllTickerResponse.Ticker) {
        guard let fluctateRate24H: Double = Double(value.fluctateRate24H),
              let accTradeValue24H: Double = Double(value.accTradeValue24H),
              let fluctate24H: Double = Double(value.fluctate24H),
              let currentPrice: Double = Double(value.closingPrice)
        else {
            return
        }
        let originCoinData: CoinData? = self.totalCoins[coin]
        let tradeValue: Int = Int(accTradeValue24H) / 1000000
        let currentTradeValue: String = String.insertComma(value: Double(tradeValue))
        let changeRate: String = String.insertComma(value: fluctateRate24H)
        let price: String = String.insertComma(value: currentPrice)
        let changeAmount: String = fabs(fluctate24H) > 999.9 ?
        String.insertComma(value: fluctate24H) : String(fluctate24H)
        let coinData: CoinData = CoinData(
            coinName: coin,
            currentPrice: price,
            changeRate: changeRate,
            tradeValue: currentTradeValue,
            isInterested: UserDefaults.standard.string(forKey: coin.rawValue) != nil,
            popularity: originCoinData?.popularity ?? 172800,
            changeAmount: changeAmount,
            previousPrice: ""
        )
        self.totalCoins[coin] = coinData
    }

    private func calculatePopularity(
        latestTransaction: String,
        oldestTransaction: String
    ) -> Int {
        let latest: [String] = latestTransaction.components(separatedBy: ":")
        let oldest: [String] = oldestTransaction.components(separatedBy: ":")
        var seconds: Int = 3600
        var latestValue: Int = 0
        var oldestValue: Int = 0
        latest.forEach {
            if let time = Int($0) {
                latestValue += time * seconds
                seconds /= 60
            }
        }
        seconds = 3600
        oldest.forEach {
            if let time = Int($0) {
                oldestValue += time * seconds
                seconds /= 60
            }
        }
        if latestValue < oldestValue {
            return latestValue + 86400 - oldestValue
        }
        return latestValue - oldestValue
    }

    // MARK: - @objc

    @objc private func clearButtonClicked() {
        self.headerView.searchController.dismiss(animated: true, completion: nil)
        self.updateTotalCoinTableView()
        self.updateInterestCoinTableView()
    }
}

// MARK: - HeaderViewDelegate

extension MainViewController: HeaderViewDelegate {
    func sorted(by sortOption: SortOption) {
        self.sortOption = sortOption
        self.updateTotalCoinTableView()
        self.updateInterestCoinTableView()
    }

    func selectCategory(_ category: Category) {
        self.headerView.searchController.dismiss(animated: true, completion: nil)
        switch category {
        case .krw:
            self.totalCoinTableView.isHidden = false
            self.interestedCoinTableView.isHidden = true
            self.totalCoinTableView.isInterestView = false
        case .interest:
            self.totalCoinTableView.isHidden = true
            self.interestedCoinTableView.isHidden = false
            self.interestedCoinTableView.isInterestView = true
        default:
            break
        }
    }
}

// MARK: - CoinDelgate

extension MainViewController: CoinDelgate {
    func updateInterestList(coinData: CoinData) {
        coinData.isInterested.toggle()
        self.setUserDefaults(coinData.coinName.rawValue)
        self.updateTotalCoinTableView()
        self.updateInterestCoinTableView()
        self.totalCoinTableView.endEditing(true)
    }

    func showCoinInformation(coin: CoinData) {
        if self.headerView.searchController.isActive {
            self.headerView.searchController.dismiss(animated: true)
        } else {
            let coinViewController: CoinViewController = CoinViewController()
            coinViewController.coin = coin.coinName
            coinViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(coinViewController, animated: true)
        }
    }
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchText = searchController.searchBar.text
        self.updateTotalCoinTableView()
        self.updateInterestCoinTableView()
    }
}
