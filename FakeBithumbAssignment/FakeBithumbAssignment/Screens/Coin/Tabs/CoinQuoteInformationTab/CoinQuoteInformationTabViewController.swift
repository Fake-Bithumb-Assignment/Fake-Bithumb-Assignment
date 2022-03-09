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
    
    let orderCurrenty: Coin = .BTC
    let orderbookAPIService: OrderbookAPIService = OrderbookAPIService(
        apiService: HttpService(),
        environment: .development
    )
    var btsocketAPIService: BTSocketAPIService = BTSocketAPIService()
    var askQuotes: [String: Quote] = [:] {
        didSet {
            self.askTableView.updatedQuotes(
                to: Array(askQuotes.values).filter { $0.quantityNumber >= 0.0001 }
            )
        }
    }
    var bidQuotes: [String: Quote] = [:] {
        didSet {
            self.bidTableView.updatedQuotes(
                to: Array(bidQuotes.values).filter { $0.quantityNumber >= 0.0001 }
            )
        }
    }
    let askTableView: GraphTableView = GraphTableView().then {
        $0.type = .ask
    }
    let bidTableView: GraphTableView = GraphTableView().then {
        $0.type = .bid
    }
    let coinFirstInformationView = CoinFirstInformationView()
    let coinSecondInformationView = CoinSecondInformationView()
    let scrollView = UIScrollView().then { make in
        make.backgroundColor = .white
    }
    
    // MARK: - Life Cycle func
            
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchFromAPI()
        self.fetchFromSocket()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.scrollToCenter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        btsocketAPIService.disconnectAll()
        self.reset()
        super.viewDidDisappear(animated)
    }
    
    // MARK: - custom funcs

    private func reset() {
        self.bidQuotes.removeAll()
        self.askQuotes.removeAll()
    }
    
    override func configUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        let upperStackView = UIStackView(arrangedSubviews: [
            self.askTableView, self.coinFirstInformationView
        ]).then {
            $0.axis = .horizontal
        }
        self.coinFirstInformationView.snp.makeConstraints { make in
            make.width.equalTo(upperStackView).multipliedBy(1.0/3.0)
        }
        let lowerStackView = UIStackView(arrangedSubviews: [
            self.coinSecondInformationView, self.bidTableView,
        ]).then {
            $0.axis = .horizontal
        }
        self.coinSecondInformationView.snp.makeConstraints { make in
            make.width.equalTo(lowerStackView).multipliedBy(1.0/3.0)
        }
        let wholeStackView = UIStackView(arrangedSubviews: [
            upperStackView, lowerStackView
        ]).then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
        }
        self.scrollView.addSubview(wholeStackView)
        self.view.addSubview(self.scrollView)
        wholeStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
            make.height.equalTo(2100)
        }
    }

    private func fetchFromAPI() {
        Task {
            do {
                guard let orderBookResponse: OrderbookAPIResponse = try await self.orderbookAPIService.getOrderbookData(
                    orderCurrency: String(describing: self.orderCurrenty),
                    paymentCurrency: "KRW"
                ) else {
                    return
                }
                var bidQuotes: [String: Quote] = [:]
                var askQuotes: [String: Quote] = [:]
                orderBookResponse.bids.forEach { quote in
                    bidQuotes[quote.price] = quote
                }
                orderBookResponse.asks.forEach { quote in
                    askQuotes[quote.price] = quote
                }
                self.bidQuotes = bidQuotes
                self.askQuotes = askQuotes
                self.scrollView.scrollToCenter()
            } catch {
                // TODO: do something
                print(error)
            }
        }
        
    }
    
    private func fetchFromSocket() {
        self.btsocketAPIService.subscribeOrderBook(
            orderCurrency: [self.orderCurrenty],
            paymentCurrency: .krw) {
                $0.content.list.forEach { response in
                    let newQuote: Quote = Quote(
                        price: response.price,
                        quantity: response.quantity
                    )
                    switch response.orderType {
                    case .ask:
                        self.askQuotes[newQuote.price] = newQuote
                    case .bid:
                        self.bidQuotes[newQuote.price] = newQuote
                    }
                }
            }
    }

}
