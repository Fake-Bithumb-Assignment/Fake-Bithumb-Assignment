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

    private lazy var totalCoinListView = TotalCoinListView()

    private lazy var interestedCoinListView = InterestedCoinListView()

    private var btsocketAPIService = BTSocketAPIService()

    private let tickerAPIService = TickerAPIService(apiService: HttpService(), environment: .development)

    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        getTickerData(orderCurrency: "ALL", paymentCurrency: "KRW")
        configureUI()
        setUpViews()
    }

    // MARK: - custom func

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }

    private func configureUI() {
        configureStackView()
    }

    private func fetchData() {
        fetchCurrentPrice()
        fetchChangeRateAndValue()
    }
    
    private func fetchChangeRateAndValue() {
        btsocketAPIService.subscribeTicker(
            orderCurrency: Array(Coin.allCases),
            paymentCurrency: .krw, tickTypes: [._24h]
        ) { response in
            guard let coin = self.parseSymbol(symbol: response.content.symbol) else {
                return
            }

            self.updateCurrentChangeRateAndValue(coin: coin, data: response)
        }
    }
    
    private func fetchCurrentPrice() {
        btsocketAPIService.subscribeTransaction(
            orderCurrency: Array(Coin.allCases),
            paymentCurrency: .krw
        ) { response in
            guard let coin = self.parseSymbol(symbol: response.content.list.first?.symbol) else {
                return
            }

            self.updateCurrentPrice(coin: coin, data: response)
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

        let currentChangeRate = data.content.chgRate
        receivedCoinData.changeRate = String.insertComma(value: currentChangeRate) + "%"

        let currentTradeValue = Int(data.content.value) / 1000000
        receivedCoinData.tradeValue = String.insertComma(value: Double(currentTradeValue)) + "백만"

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

        receivedCoinData.currentPrice = String(currentPrice)

        updateSnapshot(receivedCoinData)
    }
    
    private func updateSnapshot(_ updatedValue: CoinData) {
        totalCoinListView.updateSnapshot(of: updatedValue)
        if updatedValue.isInterested {
            interestedCoinListView.updateSnapshot(of: updatedValue)
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

    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [
            self.headerView, self.totalCoinListView, self.interestedCoinListView
        ]).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }

        self.totalCoinListView.totalCoinList = totalCoinList
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
        if UserDefaults.standard.string(forKey: coin.rawValue) != nil {
            guard let fluctateRate24H = Double(value.fluctateRate24H),
                  let accTradeValue24H = Double(value.accTradeValue24H)
            else {
                return
            }
            
            let tradeValue = Int(accTradeValue24H) / 1000000
            let currentTradeValue = String.insertComma(value: Double(tradeValue)) + "백만"
            let changeRate = String.insertComma(value: fluctateRate24H) + "%"
            self.totalCoinList.append(CoinData(coinName: coin, currentPrice: value.fluctate24H, changeRate: changeRate, tradeValue: currentTradeValue, isInterested: true))
        }
        else {
            guard let fluctateRate24H = Double(value.fluctateRate24H),
                  let accTradeValue24H = Double(value.accTradeValue24H)
            else {
                return
            }
            
            let tradeValue = Int(accTradeValue24H) / 1000000
            let currentTradeValue = String(tradeValue) + "백만"
            let changeRate = String(fluctateRate24H) + "%"
//            let currentTradeValue = String.insertComma(value: Double(tradeValue)) + "백만"
//            let changeRate = String.insertComma(value: fluctateRate24H) + "%"
            self.totalCoinList.append(CoinData(coinName: coin, currentPrice: value.fluctate24H, changeRate: changeRate, tradeValue: currentTradeValue))
        }
    }
    
    private func setUpData() {
        self.totalCoinList.sort {
            let firstEndIndex = $0.tradeValue.index($0.tradeValue.endIndex, offsetBy: -2)
            let secondEndIndex = $1.tradeValue.index($1.tradeValue.endIndex, offsetBy: -2)
            
            let firstValue = String($0.tradeValue[..<firstEndIndex])
            let secondValue = String($1.tradeValue[..<secondEndIndex])
            
            guard let firstTradeValue = Int(firstValue),
                  let secondTradeValue = Int(secondValue)
            else {
                return $0.tradeValue < $1.tradeValue
            }

            return firstTradeValue < secondTradeValue
        }
        totalCoinListView.totalCoinList = self.totalCoinList
        updateInterestedCoinList()
    }

    private func getTickerData(orderCurrency: String, paymentCurrency: String) {
        Task {
            do {
                let tickerData = try await tickerAPIService.getTickerData(orderCurrency: orderCurrency, paymentCurrency: paymentCurrency)
                if let tickerData = tickerData {
                    try tickerData.allProperties().forEach({
                        if let coinName = Coin(rawValue: $0.key.uppercased()) {
                            configureCoinData(coin: coinName, value: $0.value)
                        }
                    })
                    setUpData()
                    fetchData()
                } else {
                   // TODO: 에러 처리 얼럿 띄우기
                }

            } catch HttpServiceError.serverError {
                print("serverError")
            } catch HttpServiceError.clientError(let message) {
                print("clientError:\(message)")
            }
        }
    }

    private func setUpViews() {
        headerView.delegate = self
        totalCoinListView.delegate = self
        interestedCoinListView.delegate = self
        headerView.searchView.searchfield.delegate = self
    }

    private func setUserDefaults(_ coinName: String) {
        if let alreadyInterestedCoin = UserDefaults.standard.string(forKey: coinName) {
            UserDefaults.standard.removeObject(forKey: alreadyInterestedCoin)
        }
        else {
            UserDefaults.standard.set(coinName, forKey: coinName)
        }
    }
}

// MARK: - HeaderViewDelegate

extension MainViewController: HeaderViewDelegate {
    func sorted(by sortOption: SortOption) {
        switch sortOption {
        case .sortedBypopular:
            self.totalCoinList.sort { $0.tradeValue > $1.tradeValue }
        case .sortedByName:
            self.totalCoinList.sort { $0.coinName.rawValue < $1.coinName.rawValue }
        case .sortedByChangeRate:
            self.totalCoinList.sort { $0.changeRate > $1.changeRate }
        }
        totalCoinListView.totalCoinList = self.totalCoinList
        updateInterestedCoinList()
        NotificationCenter.default.post(name: .updateTableView, object: nil)
    }

    func selectCategory(_ category: Category) {
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
        setUserDefaults(coinName.rawValue)
    }
    
    func showCoinInformation(coin: CoinData) {
        self.view.endEditing(true)
        let vc = CoinViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
