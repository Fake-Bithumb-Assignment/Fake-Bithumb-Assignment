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

    private let totalCoinListView = TotalCoinListView()

    private let interestedCoinListView = InterestedCoinListView()

    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCoinData()
        configureUI()
        setUpViews()
    }

    // MARK: - custom func

    private func configureUI() {
        configureNoInterestedCoinView()
        configureStackView()
    }

    private func fetchData() {
        fetchCurrentPrice()
        fetchChangeRateAndValue()
    }
    
    private func fetchChangeRateAndValue() {
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

            self.updateCurrentChangeRateAndValue(coin: coin, data: response)
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

    private func updateCurrentChangeRateAndValue(coin: Coin, data: BTSocketAPIResponse.TickerResponse) {
        guard let receivedCoinData = self.coinData.first(where: { $0.coinName.rawValue == coin.rawValue }) else {
            return
        }

        let currentChangeRate = data.content.chgRate
        receivedCoinData.changeRate = "\(currentChangeRate)".insertComma(value: currentChangeRate) + "%"

        let currentTradeValue = Int(data.content.value) / 1000000
        receivedCoinData.tradeValue = "\(currentTradeValue)".insertComma(value: Double(currentTradeValue)) + "백만"
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

    private func configureCoinData() {
        Coin.allCases.forEach {
            if UserDefaults.standard.string(forKey: $0.rawValue) != nil {
                totalCoinList.append(
                    CoinData(
                        coinName: $0,
                        currentPrice: "",
                        changeRate: "",
                        tradeValue: "",
                        isInterested: true
                    ))
            }
            else {
                totalCoinList.append(
                    CoinData(
                        coinName: $0,
                        currentPrice: "",
                        changeRate: "",
                        tradeValue: ""
                    ))
            }
        }
        
        self.interestedCoinList = totalCoinList.filter { $0.isInterested }
        interestedCoinListView.interestedCoinList = self.interestedCoinList
    }

    private func setUpViews() {
        headerView.delegate = self
        totalCoinListView.delegate = self
        interestedCoinListView.delegate = self
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
        coin.isInterested.toggle()
        self.interestedCoinList = self.totalCoinList.filter { $0.isInterested }
        interestedCoinListView.interestedCoinList = self.interestedCoinList
        setUserDefaults(coinName)
    }
    
    func showCoinInformation(coin: CoinData) {
        let vc = CoinViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
