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
    private let orderCurrency: String = "BTC"
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
    private var candleSticks: [BTCandleStick] = []
    private let candleStickChardView: CandleStickChartView = CandleStickChartView(with: [])
    
    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.configButtonTarget()
        Task { await self.fetchInitialData() }
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
    }
    
    // MARK: - custom func
    
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
            arrangedSubviews: [buttonStackView, self.candleStickChardView]
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
        print(intervalButton)
        self.candleSticks = []
        self.interval = intervalButton.interval
        self.refreshData()
    }

    /// rest api로 데이터 받아오고, Core Data에 있는것과 연속되도록 합쳐주는 메소드.
    /// 연속되지 않을 경우 rest api의 값만 사용함.
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
        combineData(coreData: fromCoreData, apiData: fromAPI)
    }
    
    /// 새로운 데이터를 받아오는 메소드.
    /// rest api로 새로운 데이터 받아온 뒤에 현재 쓰이고 있는 데이터와 합쳐준다.
    @objc private func refreshData() {
        Task {
            let fromAPI: [BTCandleStickResponse] = await self.btCandleStickApiService.requestCandleStick(
                of: self.orderCurrency,
                interval: self.interval
            )
                .sorted { $0.date > $1.date }
            combineData(coreData: self.candleSticks, apiData: fromAPI)
        }
    }
    
    /// Core Data + rest api response를 연속되도록 합쳐주는 메소드.
    /// 이것이 끝나고 차트에 데이터를 넣어준다.
    private func combineData(coreData: [BTCandleStick], apiData: [BTCandleStickResponse]) {
        // 코어데이터에 저장된게 있을 경우는 API와 코어데이터가 연속된 값인지 확인함
        guard let latestFromCoreData: BTCandleStick = coreData.last else {
            // 코어데이터에 저장된게 없을 경우에는 api데이터만 사용
            self.setCandleStickToChart(of: self.transform(from: apiData))
            return
        }
        let recentDataFilteredFromApi: [BTCandleStickResponse] = apiData.filter {
            $0.date >= latestFromCoreData.date
        }
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
        let combined: [BTCandleStick] = coreData[0..<coreData.count-1] + transformed
        setCandleStickToChart(of: combined)
    }
    
    /// api response -> Core Data entity model로 변환해주는 메소드
    private func transform(from apiData: [BTCandleStickResponse]) -> [BTCandleStick] {
        return apiData.map { candleStickResponse in
            guard let newObject = self.btCandleStickRepository.makeNewBTCandleStick() else {
                return BTCandleStick()
            }
            candleStickResponse.copy(to: newObject, orderCurrency: self.orderCurrency, chartIntervals: self.interval.rawValue)
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
        }.sorted { $0.date < $1.date } // 과거~최신순으로 정렬 해 줌
        self.candleStickChardView.updateCandleSticks(of: transformed)
    }
}
