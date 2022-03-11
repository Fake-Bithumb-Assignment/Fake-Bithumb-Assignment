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

    private var totalCoinList: [CoinData] = []

    private var interestedCoinList: [CoinData] = []

    lazy var totalCoinListView = TotalCoinListView()

    lazy var interestedCoinListView = InterestedCoinListView()

    private lazy var searchedCoin: [CoinData] = []

    private var btsocketAPIService = BTSocketAPIService()

    private let tickerAPIService = TickerAPIService(
        apiService: HttpService(),
        environment: .development
    )

    private let transactionAPIService = TransactionAPIService(
        apiService: HttpService(),
        environment: .development
    )

    private let loadingAlert = UIAlertController(title: "", message: nil, preferredStyle: .alert)

    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInitialData()
        setUpViews()
        setUpSearchClearButton()
    }

    // MARK: - custom func

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.headerView.searchController.dismiss(animated: true, completion: nil)
    }

    private func fetchInitialData() {
        getTickerData(orderCurrency: "ALL", paymentCurrency: "KRW")
        getTransactionData()
        self.loadingAlert.dismiss(animated: true) {
            self.sortByDefaultOption()
            self.fetchData()
        }
    }

    private func fetchData() {
        DispatchQueue.global().async {
            self.fetchCurrentPrice()
            self.fetchChangeRateAndValue()
        }
    }
    
    override func render() {
        configureUI()
    }

    private func configureUI() {
        configureStackViews()
        configureIndicator()
        configureNavigation()
    }

    private func configureIndicator() {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.startAnimating()
        
        self.loadingAlert.view.addSubview(loadingIndicator)
        self.loadingAlert.view.tintColor = .black

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func fetchChangeRateAndValue() {
        btsocketAPIService.subscribeTicker(
            orderCurrency: Array(Coin.allCases),
            paymentCurrency: .krw, tickTypes: [._24h]
        ) { response in
            guard let coin = self.parseSymbol(symbol: response.content.symbol) else {
                return
            }

            DispatchQueue.main.async {
                self.updateCurrentChangeRateAndValue(coin: coin, data: response)
            }
        }
    }
    
    private func configureNavigation() {
        self.navigationItem.titleView = NavigationLogoTitleView()
    }
    
    private func fetchCurrentPrice() {
        btsocketAPIService.subscribeTransaction(
            orderCurrency: Array(Coin.allCases),
            paymentCurrency: .krw
        ) { response in
            guard let coin = self.parseSymbol(symbol: response.content.list.first?.symbol)
            else {
                return
            }

            DispatchQueue.main.async {
                self.updateCurrentPrice(coin: coin, data: response)
            }
        }
    }

    private func updateCurrentChangeRateAndValue(
        coin: Coin,
        data: BTSocketAPIResponse.TickerResponse
    ) {
        guard let receivedCoinData = self.totalCoinList.first(
            where: { $0.coinName.rawValue == coin.rawValue }
        )
        else {
            return
        }

        let changeAmount = data.content.chgAmt
        receivedCoinData.changeAmount = String.insertComma(value: changeAmount)

        let currentChangeRate = data.content.chgRate
        receivedCoinData.changeRate = String.insertComma(value: currentChangeRate)

        let currentTradeValue = Int(data.content.value) / 1000000
        receivedCoinData.tradeValue = String.insertComma(value: Double(currentTradeValue))

        updateSnapshot(receivedCoinData)
    }

    private func updateCurrentPrice(coin: Coin, data: BTSocketAPIResponse.TransactionResponse) {
        guard let receivedCoinData = self.totalCoinList.first(
            where: { $0.coinName.rawValue == coin.rawValue }
        )
        else {
            return
        }

        guard let currentPrice = data.content.list.first?.contPrice else {
            return
        }

        if floor(currentPrice) == currentPrice {
            let price = Int(currentPrice)
            receivedCoinData.currentPrice = String.insertComma(value: price)
        }
        else {
            receivedCoinData.currentPrice = String(currentPrice)
        }

        updateSnapshot(receivedCoinData)
    }
    
    private func updateSnapshot(_ updatedValue: CoinData) {
        if totalCoinListView.totalCoinList.contains(updatedValue) {
            totalCoinListView.updateSnapshot(of: updatedValue)
            if updatedValue.isInterested {
                interestedCoinListView.updateSnapshot(of: updatedValue)
            }
        }
    }
    
    private func updateInterestedCoinList() {
        self.interestedCoinList = totalCoinList.filter { $0.isInterested }
        interestedCoinListView.interestedCoinList = self.interestedCoinList
    }

    private func parseSymbol(symbol: String?) -> Coin? {
        guard let symbol = symbol else {
            return nil
        }

        let endIndex = symbol.index(symbol.endIndex, offsetBy: -4)
        let parsedCoin = String(symbol[..<endIndex])
        
        return Coin(rawValue: parsedCoin)
    }

    private func configureStackViews() {
        let stackView = UIStackView(arrangedSubviews: [
            self.headerView, self.totalCoinListView, self.interestedCoinListView
        ]).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }

        self.interestedCoinListView.isHidden = true
        self.view.addSubview(stackView)
        self.headerView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(200)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureCoinData(coin: Coin, value: Item) {
        guard let fluctateRate24H = Double(value.fluctateRate24H),
              let accTradeValue24H = Double(value.accTradeValue24H),
              let fluctate24H = Double(value.fluctate24H)
        else {
            return
        }

        let tradeValue = Int(accTradeValue24H) / 1000000
        let currentTradeValue = String.insertComma(value: Double(tradeValue))
        let changeRate = String.insertComma(value: fluctateRate24H)

        let changeAmount: String

        if fabs(fluctate24H) > 999.9 {
            changeAmount = String.insertComma(value: fluctate24H)
        }
        else {
            changeAmount = String(fluctate24H)
        }

        if UserDefaults.standard.string(forKey: coin.rawValue) != nil {
            self.totalCoinList.append(CoinData(
                coinName: coin,
                currentPrice: "",
                changeRate: changeRate,
                tradeValue: currentTradeValue,
                isInterested: true,
                popularity: 172800,
                changeAmount: changeAmount
            ))
        }
        else {
            self.totalCoinList.append(CoinData(
                coinName: coin,
                currentPrice: "",
                changeRate: changeRate,
                tradeValue: currentTradeValue,
                popularity: 172800,
                changeAmount: changeAmount
            ))
        }
    }

    private func sortByDefaultOption() {
        self.totalCoinList.sort { $0.popularity < $1.popularity }
        self.totalCoinListView.totalCoinList = self.totalCoinList
        self.updateInterestedCoinList()
    }

    private func sortByPopularity() {
        self.present(self.loadingAlert, animated: true, completion: nil)
        self.getTransactionData()
        self.totalCoinList.sort { $0.popularity < $1.popularity }
        self.loadingAlert.dismiss(animated: true, completion: nil)
    }

    private func sortByName() {
        self.totalCoinList.sort { $0.coinName.rawValue < $1.coinName.rawValue }
    }
    
    private func sortByChangeRate() {
        self.totalCoinList.sort {
            let firstValue = $0.changeRate
            let secondValue = $1.changeRate

            guard let firstChangeRate = Double(firstValue),
                  let secondChangeRate = Double(secondValue)
            else {
                return $0.changeRate > $1.changeRate
            }

            return firstChangeRate > secondChangeRate
        }
    }

    private func getTickerData(orderCurrency: String, paymentCurrency: String) {
        self.present(self.loadingAlert, animated: true, completion: nil)

        Task {
            do {
                let tickerData = try await tickerAPIService.getTickerData(
                    orderCurrency: orderCurrency,
                    paymentCurrency: paymentCurrency
                )
                if let tickerData = tickerData {
                    try tickerData.allProperties().forEach({
                        if let coinName = Coin(rawValue: $0.key.uppercased()) {
                            configureCoinData(coin: coinName, value: $0.value)
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
    
    private func getTransactionData() {
        Coin.allCases.forEach { coin in
            Task {
                guard let response = await transactionAPIService.requestTransactionHistory(
                    of: coin
                ) else {
                    return
                }
                
                if let findedCoin = self.totalCoinList.first(where: { $0.coinName == coin }),
                   let latestTransactions = response.last?.transactionDate.components(separatedBy: " "),
                   let oldestTransactions = response.first?.transactionDate.components(separatedBy: " "),
                   let priceData = response.first?.price, let price = Double(priceData)
                {
                    let currentPrice = String.insertComma(value: price)
                    findedCoin.currentPrice = currentPrice

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
    
    private func calculatePopularity(latestTransaction: String, oldestTransaction: String) -> Int {
        let latest = latestTransaction.components(separatedBy: ":")
        let oldest = oldestTransaction.components(separatedBy: ":")
        var seconds = 3600
        var latestValue = 86400
        var oldestValue = 86400

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

        return latestValue - oldestValue
    }

    private func setUpViews() {
        headerView.delegate = self
        totalCoinListView.delegate = self
        interestedCoinListView.delegate = self
        headerView.searchController.searchResultsUpdater = self
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

    // MARK: - @objc

    @objc private func clearButtonClicked() {
        self.headerView.searchController.dismiss(animated: true, completion: nil)
        totalCoinListView.totalCoinList = self.totalCoinList
        updateInterestedCoinList()
    }
}

// MARK: - HeaderViewDelegate

extension MainViewController: HeaderViewDelegate {
    func sorted(by sortOption: SortOption) {
        switch sortOption {
        case .sortedBypopular:
            self.sortByPopularity()
        case .sortedByName:
            self.sortByName()
        case .sortedByChangeRate:
            self.sortByChangeRate()
        }
        totalCoinListView.totalCoinList = self.totalCoinList
        updateInterestedCoinList()
        NotificationCenter.default.post(name: .updateTableView, object: nil)
    }

    func selectCategory(_ category: Category) {
        self.headerView.searchController.dismiss(animated: true, completion: nil)
        switch category {
        case .krw:
            self.totalCoinListView.isHidden = false
            self.interestedCoinListView.isHidden = true
        case .interest:
            self.totalCoinListView.isHidden = true
            self.interestedCoinListView.isHidden = false
        default:
            break
        }
    }
}

// MARK: - CoinDelgate

extension MainViewController: CoinDelgate {
    func updateInterestList(coin: CoinData) {
        let coinName = coin.coinName
        if coin.isInterested {
            interestedCoinListView.deleteInterestedCoin(coin)
            interestedCoinListView.interestedCoinList.removeAll { $0 == coin }
        }
        else {
            interestedCoinListView.insertNewInterestedCoin(coin)
            interestedCoinListView.interestedCoinList.append(coin)
        }

        coin.isInterested.toggle()
        self.interestedCoinList = interestedCoinListView.interestedCoinList
        setUserDefaults(coinName.rawValue)
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
        totalCoinListView.totalCoinList = self.totalCoinList.filter {
            $0.coinName.rawValue.hasPrefix(searchController.searchBar.text ?? "")
        }
        totalCoinListView.configureSnapshot()

        interestedCoinListView.interestedCoinList = self.interestedCoinList.filter {
            $0.coinName.rawValue.hasPrefix(searchController.searchBar.text ?? "")
        }
    }
}
