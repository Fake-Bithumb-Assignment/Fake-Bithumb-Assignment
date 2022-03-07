//
//  CoinQuoteInformationTabViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

class CoinQuoteInformationTabViewController: BaseViewController {
    
    // MARK: - Instance Property
    
    let orderbookAPIService: OrderbookAPIService = OrderbookAPIService(apiService: HttpService(),
                                                                       environment: .development)
    var btsocketAPIService: BTSocketAPIService = BTSocketAPIService()
    
    var asksList: [Quote] = []
    var bidsList: [Quote] = []
    
    let sellGraphTableViewController = SellGraphTableViewController()
    let buyGraphTableViewController = BuyGraphTableViewController()
    let quoteTableViewController = QuoteTableViewController()
    let coinFirstInformationView = CoinFirstInformationView()
    let coinSecondInformationView = CoinSecondInformationView()
    
    let scrollView = UIScrollView().then { make in
        make.backgroundColor = .white
    }
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderbookData(orderCurrency: "BTC", paymentCurrency: "KRW")
        getWebSocketOrderbookData(orderCurrency: "BTC")
        getWebsocketTransactionData(orderCurrency: "BTC")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.scrollToCenter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
           btsocketAPIService.disconnectAll()
           super.viewDidDisappear(animated)
       }
    
    override func render() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configUI() {
        configStackView()
    }
    
    // MARK: - custom funcs
    
    func configStackView() {
        let leftStackView = UIStackView(arrangedSubviews: [
            sellGraphTableViewController.view,
            coinSecondInformationView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 1
            $0.distribution = .fillEqually
        }
        
        let rightStackView = UIStackView(arrangedSubviews: [
            coinFirstInformationView,
            buyGraphTableViewController.view
        ]).then {
            $0.axis = .vertical
            $0.spacing = 1
            $0.distribution = .fillEqually
        }
        
        let wholeStackView = UIStackView(arrangedSubviews: [
            leftStackView,
            quoteTableViewController.view,
            rightStackView
        ]).then {
            $0.axis = .horizontal
            $0.spacing = 1
        }
        
        self.scrollView.addSubview(wholeStackView)
        wholeStackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
            make.height.equalTo(2100)
        }
        
        leftStackView.snp.makeConstraints { make in
            make.width.equalTo(wholeStackView).multipliedBy(0.35)
        }
        
        rightStackView.snp.makeConstraints { make in
            make.width.equalTo(wholeStackView).multipliedBy(0.33)
        }
    }
    
    private func getOrderbookData(orderCurrency: String, paymentCurrency: String) {
        Task {
            do {
                let orderBookData = try await orderbookAPIService.getOrderbookData(orderCurrency: orderCurrency,
                                                                                   paymentCurrency: paymentCurrency)
                
                if let orderBookData = orderBookData {
                    self.asksList = orderBookData.asks
                    self.bidsList = orderBookData.bids
                } else {
                    // TODO: 에러 처리 얼럿 띄우기
                }
                self.patchOrderbookData()
            } catch HttpServiceError.serverError {
                print("serverError")
            } catch HttpServiceError.clientError(let message) {
                print("clientError:\(message)")
            }
        }
    }
    
    private func getWebSocketOrderbookData(orderCurrency: String) {
        btsocketAPIService.subscribeOrderBook(
            orderCurrency: [Coin.BTC],
            paymentCurrency: .krw)
        { response in
            self.updateOrderbookData(coin: Coin.BTC, data: response)
        }
    }
    
    private func getWebsocketTransactionData(orderCurrency: String) {
        btsocketAPIService.subscribeTransaction(
            orderCurrency: [Coin.BTC],
            paymentCurrency: .krw
        ) { response in
            self.updateTransactionData(coin: Coin.BTC, data: response)
        }
    }
    
    private func updateOrderbookData(coin: Coin, data: BTSocketAPIResponse.OrderBookResponse) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .background).async {
            for content in data.content.list {
                let quote = Quote(price: Int(content.price),
                                  quantity: content.quantity)
                switch content.orderType {
                case .ask:
                    if Double(quote.quantity) == 0 {
                        self.removeQuantityIsZero(type: .ask, data: quote)
                        continue
                    }
                    if !self.replaceQuote(type: .ask, data: quote) {
                        self.asksList.append(quote)
                    }
                    self.sortQuoteList(type: .ask)
                case .bid:
                    if Double(quote.quantity) == 0 {
                        self.removeQuantityIsZero(type: .bid, data: quote)
                        continue
                    }
                    if !self.replaceQuote(type: .bid, data: quote) {
                        self.bidsList.append(quote)
                    }
                    self.sortQuoteList(type: .bid)
                }
            }
            DispatchQueue.main.async {
                self.patchOrderbookData()
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    private func updateTransactionData(coin: Coin,
                                       data: BTSocketAPIResponse.TransactionResponse) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .background).async {
            for transaction in data.content.list {
                switch transaction.buySellGb {
                case .sell:
                    var count = self.asksList.count
                    var index = 0
                    while(index < count) {
                        if Double(self.asksList[index].price) == Double(transaction.contPrice)
                            && Double(self.asksList[index].quantity)! - transaction.contQty == 0 {
                            self.asksList.remove(at: index)
                            count -= 1
                        }
                        index += 1
                    }
                case .buy:
                    var count = self.asksList.count
                    var index = 0
                    while(index < count) {
                        if Double(self.bidsList[index].price) == Double(transaction.contPrice) {
                            if Double(self.bidsList[index].quantity)! - transaction.contQty == 0 {
                                self.bidsList.remove(at: index)
                                count -= 1
                            }
                        }
                        index += 1
                    }
                }
            }
            DispatchQueue.main.async {
                self.patchOrderbookData()
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    private func sortQuoteList(type: BTSocketAPIResponse.OrderBookResponse.Content.OrderBook.OrderType) {
        switch type {
        case .ask:
            self.asksList = asksList.sorted(by: {$0.price > $1.price})
        case .bid:
            self.bidsList = bidsList.sorted(by: {$0.price > $1.price})
        }
    }
    
    private func removeQuantityIsZero(type: BTSocketAPIResponse.OrderBookResponse.Content.OrderBook.OrderType,
                                      data: Quote) {
        switch type {
        case .ask:
            var count = self.asksList.count
            var index = 0
            while(index < count) {
                if Int(asksList[index].price) == Int(data.price) {
                    self.asksList.remove(at: index)
                    count -= 1
                }
                index += 1
            }
        case .bid:
            var count = self.bidsList.count
            var index = 0
            while(index < count) {
                if Int(bidsList[index].price) == Int(data.price) {
                    self.bidsList.remove(at: index)
                    count -= 1
                }
                index += 1
            }
        }
    }
    
    private func replaceQuote(type: BTSocketAPIResponse.OrderBookResponse.Content.OrderBook.OrderType,
                              data: Quote) -> Bool {
        switch type {
        case .ask:
            let count = self.asksList.count
            var index = 0
            while(index < count) {
                if Int(asksList[index].price) == Int(data.price) {
                    self.asksList[index] = data
                    return true
                }
                index += 1
            }
        case .bid:
            let count = self.bidsList.count
            for index in 0..<count {
                if Int(self.bidsList[index].price) == Int(data.price) {
                    self.bidsList[index] = data
                    return true
                }
            }
        }
        return false
    }
    
    private func patchOrderbookData() {
        self.quoteTableViewController.setQuoteData(asks: self.asksList,
                                                   bids: self.bidsList)
        self.quoteTableViewController.tableView.reloadData()
        
        self.sellGraphTableViewController.setQuoteData(asks: self.asksList)
        self.sellGraphTableViewController.tableView.reloadData()
        
        self.buyGraphTableViewController.setQuoteData(bids: self.bidsList)
        self.buyGraphTableViewController.tableView.reloadData()
    }
}
