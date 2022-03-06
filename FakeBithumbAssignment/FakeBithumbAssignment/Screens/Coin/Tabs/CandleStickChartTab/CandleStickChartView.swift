//
//  CandleStickChartView.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/26.
//

import UIKit

import Then

class CandleStickChartViewLayers {
    /// 스크롤 뷰를 가득 채울 레이어
    let mainLayer: CALayer = CALayer()
    /// dateTimeLayer를 제외하고 실제 차트가 그려질 레이어 (스크롤에 포함)
    let dataLayer: CALayer = CALayer()
    /// 아래 날짜, 시간 영역을 그려 줄 레이어 (스크롤에 포함)
    let dateTimeLayer: CALayer = CALayer()
    /// 오른쪽 값 영역을 그려줄 레이어
    let valueLayer: CALayer = CALayer()
    /// 가로줄을 그려줄 레이어
    let horizontalGridLayer: CALayer = CALayer()
    /// 세로줄을 그려줄 레이어 (스크롤에 포함)
    let verticalGridLayer: CALayer = CALayer()
    /// 선택 가로선 레이어
    var focusHorizontalLayer: CAShapeLayer = CAShapeLayer()
    /// 선택 세로선 레이어
    var focusVerticalLayer: CAShapeLayer = CAShapeLayer()
    /// 선택 정보창 레이어
    let focusInfoLayer: CALayer = CALayer().then {
        $0.backgroundColor = UIColor.black.cgColor
        $0.opacity = 0.8
    }
    /// 선택 정보창 텍스트 레이어
    let focusInfoTextLayer: CALayer = CALayer()
}

class CandleStickChartViewSetting {
    /// 양봉 색상
    let redColor: CGColor = CGColor(red: 194/255, green: 72/255, blue: 79/255, alpha: 1.0)
    /// 음봉 색상
    let blueColor: CGColor = CGColor(red: 50/255, green: 93/255, blue: 202/255, alpha: 1.0)
    /// 기본 선 색상
    let defaultColor: CGColor = CGColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1.0)
    /// 그리드 선 색상
    let gridColor: CGColor = CGColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    /// 기본 선 너비
    let defaultLineWidth: CGFloat = 1.0
    /// 그리드 선 너비
    let gridWidth: CGFloat = 0.5
    /// 기본 텍스트 크기
    let defaultFontSize: CGFloat = 11.0
    /// 오른쪽 값 영역의 너비
    let valueWidth: CGFloat = 50.0
    /// 오른쪽 값 영역에 표시될 값의 개수
    let numbersOfValueInFrame: Int = 5
    /// 아래 날짜, 시간 영역의 높이
    let dateTimeHeight: CGFloat = 40.0
    /// 한 화면에 나올 날짜, 시간 레이블의 개수
    let numbersOfDateTimeInFrame: Int = 3
    /// 수치 표시할 때 튀어나온 선 길이
    let thornLength: CGFloat = 10.0
    /// 수치 표시할 때 튀어나온 선 - 수치 텍스트 간격
    let thornTextSpace: CGFloat = 5.0
    /// 날짜, 시간 레이블의 크기
    let defaultTextSize: CGSize = CGSize(width: 60.0, height: 20.0)
    /// 캔들스틱 너비
    var candleStickWidth: CGFloat = 5.0
    /// 확대 후 최대 캔들스틱 너비
    var maxCandleStickWidth: CGFloat = 20.0
    /// 축소 후 최소 캔들스틱 너비
    var minCandleStickWidth: CGFloat = 2.0
    /// 캔들스틱 얇은 선 너비
    var candleStickLineWidth: CGFloat = 1.5
    /// 캔들스틱 간격
    var candleStickSpace: CGFloat = 2.0
    /// 캔들스틱 차트 영역 위, 빈 공간 비율
    let verticalFrontRearSpaceRate: CGFloat = 0.1
    /// 그래프 맨앞, 맨 뒤의 빈 공간
    var horizontalFrontRearSpaceRatio: CGFloat = 3.0
    /// 선택 선 색상
    let focusLineColor: CGColor = UIColor.black.cgColor
    /// 선택 정보창 사이즈
    let focusInfoSize: CGSize = CGSize(width: 120.0, height: 120.0)
    /// 선택 정보창 바깥쪽 여백
    let focusInfoMargin: CGPoint = CGPoint(x: 10, y: 10)
    /// 선택 정보착 안쪽 여백
    let focusInfoPadding: CGPoint = CGPoint(x: 4, y: 4)
    /// 기본 날짜 포맷
    let defaultTimeFormatter = DateFormatter().then {
        $0.dateFormat = "M/d HH:mm"
    }
    /// 선택 정보창 날짜 포맷
    let infoTimeFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
}

class CandleStickChartView: UIView {
    
    // MARK: - instance property
    
    /// 스크롤 뷰
    private let scrollView: CandleStickScrollView = CandleStickScrollView().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    /// 레이어들
    private let layers: CandleStickChartViewLayers = CandleStickChartViewLayers()
    /// 설정값
    private let setting: CandleStickChartViewSetting = CandleStickChartViewSetting()
    
    /// 캔들스틱 값들
    private var candleSticks: [CandleStick] = []
    /// 현재 화면에 그려야 할 캔들스틱 인덱스 범위
    private var drawingTargetIndex: ClosedRange<Int> = (0...0)
    /// 현재 화면에 있는 캔들스틱 중 최고 가격
    private var maxPrice: Double = 0.0
    /// 현재 화면에 있는 캔들스틱 중 최저 가격
    private var minPrice: Double = 0.0
    
    /// 선택 모드인지 아닌지
    private var isFocusMode: Bool = false
    /// 처음으로 그려지는 상태인지?
    private var isInitialState: Bool = true
    
    // MARK: - Initializer
        
    init(with candleSticks: [CandleStick]) {
        self.candleSticks = candleSticks
        super.init(frame: .zero)
        self.scrollView.delegate = self
        self.scrollView.touchEventDelegate = self
        self.setupLayers()
        self.setupPinchGesture()
        self.setUpTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scrollView.delegate = self
        self.scrollView.touchEventDelegate = self
        self.setupLayers()
        self.setupPinchGesture()
        self.setUpTapGesture()
    }
    
    // MARK: - custom func
    
    func updateCandleSticks(of candleSticks: [CandleStick]) {
        DispatchQueue.main.async {
            self.candleSticks = candleSticks
            self.setNeedsLayout()
        }
    }
    
    private func setupPinchGesture() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    private func setUpTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func updateDrawingTargetIndex() {
        let contentOffset: CGPoint = self.scrollView.contentOffset
        let currentXRange = (contentOffset.x...(contentOffset.x + self.scrollView.bounds.width))
        let targetIndex = (0..<self.candleSticks.count).filter {
            currentXRange.contains(self.getXCoord(indexOf: $0))
        }
        guard let min = targetIndex.min(), let max = targetIndex.max() else {
            return
        }
        self.drawingTargetIndex = (min...max)
    }
    
    private func updateMaxMinPrice() {
        guard let maxIndex: Int = self.drawingTargetIndex.max(
            by: { self.candleSticks[$0].highPrice < self.candleSticks[$1].highPrice }
        ) else {
            return
        }
        guard let minIndex: Int = self.drawingTargetIndex.min(
            by: { self.candleSticks[$0].lowPrice < self.candleSticks[$1].lowPrice }
        ) else {
            return
        }
        self.maxPrice = self.candleSticks[maxIndex].highPrice
        self.minPrice = self.candleSticks[minIndex].lowPrice
    }
    
    private func setupLayers() {
        // 스크롤에 포함될 전체 영역인 mainLayer
        self.layers.mainLayer.addSublayer(self.layers.verticalGridLayer)
        self.layers.mainLayer.addSublayer(self.layers.dataLayer)
        self.layers.mainLayer.addSublayer(self.layers.dateTimeLayer)
        self.scrollView.layer.addSublayer(self.layers.mainLayer)
        // 가로줄, 값은 스크롤 되지 않음
        self.layer.addSublayer(self.layers.horizontalGridLayer)
        self.layer.addSublayer(self.layers.valueLayer)
        // subView로 추가
        self.addSubview(self.scrollView)
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        self.cleanLayers()
        self.setFrame()
        self.drawDivivisionLine()
        guard !self.candleSticks.isEmpty else {
            return
        }
        self.moveScrollIfInitialState()
        self.updateDrawingTargetIndex()
        self.updateMaxMinPrice()
        self.drawDateTime()
        self.drawValue()
        self.drawChart()
        CATransaction.commit()
    }
    
    private func moveScrollIfInitialState() {
        guard isInitialState && !self.candleSticks.isEmpty else {
            return
        }
        self.scrollView.contentOffset = CGPoint(
            x: self.scrollView.contentSize.width -
            self.scrollView.bounds.width / self.setting.horizontalFrontRearSpaceRatio -
            self.scrollView.bounds.width / 2.0,
            y: 0
        )
        self.isInitialState = false
    }
    
    private func setFrame() {
        let chartContentWidth: CGFloat = 2 * self.scrollView.bounds.width / self.setting.horizontalFrontRearSpaceRatio
        + CGFloat(self.candleSticks.count) * self.setting.candleStickWidth
        + (CGFloat(self.candleSticks.count) - 1) * self.setting.candleStickSpace
        let chartContentHeight: CGFloat = self.bounds.height - self.setting.dateTimeHeight
        
        self.scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.size.width - self.setting.valueWidth,
            height: self.bounds.size.height
        )
        self.scrollView.contentSize = CGSize(
            width: chartContentWidth,
            height: self.bounds.size.height
        )
        self.layers.mainLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: chartContentWidth,
            height: self.bounds.size.height
        )
        self.layers.dataLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: chartContentWidth,
            height: chartContentHeight
        )
        self.layers.dateTimeLayer.frame = CGRect(
            x: 0,
            y: chartContentHeight,
            width: chartContentWidth,
            height: self.setting.dateTimeHeight
        )
        self.layers.valueLayer.frame = CGRect(
            x: self.bounds.size.width - self.setting.valueWidth,
            y: 0,
            width: self.setting.valueWidth,
            height: chartContentHeight
        )
        self.layers.horizontalGridLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.size.width - self.setting.valueWidth,
            height: chartContentHeight
        )
        self.layers.verticalGridLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: chartContentWidth - self.setting.valueWidth,
            height: chartContentHeight
        )
    }
    
    private func cleanLayers() {
        self.layers.dataLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layers.dateTimeLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layers.valueLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layers.horizontalGridLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layers.verticalGridLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    private func drawChart() {
        self.drawingTargetIndex.forEach { index in
            let candleStick: CandleStick = candleSticks[index]
            let xCoord: CGFloat = getXCoord(indexOf: index)
            let color: CGColor = candleStick.type == .blue ? self.setting.blueColor : self.setting.redColor
            guard let openingPriceYCoord: CGFloat = self.getYCoord(of: candleStick.openingPrice) else {
                return
            }
            guard let highPriceYCoord: CGFloat = self.getYCoord(of: candleStick.highPrice) else {
                return
            }
            guard let lowPriceYCoord: CGFloat = self.getYCoord(of: candleStick.lowPrice) else {
                return
            }
            guard let tradePriceYCoord: CGFloat = self.getYCoord(of: candleStick.tradePrice) else {
                return
            }
            let lineLayer: CALayer = CALayer().then {
                $0.frame = CGRect(
                    x: xCoord - self.setting.candleStickLineWidth / 2,
                    y: highPriceYCoord,
                    width: self.setting.candleStickLineWidth,
                    height: lowPriceYCoord - highPriceYCoord
                )
                $0.backgroundColor = color
            }
            let rectLayer: CALayer = CALayer().then {
                $0.frame = CGRect(
                    x: xCoord - self.setting.candleStickWidth / 2,
                    y: min(openingPriceYCoord, tradePriceYCoord),
                    width: self.setting.candleStickWidth,
                    height: max(openingPriceYCoord, tradePriceYCoord) -
                    min(openingPriceYCoord, tradePriceYCoord)
                )
                $0.backgroundColor = color
            }
            self.layers.dataLayer.addSublayer(lineLayer)
            self.layers.dataLayer.addSublayer(rectLayer)
        }
    }
    
    private func drawDateTime() {
        // 몇개의 캔들스틱당 날짜 & 세로그리드를 그려 줘야 하는지?
        let drawPerCandleStickCount: Int = Int(
            (self.scrollView.bounds.size.width / CGFloat(self.setting.numbersOfDateTimeInFrame)) /
            (self.setting.candleStickWidth + self.setting.candleStickSpace)
        )
        self.drawingTargetIndex.forEach { index in
            guard ((self.candleSticks.count-1) - index) % drawPerCandleStickCount == 0 else {
                return
            }
            let xCoord: CGFloat = getXCoord(indexOf: index)
            let date: Date = self.candleSticks[index].date
            let thornLineLayer: CAShapeLayer = CAShapeLayer.lineLayer(
                from: CGPoint(x: xCoord, y: 0),
                to: CGPoint(x: xCoord, y: self.setting.thornLength),
                color: self.setting.defaultColor,
                width: self.setting.defaultLineWidth
            )
            let textLayer: CATextLayer = CATextLayer().then {
                $0.frame = CGRect(
                    x: xCoord - (self.setting.defaultTextSize.width / 2),
                    y: self.setting.thornLength + self.setting.thornTextSpace,
                    width: self.setting.defaultTextSize.width,
                    height: self.setting.defaultTextSize.height
                )
                $0.foregroundColor = self.setting.defaultColor
                $0.backgroundColor = UIColor.clear.cgColor
                $0.alignmentMode = CATextLayerAlignmentMode.center
                $0.contentsScale = UIScreen.main.scale
                $0.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                $0.fontSize = self.setting.defaultFontSize
                $0.string = self.setting.defaultTimeFormatter.string(from: date)
            }
            self.layers.dateTimeLayer.addSublayer(thornLineLayer)
            self.layers.dateTimeLayer.addSublayer(textLayer)
            let gridLayer: CAShapeLayer = CAShapeLayer.lineLayer(
                from: CGPoint(x: xCoord, y: 0),
                to: CGPoint(x: xCoord, y: self.bounds.height - self.setting.dateTimeHeight),
                color: self.setting.gridColor,
                width: self.setting.gridWidth
            )
            self.layers.verticalGridLayer.addSublayer(gridLayer)
        }
    }
    
    private func drawDivivisionLine() {
        let horizontalLine: CAShapeLayer = CAShapeLayer.lineLayer(
            from: CGPoint(x: -(2 * self.layers.mainLayer.bounds.size.width), y: 0),
            to: CGPoint(x: (2 * self.layers.mainLayer.bounds.size.width), y: 0),
            color: self.setting.defaultColor,
            width: self.setting.defaultLineWidth
        )
        let verticalLine: CAShapeLayer = CAShapeLayer.lineLayer(
            from: .zero,
            to: CGPoint(x: 0, y: self.bounds.height - self.setting.dateTimeHeight),
            color: self.setting.defaultColor,
            width: self.setting.defaultLineWidth
        )
        self.layers.dateTimeLayer.addSublayer(horizontalLine)
        self.layers.valueLayer.addSublayer(verticalLine)
    }
    
    private func drawValue() {
        let valueGap: Double = (self.maxPrice - self.minPrice) / Double(self.setting.numbersOfValueInFrame - 1)
        (0..<self.setting.numbersOfValueInFrame).forEach { valueCount in
            let value: Double = self.maxPrice - valueGap * Double(valueCount)
            guard let yCoord: CGFloat = getYCoord(of: value) else {
                return
            }
            let thornLineLayer: CAShapeLayer = CAShapeLayer.lineLayer(
                from: CGPoint(x: 0, y: yCoord),
                to: CGPoint(x: self.setting.thornLength, y: yCoord),
                color: self.setting.defaultColor,
                width: self.setting.defaultLineWidth
            )
            let textLayer: CATextLayer = VerticalCenterCATextLayer().then {
                $0.frame = CGRect(
                    x: self.setting.thornLength + self.setting.thornTextSpace,
                    y: yCoord - self.setting.defaultTextSize.height / 2,
                    width: self.setting.defaultTextSize.width,
                    height: self.setting.defaultTextSize.height
                )
                $0.foregroundColor = self.setting.defaultColor
                $0.backgroundColor = UIColor.clear.cgColor
                $0.alignmentMode = CATextLayerAlignmentMode.left
                $0.contentsScale = UIScreen.main.scale
                $0.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                $0.fontSize = self.setting.defaultFontSize
                $0.string = String(Int(value))
            }
            self.layers.valueLayer.addSublayer(thornLineLayer)
            self.layers.valueLayer.addSublayer(textLayer)
            
            let gridLayer: CAShapeLayer = CAShapeLayer.lineLayer(
                from: CGPoint(x: 0, y: yCoord),
                to: CGPoint(x: self.layers.verticalGridLayer.bounds.width, y: yCoord),
                color: self.setting.gridColor,
                width: self.setting.gridWidth
            )
            self.layers.horizontalGridLayer.addSublayer(gridLayer)
        }
    }
    
    private func getYCoord(of current: Double) -> CGFloat? {
        let chartContentHeight: CGFloat = self.bounds.size.height - self.setting.dateTimeHeight
        return ((self.maxPrice - current) / (self.maxPrice - self.minPrice)) *
        (chartContentHeight * (1 - self.setting.verticalFrontRearSpaceRate)) +
        (chartContentHeight * self.setting.verticalFrontRearSpaceRate) / 2
    }
    
    private func getXCoord(indexOf index: Int) -> CGFloat {
        return (self.scrollView.bounds.width / self.setting.horizontalFrontRearSpaceRatio + self.setting.candleStickWidth / 2.0) +
        CGFloat(index - 1) * (self.setting.candleStickWidth + self.setting.candleStickSpace)
    }
    
    private func removeFocus() {
        self.layers.focusInfoTextLayer.sublayers?.forEach{ sublayer in
            sublayer.removeFromSuperlayer()
        }
        self.layers.focusInfoTextLayer.removeFromSuperlayer()
        self.layers.focusHorizontalLayer.removeFromSuperlayer()
        self.layers.focusVerticalLayer.removeFromSuperlayer()
        self.layers.focusInfoLayer.removeFromSuperlayer()
    }
    
    private func drawFocus(on point: CGPoint) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        self.removeFocus()
        self.drawFocusLine(on: point)
        self.drawFocusInfo(from: point)
        CATransaction.commit()
    }
    
    private func drawFocusLine(on point: CGPoint) {
        self.layers.focusHorizontalLayer = CAShapeLayer.lineLayer(
            from: CGPoint(x: 0, y: point.y),
            to: CGPoint(x: self.scrollView.bounds.width, y: point.y),
            color: self.setting.focusLineColor,
            width: self.setting.defaultLineWidth
        )
        self.layers.focusVerticalLayer = CAShapeLayer.lineLayer(
            from: CGPoint(x: point.x, y: 0),
            to: CGPoint(x: point.x, y: self.layers.dataLayer.bounds.height),
            color: self.setting.focusLineColor,
            width: self.setting.defaultLineWidth
        )
        self.layer.addSublayer(self.layers.focusHorizontalLayer)
        self.layer.addSublayer(self.layers.focusVerticalLayer)
    }
    
    private func drawFocusInfo(from point: CGPoint) {
        let xCoordInDataLayer: CGFloat = self.scrollView.contentOffset.x + point.x
        guard let selectedIndex = self.drawingTargetIndex.filter({ index in
            return self.getXCoord(indexOf: index) - self.setting.candleStickWidth / 2 <= xCoordInDataLayer &&
            xCoordInDataLayer <= self.getXCoord(indexOf: index) + self.setting.candleStickWidth / 2
        }).first else {
            return
        }
        let infoFrame: CGRect = CGRect(
            x: point.x < self.scrollView.bounds.width / 2 ?
            self.scrollView.bounds.width - self.setting.focusInfoMargin.x - self.setting.focusInfoSize.width :
            self.setting.focusInfoMargin.x,
            y: point.x < self.scrollView.bounds.width / 2 ?
            self.setting.focusInfoMargin.y : self.setting.focusInfoMargin.y,
            width: self.setting.focusInfoSize.width,
            height: self.setting.focusInfoSize.height
        )
        self.layers.focusInfoLayer.frame = infoFrame
        self.layers.focusInfoTextLayer.frame = infoFrame
        self.layer.addSublayer(self.layers.focusInfoLayer)
        self.layer.addSublayer(self.layers.focusInfoTextLayer)

        let labelHeight: CGFloat = (self.setting.focusInfoSize.height - 2 * self.setting.focusInfoPadding.y) / 6
        let focusInfoInnerWidth: CGFloat = self.setting.focusInfoSize.width - 2 * self.setting.focusInfoPadding.x
        let candleStick: CandleStick = self.candleSticks[selectedIndex]
        let _ = VerticalCenterCATextLayer().then {
            $0.string = self.setting.infoTimeFormatter.string(from: candleStick.date)
            $0.frame = CGRect(
                x: self.setting.focusInfoPadding.x,
                y: self.setting.focusInfoPadding.y,
                width: focusInfoInnerWidth,
                height: labelHeight
            )
            $0.foregroundColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear.cgColor
            $0.fontSize = self.setting.defaultFontSize
            self.layers.focusInfoTextLayer.addSublayer($0)
        }
        func drawPriceLayer(row: Int, title: String, value: Double, defaultColor: CGColor) {
            let _ = VerticalCenterCATextLayer().then {
                $0.string = title
                $0.frame = CGRect(
                    x: self.setting.focusInfoPadding.x,
                    y: self.setting.focusInfoPadding.y + labelHeight * CGFloat(row),
                    width: focusInfoInnerWidth,
                    height: labelHeight
                )
                $0.foregroundColor = defaultColor
                $0.backgroundColor = UIColor.clear.cgColor
                $0.fontSize = self.setting.defaultFontSize
                self.layers.focusInfoTextLayer.addSublayer($0)
            }
            let _ = VerticalCenterCATextLayer().then {
                $0.string = String(value)
                $0.frame = CGRect(
                    x: self.setting.focusInfoPadding.x,
                    y: self.setting.focusInfoPadding.y + labelHeight * CGFloat(row),
                    width: focusInfoInnerWidth,
                    height: labelHeight
                )
                $0.foregroundColor = defaultColor
                $0.backgroundColor = UIColor.clear.cgColor
                $0.fontSize = self.setting.defaultFontSize
                $0.alignmentMode = .right
                self.layers.focusInfoTextLayer.addSublayer($0)
            }
        }
        drawPriceLayer(row: 1, title: "시가", value: candleStick.openingPrice, defaultColor: UIColor.white.cgColor)
        drawPriceLayer(row: 2, title: "고가", value: candleStick.highPrice, defaultColor: self.setting.redColor)
        drawPriceLayer(row: 3, title: "저가", value: candleStick.lowPrice, defaultColor: self.setting.blueColor)
        drawPriceLayer(row: 4, title: "종가", value: candleStick.tradePrice, defaultColor: UIColor.white.cgColor)
        let _ = VerticalCenterCATextLayer().then {
            $0.string = "거래량"
            $0.frame = CGRect(
                x: self.setting.focusInfoPadding.x,
                y: self.setting.focusInfoPadding.y + labelHeight * 5.0,
                width: focusInfoInnerWidth,
                height: labelHeight
            )
            $0.foregroundColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear.cgColor
            $0.fontSize = self.setting.defaultFontSize
            self.layers.focusInfoTextLayer.addSublayer($0)
        }
        let _ = VerticalCenterCATextLayer().then {
            $0.string = String(candleStick.tradeVolume)
            $0.frame = CGRect(
                x: self.setting.focusInfoPadding.x,
                y: self.setting.focusInfoPadding.y + labelHeight * 5.0,
                width: focusInfoInnerWidth,
                height: labelHeight
            )
            $0.foregroundColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear.cgColor
            $0.alignmentMode = .right
            $0.fontSize = self.setting.defaultFontSize
            self.layers.focusInfoTextLayer.addSublayer($0)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isFocusMode else {
            return
        }
        touches.forEach { touch in
            guard CGRect(
                x: 0,
                y: 0,
                width: self.scrollView.bounds.width,
                height: self.layers.dataLayer.bounds.height
            ).contains(touch.location(in: self)) else {
                return
            }
            self.drawFocus(on: touch.location(in: self))
        }
    }
    
    // MARK: - @objc

    @objc func handlePinch(_ pinch: UIPinchGestureRecognizer) {
        guard !self.isFocusMode else {
            return
        }
        let newCandleStickWidth = self.setting.candleStickWidth * pinch.scale
        if (newCandleStickWidth > self.setting.maxCandleStickWidth ||
            newCandleStickWidth < self.setting.minCandleStickWidth) {
            return
        }
        self.setting.candleStickWidth *= pinch.scale
        self.setting.candleStickSpace *= pinch.scale
        self.setting.candleStickLineWidth *= pinch.scale
        self.scrollView.contentOffset = CGPoint(
            x: self.scrollView.contentOffset.x * pinch.scale,
            y: 0
        )
        setNeedsLayout()
        pinch.scale = 1
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        if self.isFocusMode {
            self.scrollView.isScrollEnabled = true
            self.removeFocus()
        } else {
            self.scrollView.isScrollEnabled = false
            self.drawFocus(on: tap.location(in: self))
        }
        self.isFocusMode = !self.isFocusMode
    }
}

class CandleStickScrollView: UIScrollView {
    var touchEventDelegate: UIResponder? = nil
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchEventDelegate?.touchesMoved(touches, with: event)
    }
}

extension CandleStickChartView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNeedsLayout()
    }
}

extension CandleStickChartView {
    /// 캔들스틱 값
    struct CandleStick {
        /// 일시
        let date: Date
        /// 시가
        let openingPrice: Double
        /// 고가
        let highPrice: Double
        /// 저가
        let lowPrice: Double
        /// 종가
        let tradePrice: Double
        /// 거래량
        let tradeVolume: Double
        /// 양봉 or 음봉
        var type: CandleType {
            get {
                return self.openingPrice < self.tradePrice ? .red : .blue
            }
        }
        
        /// 양봉 or 음봉
        enum CandleType {
            /// 양봉
            case red
            /// 음봉
            case blue
        }
    }
}

class VerticalCenterCATextLayer : CATextLayer {
    override func draw(in context: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height-fontSize)/2 - fontSize/10
        context.saveGState()
        context.translateBy(x: 0, y: yDiff)
        super.draw(in: context)
        context.restoreGState()
    }
}
