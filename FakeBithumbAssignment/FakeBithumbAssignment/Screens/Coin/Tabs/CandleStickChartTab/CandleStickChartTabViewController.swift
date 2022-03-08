//
//  CoinGraphTabViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

class CandleStickChartTabViewController: BaseViewController {
    
    // MARK: - Instance Property

    private let btCandleStickRepository: BTCandleStickRepository = BTCandleStickRepository()
    private let btCandleStickApiService: BTCandleStickAPIService = BTCandleStickAPIService()
    private var orderCurrency: String? = "BTC"
    private var interval: BTCandleStickChartInterval = ._1m
    private let intervalButtons: [IntervalButton] = [
        IntervalButton(title: "1분", interval: ._1m),
        IntervalButton(title: "3분",interval: ._3m),
        IntervalButton(title: "5분",interval: ._5m),
        IntervalButton(title: "10분",interval: ._10m),
        IntervalButton(title: "30분",interval: ._30m),
        IntervalButton(title: "1시간",interval: ._1h),
        IntervalButton(title: "6시간",interval: ._6h),
        IntervalButton(title: "12시간",interval: ._12h),
        IntervalButton(title: "24시간",interval: ._24h)
    ]
    /// 현재 화면에 표시 될 candleStick들을 전부 가지고 있어야 함. Core Data와 동기화 되어야 함
    /// 인덱스 0이 최신의 것임
    private var candleSticks: [BTCandleStick] = []
    private let candleStickChartView: CandleStickChartView = CandleStickChartView(with: [])
    
    // MARK: - Life Cycle func
    
    override func viewDidDisappear(_ animated: Bool) {
        self.btCandleStickRepository.saveContext()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.configButtonTarget()
        Task { await self.fetchInitialData() }
        Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(refreshData),
            userInfo: nil,
            repeats: true
        )
    }
    
    // MARK: - custom func
    
    func setOrderCurrency(of orderCurrency: String) {
        self.orderCurrency = orderCurrency
        self.candleSticks = []
        self.candleStickChartView.reset()
        Task { await self.fetchInitialData() }
    }
    
    override func configUI() {
        self.view.backgroundColor = UIColor.white
        let buttonStackView = UIStackView(arrangedSubviews: self.intervalButtons).then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 3
        }
        buttonStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        let entireStackView = UIStackView(
            arrangedSubviews: [buttonStackView, self.candleStickChartView]
        ).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 10
        }
        self.view.addSubview(entireStackView)
        entireStackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
    }
    
    private func configButtonTarget() {
        self.intervalButtons.forEach {
            $0.addTarget(self, action: #selector(intervalSelected(_:)), for: .touchUpInside)
        }
    }
}

extension CandleStickChartTabViewController {
    /// 버튼이 선택되었을 때 interval을 변경하고 새로운 데이터를 받아와 뷰에 적용 해준다.
    @objc func intervalSelected(_ sender: UIButton) {
        guard let intervalButton: IntervalButton = sender as? IntervalButton else {
            return
        }
        self.candleStickChartView.reset()
        self.candleSticks = []
        self.interval = intervalButton.interval
        self.refreshData()
    }

    /// rest api로 데이터 받아오고, Core Data에 있는것과 연속되도록 합쳐주는 메소드.
    /// 연속되지 않을 경우 rest api의 값만 사용함.
    private func fetchInitialData() async {
        guard let orderCurrency: String = self.orderCurrency else {
            return
        }
        let fromAPI: [BTCandleStickResponse] = await self.btCandleStickApiService.requestCandleStick(
            of: orderCurrency, interval: interval
        )
        let fromCoreData: [BTCandleStick] = self.btCandleStickRepository.findAllBTCandleSticksOrderByDateAsc(
            orderCurrency: orderCurrency,
            chartIntervals: self.interval
        )
        combineData(coreData: fromCoreData, apiData: fromAPI)
    }
    
    /// 새로운 데이터를 받아오는 메소드.
    /// rest api로 새로운 데이터 받아온 뒤에 현재 쓰이고 있는 데이터와 합쳐준다.
    @objc private func refreshData() {
        guard let orderCurrency: String = self.orderCurrency else {
            return
        }
        Task {
            let fromAPI: [BTCandleStickResponse] = await self.btCandleStickApiService.requestCandleStick(
                of: orderCurrency,
                interval: self.interval
            )
            combineData(coreData: self.candleSticks, apiData: fromAPI)
        }
    }
    
    /// Core Data + rest api response를 연속되도록 합쳐주는 메소드.
    /// 이것이 끝나고 차트에 데이터를 넣어준다.
    private func combineData(coreData: [BTCandleStick], apiData: [BTCandleStickResponse]) {
        guard !apiData.isEmpty else {
            self.setCandleStickToChart(of: coreData)
            return
        }
        guard !coreData.isEmpty else {
            self.setCandleStickToChart(of: self.transform(from: apiData))
            return
        }
        guard let latestFromCoreData: BTCandleStick = coreData.first else { return }
        guard let latestFromApIData: BTCandleStickResponse = apiData.first else { return }
        guard let oldFromAPI: BTCandleStickResponse = apiData.last else { return }
        
        // api의 제일 최신값이 더 최신값이여야 함
        guard latestFromCoreData.date <= latestFromApIData.date else {
            self.setCandleStickToChart(of: coreData)
            return
        }
        // 연속되지 않는다면 코어데이터 다 삭제 후 api만 사용
        if oldFromAPI.date > latestFromCoreData.date {
            coreData.forEach { self.btCandleStickRepository.delete(of: $0) }
            self.setCandleStickToChart(of: self.transform(from: apiData))
            return
        }
        // 연속된다면 겹치는부분은 api가 우선
        coreData.filter {
            $0.date >= oldFromAPI.date
        }.forEach {
            self.btCandleStickRepository.delete(of: $0)
        }
        let combinedResult: [BTCandleStick] = self.transform(from: apiData) +
        coreData.filter { $0.date < oldFromAPI.date }
        self.setCandleStickToChart(of: combinedResult)
    }
    
    /// api response -> Core Data entity model로 변환해주는 메소드
    private func transform(from apiData: [BTCandleStickResponse]) -> [BTCandleStick] {
        guard let orderCurrency: String = self.orderCurrency else {
            return []
        }
        return apiData.map { candleStickResponse in
            guard let newObject = self.btCandleStickRepository.makeNewBTCandleStick() else {
                return BTCandleStick()
            }
            candleStickResponse.copy(
                to: newObject,
                orderCurrency: orderCurrency,
                chartIntervals: self.interval.rawValue
            )
            return newObject
        }
    }
    
    /// 뷰에 데이터를 넣어주는 메소드
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
        }.sorted { $0.date < $1.date }
        self.candleStickChartView.updateCandleSticks(of: transformed)
    }
}
