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
    
    /// 매도. 가격이 키
    var askQuotes: [String: Quote] = [:]
    /// 매수. 가격이 키
    var bidQuotes: [String: Quote] = [:]
    /// 매도 테이블
    let askTableView: GraphTableView = GraphTableView().then {
        $0.type = .ask
    }
    /// 매수 테이블
    let bidTableView: GraphTableView = GraphTableView().then {
        $0.type = .bid
    }
    
    /// 오른쪽 위
    let coinFirstInformationView = CoinFirstInformationView()
    /// 왼쪽 아래
    let coinSecondInformationView = CoinSecondInformationView()
    
    /// 스크롤 뷰
    let scrollView = UIScrollView().then { make in
        make.backgroundColor = .white
    }
    
    // MARK: - Life Cycle func
    
    private func fetchFromAPI() {
        Task {
            do {
                guard let orderBookResponse: OrderbookAPIResponse = try await self.orderbookAPIService.getOrderbookData(
                    orderCurrency: String(describing: self.orderCurrenty),
                    paymentCurrency: "KRW"
                ) else {
                    return
                }
                orderBookResponse.bids.forEach { quote in
                    self.bidQuotes[quote.price] = quote
                }
                orderBookResponse.asks.forEach { quote in
                    self.askQuotes[quote.price] = quote
                }
                self.updateTableData()
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
                self.updateTableData()
            }
    }
    
    
    private func updateTableData() {
        self.askTableView.updatedQuotes(
            to: Array(askQuotes.values).filter { $0.quantityNumber >= 0.0001 }
        )
        self.bidTableView.updatedQuotes(
            to: Array(bidQuotes.values).filter { $0.quantityNumber >= 0.0001 }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchFromAPI()
        self.fetchFromSocket()
//        getOrderbookData(orderCurrency: "BTC", paymentCurrency: "KRW")
//        getWebSocketOrderbookData(orderCurrency: "BTC")
//        getWebsocketTransactionData(orderCurrency: "BTC")
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
    
    // MARK: - custom funcs
    
    func configStackView() {
//        let leftStackView = UIStackView(arrangedSubviews: [
//            sellGraphTableViewController.view,
//            coinSecondInformationView
//        ]).then {
//            $0.axis = .vertical
//            $0.spacing = 1
//            $0.distribution = .fillEqually
//        }
//
//        let rightStackView = UIStackView(arrangedSubviews: [
//            coinFirstInformationView,
//            buyGraphTableViewController.view
//        ]).then {
//            $0.axis = .vertical
//            $0.spacing = 1
//            $0.distribution = .fillEqually
//        }
//
//        let wholeStackView = UIStackView(arrangedSubviews: [
//            leftStackView,
//            quoteTableViewController.view,
//            rightStackView
//        ]).then {
//            $0.axis = .horizontal
//            $0.spacing = 1
//        }
//
//        self.scrollView.addSubview(wholeStackView)
//        wholeStackView.snp.makeConstraints { make in
//            make.top.leading.bottom.trailing.equalTo(self.scrollView)
//            make.width.equalTo(self.scrollView)
//            make.height.equalTo(2100)
//        }
//
//        leftStackView.snp.makeConstraints { make in
//            make.width.equalTo(wholeStackView).multipliedBy(0.35)
//        }
//
//        rightStackView.snp.makeConstraints { make in
//            make.width.equalTo(wholeStackView).multipliedBy(0.33)
//        }
    }
}
