//
//  CoinGraphTabViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

class CandleStickChartTabViewController: BaseViewController {
    private let btCandleStickRepository: BTCandleStickRepository = BTCandleStickRepository()
    private let btCandleStickApiService: BTCandleStickAPIService = BTCandleStickAPIService()
    
    private let orderCurrency: String = "BTC"
    private var interval: BTCandleStickChartInterval = ._1m
    private let intervalButtons: [IntervalButton] = [
        IntervalButton(interval: ._1m).then { $0.titleLabel?.text = "1분" },
        IntervalButton(interval: ._3m).then { $0.titleLabel?.text = "3분" },
        IntervalButton(interval: ._5m).then { $0.titleLabel?.text = "5분" },
        IntervalButton(interval: ._10m).then { $0.titleLabel?.text = "10분" },
        IntervalButton(interval: ._30m).then { $0.titleLabel?.text = "30분" },
        IntervalButton(interval: ._1h).then { $0.titleLabel?.text = "1시간" },
        IntervalButton(interval: ._6h).then { $0.titleLabel?.text = "6시간" },
        IntervalButton(interval: ._12h).then { $0.titleLabel?.text = "12시간" },
        IntervalButton(interval: ._24h).then { $0.titleLabel?.text = "24시간" },
    ]
    private var candleSticks: [BTCandleStick] = []
    
    private let candleStickChardView: CandleStickChartView = CandleStickChartView(with: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(candleStickChardView)
        candleStickChardView.snp.makeConstraints { make in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        }
        Task { await self.fetchInitialData() }
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        configUI()
    }
    
    override func configUI() {
        let buttonStackView = UIStackView(arrangedSubviews: self.intervalButtons).then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 3
        }
        buttonStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        let entireStackView = UIStackView(
            arrangedSubviews: [buttonStackView, self.candleStickChardView]
        ).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 3
        }
        self.view.addSubview(entireStackView)
        entireStackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaInsets).inset(UIEdgeInsets(top: 100, left: 10, bottom: 10, right: 10))
        }
    }

    private func fetchInitialData() async {
        // [최신~~과거]
        let fromAPI: [BTCandleStickResponse] = await self.btCandleStickApiService.requestCandleStick(
            of: orderCurrency, interval: interval
        )
            .sorted { $0.date < $1.date }
        // [최신~~과거]
        let fromCoreData: [BTCandleStick] = self.btCandleStickRepository.findAllBTCandleSticksOrderByDateAsc(
            orderCurrency: self.orderCurrency,
            chartIntervals: self.interval
        )
        // 코어데이터에 저장된게 없을 경우는 응답된걸 그대로 씀
        guard !fromCoreData.isEmpty else {
            let transformed: [BTCandleStick] = self.transform(from: fromAPI)
            self.setCandleStickToChart(of: transformed)
            return
        }
        combineData(coreData: fromCoreData, apiData: fromAPI)
    }
    
    @objc private func refreshData() {
        Task {
            let fromAPI: [BTCandleStickResponse] = await self.btCandleStickApiService.requestCandleStick(
                of: orderCurrency, interval: interval
            )
                .sorted { $0.date > $1.date }
            combineData(coreData: self.candleSticks, apiData: fromAPI)
            self.btCandleStickRepository.saveContext()
        }
    }
    
    private func combineData(coreData: [BTCandleStick], apiData: [BTCandleStickResponse]) {
        // 코어데이터에 저장된게 있을 경우는 API와 코어데이터가 연속된 값인지 확인함
        let latestFromCoreData: BTCandleStick = coreData[0]
        let recentDataFilteredFromApi: [BTCandleStickResponse] = apiData.filter { $0.date >= latestFromCoreData.date }
        // 다 최신값이면 DB 다 지워주고 새걸로 채워놓아줌
        if recentDataFilteredFromApi.count == apiData.count {
            coreData.forEach { self.btCandleStickRepository.delete(of: $0) }
            let transformed: [BTCandleStick] = self.transform(from: apiData)
            self.setCandleStickToChart(of: transformed)
            return
        }
        // 아니라면 코어데이터 최신값 하나 지워주고 필터링된걸로 다 새로 넣어줌
        self.btCandleStickRepository.delete(of: latestFromCoreData)
        let transformed: [BTCandleStick] = self.transform(from: recentDataFilteredFromApi)
        let combined: [BTCandleStick] = transformed + coreData[1..<coreData.count]
        setCandleStickToChart(of: combined)
    }
    
    private func transform(from apiData: [BTCandleStickResponse]) -> [BTCandleStick] {
        return apiData.map { candleStickResponse in
            guard let newObject = self.btCandleStickRepository.makeNewBTCandleStick() else {
                return BTCandleStick()
            }
            candleStickResponse.copy(to: newObject, orderCurrency: self.orderCurrency, chartIntervals: self.interval.rawValue)
            return newObject
        }
    }
    
    private func setCandleStickToChart(of candleSticks: [BTCandleStick]) {
        self.candleSticks = candleSticks
        let transformed: [CandleStickChartView.CandleStick] = candleSticks.map { btCandleStick in
            CandleStickChartView.CandleStick(
                date: Date(timeIntervalSince1970: Double(btCandleStick.date/1000)),
                openingPrice: btCandleStick.openingPrice,
                highPrice: btCandleStick.highPrice,
                lowPrice: btCandleStick.lowPrice,
                tradePrice: btCandleStick.tradePrice,
                tradeVolume: btCandleStick.tradeVolume
            )
        }.sorted { $0.date < $1.date } // 과거~최신순으로 뒤집어 줌
        self.candleStickChardView.updateCandleSticks(of: transformed)
    }
}
