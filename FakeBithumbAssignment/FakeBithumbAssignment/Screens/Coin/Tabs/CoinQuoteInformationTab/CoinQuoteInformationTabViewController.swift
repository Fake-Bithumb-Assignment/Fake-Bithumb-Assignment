//
//  CoinQuoteInformationTabViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

class CoinQuoteInformationTabViewController: BaseViewController, CoinAcceptable {
    
    // MARK: - Instance Property
    
    var orderCurrenty: Coin = .BTC
    private let orderbookAPIService: OrderbookAPIService = OrderbookAPIService()
    private var btsocketAPIService: SocketAPIService = SocketAPIService()
    private let tickerAPIService: TickerAPIService = TickerAPIService()
    private var askQuotes: [String: Quote] = [:] {
        didSet {
            self.updateAsk()
        }
    }
    private var bidQuotes: [String: Quote] = [:] {
        didSet {
            self.updateBid()
        }
    }
    private var prevClosePrice: Double? = nil {
        didSet {
            self.updateAsk()
            self.updateBid()
        }
    }
    private var transactionPrice: String? = nil {
        didSet {
            self.updateAsk()
            self.updateBid()
        }
    }
    private let askTableView: OrderBookTableView = OrderBookTableView().then {
        $0.type = .ask
    }
    private let bidTableView: OrderBookTableView = OrderBookTableView().then {
        $0.type = .bid
    }
    private let coinFirstInformationView: CoinCompactInformationView = CoinCompactInformationView()
    private let coinSecondInformationView: CoinCompactInformationView = CoinCompactInformationView()
    private let scrollView = UIScrollView().then { make in
        make.backgroundColor = .white
    }
    private let minimumDouble: Double = 0.00001
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchOrderBookFromAPI()
        self.fetchOrderBookFromSocket()
        self.fetchTickerFromAPI()
        self.fetchTickerFromSocket()
        self.fetchTransactionFromSocket()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.scrollToCenter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.btsocketAPIService.disconnectAll()
        self.reset()
        super.viewDidDisappear(animated)
    }
    
    // MARK: - custom funcs
    
    func accept(of coin: Coin) {
        self.orderCurrenty = coin
    }
    
    private func reset() {
        self.bidQuotes.removeAll()
        self.askQuotes.removeAll()
    }
    
    private func updateAsk() {
        let askQuotes: [Quote] = Array(askQuotes.values).filter {
            $0.quantityNumber >= self.minimumDouble
        }.map {
            var quote = $0
            quote.prevClosePrice = self.prevClosePrice
            quote.transactionPrice = self.transactionPrice
            return quote
        }
        self.askTableView.updatedQuotes(to: askQuotes)
    }
    
    private func updateBid() {
        let bidQuotes: [Quote] = Array(bidQuotes.values).filter {
            $0.quantityNumber >= self.minimumDouble
        }.map {
            var quote = $0
            quote.prevClosePrice = self.prevClosePrice
            quote.transactionPrice = self.transactionPrice
            return quote
        }
        self.bidTableView.updatedQuotes(to: bidQuotes)
    }
    
    override func configUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        let firstInformationStackView: UIStackView = UIStackView(
            arrangedSubviews: [UIView(), self.coinFirstInformationView]
        ).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        self.coinFirstInformationView.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
        let upperStackView = UIStackView(arrangedSubviews: [
            self.askTableView, firstInformationStackView
        ]).then {
            $0.axis = .horizontal
        }
        self.coinFirstInformationView.snp.makeConstraints { make in
            make.width.equalTo(upperStackView).multipliedBy(1.0/3.0)
        }
        let secondInformationStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.coinSecondInformationView, UIView()]
        ).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        self.coinSecondInformationView.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
        let lowerStackView = UIStackView(arrangedSubviews: [
            secondInformationStackView, self.bidTableView,
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
    
    private func fetchOrderBookFromAPI() {
        Task {
            do {
                guard let orderBookResponse: OrderbookAPIResponse = try await self.orderbookAPIService.getOrderbookData(
                    orderCurrency: String(describing: self.orderCurrenty),
                    paymentCurrency: "KRW"
                )
                else {
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
    
    private func fetchOrderBookFromSocket() {
        self.btsocketAPIService.subscribeOrderBook(
            orderCurrency: [self.orderCurrenty],
            paymentCurrency: .krw
        ) {
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
    
    private func fetchTickerFromSocket() {
        Task {
            do {
                guard let ticker: Item = try await self.tickerAPIService.getOneTickerData(
                    orderCurrency: String(describing: self.orderCurrenty)
                )
                else {
                    return
                }
                self.prevClosePrice = Double(ticker.prevClosingPrice)
            } catch {
                //TODO: do something
                print(error)
            }
        }
        self.btsocketAPIService.subscribeTicker(
            orderCurrency: [self.orderCurrenty],
            paymentCurrency: .krw,
            tickTypes: [.mid]
        ) { ticker in
            self.prevClosePrice = ticker.content.prevClosePrice
        }
    }
    
    private func fetchTickerFromAPI() {
        Task {
            guard let response = try await self.tickerAPIService.getOneTickerData(
                orderCurrency: String(describing: self.orderCurrenty)
            ) else {
                return
            }
            let firstInformation: [CoinInformation.Row] = [
                CoinInformation.Row(
                    title: "거래량",
                    value: Double(response.unitsTraded) ?? 0.0,
                    color: .lightGray
                ),
                CoinInformation.Row(
                    title: "거래금",
                    value: Double(response.accTradeValue) ?? 0.0,
                    color: .lightGray
                ),
                CoinInformation.Row.line,
                CoinInformation.Row(
                    title: "시가",
                    value: Double(response.openingPrice) ?? 0.0,
                    color: .lightGray
                ),
                CoinInformation.Row(
                    title: "고가",
                    value: Double(response.maxPrice) ?? 0.0,
                    color: UIColor(named: "up") ?? .red
                ),
                CoinInformation.Row(
                    title: "저가",
                    value: Double(response.minPrice) ?? 0.0,
                    color: UIColor(named: "down") ?? .blue
                )
            ]
            self.coinFirstInformationView.informtion = CoinInformation(rows: firstInformation)
            let secondInformation: [CoinInformation.Row] = [
                CoinInformation.Row(
                    title: "거래량24",
                    value: Double(response.unitsTraded24H) ?? 0.0,
                    color: .lightGray
                ),
                CoinInformation.Row(
                    title: "거래금24",
                    value: Double(response.accTradeValue24H) ?? 0.0,
                    color: .lightGray
                ),
                CoinInformation.Row.line,
                CoinInformation.Row(
                    title: "변동가24",
                    value: Double(response.fluctate24H) ?? 0.0,
                    color: .lightGray
                ),
                CoinInformation.Row(
                    title: "변동률24",
                    value: Double(response.fluctateRate24H) ?? 0.0,
                    color: .lightGray
                ),
                CoinInformation.Row(
                    title: "전일종가",
                    value: Double(response.prevClosingPrice) ?? 0.0,
                    color: .lightGray
                )
            ]
            self.coinSecondInformationView.informtion = CoinInformation(rows: secondInformation)
        }
    }
    
    private func fetchTransactionFromSocket() {
        self.btsocketAPIService.subscribeTransaction(
            orderCurrency: [self.orderCurrenty],
            paymentCurrency: .krw
        ) { response in
            guard !response.content.list.isEmpty else {
                return
            }
            self.transactionPrice = response.content.list[0].contPriceString
        }
    }
}
