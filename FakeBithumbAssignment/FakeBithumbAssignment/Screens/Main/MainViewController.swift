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
    /// 여기에는 정렬, 필터 상관 없이 모든 코인의 정보가 들어 있습니다
    private var totalCoins: [Coin: CoinData] = [:]
    /// 아래 두개는 같은 뷰를 재사용합니다. 하는 역할이 같으니깐요~!
    lazy var totalCoinTableView = MainCoinTableView()
    lazy var interestedCoinTableView = MainCoinTableView().then {
        $0.isInterestView = true
    }
    private var tickerMidWebSocket = BTSocketAPIService()
    private var ticker24WebSocket = BTSocketAPIService()
    private let tickerAPIService = TickerAPIService(
        apiService: HttpService(),
        environment: .development
    )
    private let transactionAPIService = TransactionAPIService(
        apiService: HttpService(),
        environment: .development
    )
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
    
    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.configureSearchController()
        self.setUpSearchClearButton()
    }
    
    private var isInitialState: Bool = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let stackView = UIStackView(arrangedSubviews: [
            self.headerView, self.totalCoinTableView, self.interestedCoinTableView
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
    }
    
    private func setDelegates() {
        self.headerView.delegate = self
        self.totalCoinTableView.delegate = self
        self.interestedCoinTableView.delegate = self
    }
    
    private func configureSearchController() {
        self.headerView.searchController.searchResultsUpdater = self
        self.navigationItem.searchController = headerView.searchController
    }

    private func setUserDefaults(_ coinName: String) {
        if let alreadyInterestedCoin = UserDefaults.standard.string(forKey: coinName) {
            UserDefaults.standard.removeObject(forKey: alreadyInterestedCoin)
        }
        else {
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
        ticker24WebSocket.subscribeTicker(
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
        tickerMidWebSocket.subscribeTicker(
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
                let tickerData = try await tickerAPIService.getTickerData(
                    orderCurrency: orderCurrency
                )
                if let tickerData = tickerData {
                    try tickerData.allProperties().forEach({
                        if let coinName = Coin(rawValue: $0.key.uppercased()) {
                            self.configureCoinData(coin: coinName, value: $0.value)
                        }
                    })
                } else {
                   // TODO: 에러 처리 얼럿 띄우기
                    print("tickerData is nil")
                }
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
                   let latestTransactions =
                    response.last?.transactionDate.components(separatedBy: " "),
                   let oldestTransactions =
                    response.first?.transactionDate.components(separatedBy: " ") {
                    let latestTransaction = latestTransactions[1]
                    let oldestTransaction = oldestTransactions[1]
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
        return { $0.coinName.rawValue.contains(searchText.uppercased()) }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.headerView.searchController.dismiss(animated: true, completion: nil)
    }
    
    private func updateTickerAmount(
        coin: Coin,
        data: BTSocketAPIResponse.TickerResponse
    ) {
        guard let coinData: CoinData = self.totalCoins[coin] else {
            return
        }
        let currentTradeValue = Int(data.content.value) / 1000000
        coinData.tradeValue = String.insertComma(value: Double(currentTradeValue))
    }

    private func updateTicker(
        coin: Coin, data:
        BTSocketAPIResponse.TickerResponse
    ) {
        let originCoinData: CoinData? = self.totalCoins[coin]
        let currentPriceResponse = data.content.closePrice
        let currentPrice: String = floor(currentPriceResponse) == currentPriceResponse ?
        String.insertComma(value: Int(currentPriceResponse)) : String(currentPriceResponse)
        let coinData: CoinData = CoinData(
            coinName: coin,
            currentPrice: currentPrice,
            changeRate: String.insertComma(value: data.content.chgRate),
            tradeValue: originCoinData?.tradeValue ?? "0",
            isInterested: originCoinData?.isInterested ?? false,
            popularity: originCoinData?.popularity ?? 0,
            changeAmount: String.insertComma(value: data.content.chgAmt)
        )
        self.totalCoins[coin] = coinData
        self.updateTotalCoinTableView()
        self.updateInterestCoinTableView()

    }
        
    private func parseSymbol(symbol: String?) -> Coin? {
        guard let symbol = symbol else {
            return nil
        }
        let endIndex = symbol.index(symbol.endIndex, offsetBy: -4)
        let parsedCoin = String(symbol[..<endIndex])
        return Coin(rawValue: parsedCoin)
    }

    private func configureCoinData(coin: Coin, value: Item) {
        guard let fluctateRate24H = Double(value.fluctateRate24H),
              let accTradeValue24H = Double(value.accTradeValue24H),
              let fluctate24H = Double(value.fluctate24H),
              let currentPrice = Double(value.closingPrice)
        else {
            return
        }
        let originCoinData: CoinData? = self.totalCoins[coin]
        let tradeValue = Int(accTradeValue24H) / 1000000
        let currentTradeValue = String.insertComma(value: Double(tradeValue))
        let changeRate = String.insertComma(value: fluctateRate24H)
        let price = String.insertComma(value: currentPrice)
        let changeAmount: String = fabs(fluctate24H) > 999.9 ?
        String.insertComma(value: fluctate24H) : String(fluctate24H)
        let coinData: CoinData = CoinData(
            coinName: coin,
            currentPrice: price,
            changeRate: changeRate,
            tradeValue: currentTradeValue,
            isInterested: UserDefaults.standard.string(forKey: coin.rawValue) != nil,
            popularity: originCoinData?.popularity ?? 172800,
            changeAmount: changeAmount
        )
        self.totalCoins[coin] = coinData
        self.updateTotalCoinTableView()
        self.updateInterestCoinTableView()
    }
    
    private func calculatePopularity(
        latestTransaction: String,
        oldestTransaction: String
    ) -> Int {
        let latest = latestTransaction.components(separatedBy: ":")
        let oldest = oldestTransaction.components(separatedBy: ":")
        var seconds = 3600
        var latestValue = 0
        var oldestValue = 0
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
        case .interest:
            self.totalCoinTableView.isHidden = true
            self.interestedCoinTableView.isHidden = false
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
    }
    
    func showCoinInformation(coin: CoinData) {
        self.headerView.searchController.dismiss(animated: false) {
            let coinViewController = CoinViewController()
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
