//
//  CoinViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

final class CoinViewController: BaseViewController {
    
    // MARK: - Instance Property
    
    var coin: Coin = .BTC {
        didSet {
            self.pageViewController.coin = self.coin
        }
    }
    
    private let tickerAPIService = TickerAPIService(apiService: HttpService(),
                                                    environment: .development)
    var btsocketAPIService: BTSocketAPIService = BTSocketAPIService()
    
    private var tickerData: Item?
    
    let sectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    private let headerView = CoinHeaderView()
    
    let quoteButton = UIButton().then {
        $0.setTitle("호가", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .headline)
    }
    
    let graphButton = UIButton().then {
        $0.setTitle("차트", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .headline)
    }
    
    let contractDetailsButton = UIButton().then {
        $0.setTitle("시세", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .headline)
    }
    
    private let indicatorView = UIView().then {
        $0.backgroundColor = UIColor(named: "primaryBlack")
    }
    
    private var starBarButton = UIBarButtonItem()
    private var arrowBarButton = UIBarButtonItem()
    private let starButton = UIButton().then {
        guard let starImage: UIImage = UIImage(named: "notFillStar") else { return }
        $0.setImage(starImage, for: .normal)
    }
    private let arrowButton = UIButton().then {
        guard let starImage: UIImage = UIImage(named: "arrow") else { return }
        $0.setImage(starImage, for: .normal)
    }
    
    private let pageView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var pageViewController: CoinPagingViewController = CoinPagingViewController()
    
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPageView()
        self.getTickerData(orderCurrency: "BTC", paymentCurrency: "KRW")
        self.getWebsocketTickerData(orderCurrency: "BTC")
        self.patchHeaderViewData()
        self.patchStarButton()
    }
    
    override func render() {
        self.view.addSubViews([headerView, pageView])
    }
    
    override func configUI() {
        super.configUI()
        self.configStackView()
        self.configMenuButtons()
        self.configNavigation()
    }
    
    
    // MARK: - custom func
    
    private func configStackView() {
        let menuStackView: UIStackView = UIStackView(
            arrangedSubviews: [self.quoteButton, self.graphButton, self.contractDetailsButton]
        ).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 1
        }
        
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [self.headerView, menuStackView, self.pageView]
        ).then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.spacing = 1
        }
        
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configMenuButtons() {
        self.graphButton.addTarget(self, action: #selector(self.tapGraphButton), for: .touchUpInside)
        self.setBottomBorder(to: self.graphButton)
        
        self.contractDetailsButton.addTarget(self, action: #selector(self.tapContractDetailsButton), for: .touchUpInside)
        self.setBottomBorder(to: self.contractDetailsButton)
        
        self.quoteButton.addTarget(self, action: #selector(self.tapQuoteButton), for: .touchUpInside)
        self.setBottomBorder(to: self.quoteButton)
    }
    
    private func configNavigation() {
        self.navigationItem.titleView = CoinNavigationTitleView()
        
        self.starBarButton = UIBarButtonItem(customView: self.starButton)
        self.navigationItem.rightBarButtonItem = starBarButton
        self.starButton.addTarget(self, action: #selector(tapStarButton), for: .touchUpInside)
        
        self.arrowBarButton = UIBarButtonItem(customView: self.arrowButton)
        self.navigationItem.leftBarButtonItem = arrowBarButton
        self.arrowButton.addTarget(self, action: #selector(self.tapBackButton), for: .touchUpInside)
    }
    
    private func setPageView() {
        self.addChild(pageViewController)
        self.pageView.addSubview(pageViewController.view)
        self.pageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.pageView)
        }
        pageViewController.didMove(toParent: self)
    }
    
    private func setBottomBorder(to button: UIButton) {
        self.indicatorView.removeFromSuperview()
        button.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(3)
        }
    }
    
    private func getTickerData(orderCurrency: String, paymentCurrency: String) {
        Task {
            do {
                let tickerData = try await tickerAPIService.getOneTickerData(orderCurrency: orderCurrency,
                                                                             paymentCurrency: paymentCurrency)
                if let tickerData = tickerData {
                    self.tickerData = tickerData
                } else {
                    // TODO: 에러 처리 얼럿 띄우기
                }
                self.patchHeaderViewData()
            } catch HttpServiceError.serverError {
                print("serverError")
            } catch HttpServiceError.clientError(let message) {
                print("clientError:\(message)")
            }
        }
    }
    
    private func getWebsocketTickerData(orderCurrency: String) {
        btsocketAPIService.subscribeTicker(
            orderCurrency: [Coin.BTC],
            paymentCurrency: .krw,
            tickTypes: [._24h]
        ) { response in
            self.updateHeaderViewTickerData(coin: Coin.BTC, data: response)
        }
    }
    
    private func patchHeaderViewData() {
        guard let tickerData = self.tickerData else { return }
        self.headerView.patchData(data: CoinHeaderModel(currentPrice: tickerData.closingPrice,
                                                        fluctate: tickerData.fluctate24H,
                                                        fluctateRate: tickerData.fluctateRate24H))
    }
    
    private func updateHeaderViewTickerData(coin: Coin, data: BTSocketAPIResponse.TickerResponse) {
        self.headerView.patchData(data: CoinHeaderModel(currentPrice: "\(data.content.closePrice)",
                                                        fluctate: "\(data.content.chgAmt)",
                                                        fluctateRate: "\(data.content.chgRate)"))
    }
    
    private func patchStarButton() {
        if let alreadyInterestedCoin = UserDefaults.standard.string(forKey: "BTC") {
            self.starButton.setImage(UIImage(named: "fillStar"), for: .normal)
        }
        else {
            self.starButton.setImage(UIImage(named: "notFillStar"), for: .normal)
        }
    }
    
    
    // MARK: - @objc
    
    @objc private func tapQuoteButton(sender: UIButton) {
        self.setBottomBorder(to: self.quoteButton)
        self.pageViewController.setTabViewController(to: .quote)
    }
    
    @objc private func tapGraphButton() {
        self.setBottomBorder(to: self.graphButton)
        self.pageViewController.setTabViewController(to: .graph)
    }
    
    @objc private func tapContractDetailsButton() {
        self.setBottomBorder(to: self.contractDetailsButton)
        self.pageViewController.setTabViewController(to: .contractDetails)
    }
    
    @objc private func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapStarButton() {
        if let alreadyInterestedCoin = UserDefaults.standard.string(forKey: "BTC") {
            UserDefaults.standard.removeObject(forKey: alreadyInterestedCoin)
            self.starButton.setImage(UIImage(named: "notFillStar"), for: .normal)
        }
        else {
            UserDefaults.standard.set("BTC", forKey: "BTC")
            self.starButton.setImage(UIImage(named: "fillStar"), for: .normal)
        }
    }
}
