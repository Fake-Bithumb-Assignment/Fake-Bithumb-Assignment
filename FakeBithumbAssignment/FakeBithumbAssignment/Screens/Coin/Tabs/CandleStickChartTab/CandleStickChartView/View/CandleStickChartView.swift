//
//  CandleStickChartView.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/26.
//

import UIKit

import Then

final class CandleStickChartView: UIView {
    
    // MARK: - instance property
    
    /// 스크롤 뷰
    private let scrollView: CandleStickScrollView = CandleStickScrollView().then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    /// 레이어들
    private let layers: CandleStickChartViewLayer = CandleStickChartViewLayer()
    /// 설정값
    private let setting: CandleStickChartViewSetting = CandleStickChartViewSetting()
    
    /// 선택 모드인지 아닌지
    private var isFocusMode: Bool = false
    /// 처음으로 그려지는 상태인지?
    private var isInitialState: Bool = true
    
    /// 캔들스틱 값들
    private var candleSticks: [CandleStick] = []
    /// 현재 화면에 그려야 할 캔들스틱 인덱스 범위
    private var drawingTargetIndex: ClosedRange<Int> = (0...0)
    /// 현재 화면에 있는 캔들스틱 중 최고 가격
    private var maxPrice: Double = 0.0
    /// 현재 화면에 있는 캔들스틱 중 최저 가격
    private var minPrice: Double = 0.0
    
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
    
    // MARK: - Life Cycle func
    
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
    
    // MARK: - custom func
    
    /// 레이어들간의 관계 설정하는 메소드.
    private func setupLayers() {
        self.layers.mainLayer.addSublayer(self.layers.verticalGridLayer)
        self.layers.mainLayer.addSublayer(self.layers.dataLayer)
        self.layers.mainLayer.addSublayer(self.layers.dateTimeLayer)
        self.scrollView.layer.addSublayer(self.layers.mainLayer)
        self.layer.addSublayer(self.layers.horizontalGridLayer)
        self.layer.addSublayer(self.layers.valueLayer)
        self.addSubview(self.scrollView)
        self.layer.addSublayer(self.layers.focusDateTimeLayer)
        self.layer.addSublayer(self.layers.focusValueLayer)
        self.backgroundColor = .clear
    }
    
    /// 첫 진입 시 최신의 차트부터 보여주도록 스크롤을 이동시켜주는 메소드.
    private func moveScrollIfInitialState() {
        guard isInitialState && !self.candleSticks.isEmpty else {
            return
        }
        self.scrollView.contentOffset = CGPoint(
            x: self.scrollView.contentSize.width -
            self.scrollView.bounds.width / self.setting.size.horizontalFrontRearSpaceRatio -
            self.scrollView.bounds.width / 2.0,
            y: 0
        )
        self.isInitialState = false
    }
    
    /// 값 -> y좌표로 변환하는 메소드.
    private func getYCoord(of current: Double) -> CGFloat? {
        let chartContentHeight: CGFloat = self.bounds.size.height - self.setting.size.dateTimeHeight
        return ((self.maxPrice - current) / (self.maxPrice - self.minPrice)) *
        (chartContentHeight * (1 - self.setting.size.verticalFrontRearSpaceRate)) +
        (chartContentHeight * self.setting.size.verticalFrontRearSpaceRate) / 2
    }
    
    /// 캔들스틱의 중심의 x좌표를 반환하는 메소드.
    private func getXCoord(indexOf index: Int) -> CGFloat {
        return (self.scrollView.bounds.width / self.setting.size.horizontalFrontRearSpaceRatio + self.setting.size.candleStickWidth / 2.0) +
        CGFloat(index - 1) * (self.setting.size.candleStickWidth + self.setting.size.candleStickSpace)
    }
    
    /// y좌표 -> 값으로 변환하는 메소드
    private func getValue(from yCoord: CGFloat) -> Double? {
        let chartContentHeight: CGFloat = self.bounds.size.height - self.setting.size.dateTimeHeight
        return self.maxPrice - (yCoord - (chartContentHeight * self.setting.size.verticalFrontRearSpaceRate) / 2) *
        ((self.maxPrice - self.minPrice) / (chartContentHeight * (1 - self.setting.size.verticalFrontRearSpaceRate)))
    }
}

// MARK: - extension

extension CandleStickChartView {
    /// 캔들스틱을 최신의 것으로 업데이트해주는 메소드.
    func updateCandleSticks(of candleSticks: [CandleStick]) {
        DispatchQueue.main.async {
            self.candleSticks = candleSticks
            self.setNeedsLayout()
        }
    }
    
    /// 뷰를 초기화 해주는 메소드
    func reset() {
        DispatchQueue.main.async {
            self.candleSticks = []
            self.isInitialState = true
            self.isFocusMode = false
            self.scrollView.isScrollEnabled = true
            self.removeFocus(with: nil)
            self.setNeedsLayout()
        }
    }
    
    /// 스크롤뷰의 현재 표시될 캔들스틱 대상을 업데이트 해주는 메소드.
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
    
    /// 스크롤뷰의 현재 표시될 캔들스틱 전체의 최대값 최소값을 업데이트 해주는 메소드.
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
}

extension CandleStickChartView {
    private func setupPinchGesture() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    private func setUpTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handlePinch(_ pinch: UIPinchGestureRecognizer) {
        guard !self.isFocusMode else {
            return
        }
        let newCandleStickWidth = self.setting.size.candleStickWidth * pinch.scale
        if (newCandleStickWidth > self.setting.size.maxCandleStickWidth ||
            newCandleStickWidth < self.setting.size.minCandleStickWidth) {
            return
        }
        self.setting.size.candleStickWidth *= pinch.scale
        self.setting.size.candleStickSpace *= pinch.scale
        self.setting.size.candleStickLineWidth *= pinch.scale
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
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            self.removeFocus(with: nil)
            CATransaction.commit()
        } else {
            self.scrollView.isScrollEnabled = false
            self.drawFocus(on: tap.location(in: self))
        }
        self.isFocusMode = !self.isFocusMode
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
}

extension CandleStickChartView {
    /// 각 레이어들의 프레임 설정해주는 메소드.
    private func setFrame() {
        let chartContentWidth: CGFloat = 2 * self.scrollView.bounds.width / self.setting.size.horizontalFrontRearSpaceRatio
        + CGFloat(self.candleSticks.count) * self.setting.size.candleStickWidth
        + (CGFloat(self.candleSticks.count) - 1) * self.setting.size.candleStickSpace
        let chartContentHeight: CGFloat = self.bounds.height - self.setting.size.dateTimeHeight
        
        self.scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.size.width - self.setting.size.valueWidth,
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
            height: self.setting.size.dateTimeHeight
        )
        self.layers.valueLayer.frame = CGRect(
            x: self.bounds.size.width - self.setting.size.valueWidth,
            y: 0,
            width: self.setting.size.valueWidth,
            height: chartContentHeight
        )
        self.layers.horizontalGridLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.size.width - self.setting.size.valueWidth,
            height: chartContentHeight
        )
        self.layers.verticalGridLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: self.scrollView.bounds.width,
            height: chartContentHeight
        )
        self.layers.focusDateTimeLayer.frame = CGRect(
            x: 0,
            y: chartContentHeight,
            width: self.scrollView.bounds.width,
            height: self.setting.size.dateTimeHeight
        )
        self.layers.focusValueLayer.frame = CGRect(
            x: self.bounds.size.width - self.setting.size.valueWidth,
            y: 0,
            width: self.setting.size.valueWidth,
            height: chartContentHeight
        )
    }
    
    /// 모든 레이어의 요소들을 지워주는 메소드.
    private func cleanLayers() {
        self.layers.dataLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layers.dateTimeLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layers.valueLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layers.horizontalGridLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layers.verticalGridLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    /// 캔들스틱 그려주는 메소드.
    private func drawChart() {
        self.drawingTargetIndex.forEach { index in
            let candleStick: CandleStick = candleSticks[index]
            let xCoord: CGFloat = getXCoord(indexOf: index)
            let color: CGColor = candleStick.type == .blue ? self.setting.color.blueColor : self.setting.color.redColor
            guard let openingPriceYCoord: CGFloat = self.getYCoord(of: candleStick.openingPrice),
                  let highPriceYCoord: CGFloat = self.getYCoord(of: candleStick.highPrice),
                  let lowPriceYCoord: CGFloat = self.getYCoord(of: candleStick.lowPrice),
                  let tradePriceYCoord: CGFloat = self.getYCoord(of: candleStick.tradePrice)
            else {
                return
            }
            guard candleStick.highPrice != candleStick.lowPrice else {
                let lineLayer: CALayer = CALayer().then {
                    $0.frame = CGRect(
                        x: xCoord - self.setting.size.candleStickWidth / 2,
                        y: highPriceYCoord - self.setting.size.candleStickLineWidth / 2,
                        width: self.setting.size.candleStickWidth,
                        height: self.setting.size.candleStickLineWidth
                    )
                    $0.backgroundColor = self.setting.color.redColor
                }
                self.layers.dataLayer.addSublayer(lineLayer)
                return
            }
            let lineLayer: CALayer = CALayer().then {
                $0.frame = CGRect(
                    x: xCoord - self.setting.size.candleStickLineWidth / 2,
                    y: highPriceYCoord,
                    width: self.setting.size.candleStickLineWidth,
                    height: lowPriceYCoord - highPriceYCoord
                )
                $0.backgroundColor = color
            }
            let rectLayer: CALayer = CALayer().then {
                $0.frame = CGRect(
                    x: xCoord - self.setting.size.candleStickWidth / 2,
                    y: min(openingPriceYCoord, tradePriceYCoord),
                    width: self.setting.size.candleStickWidth,
                    height: max(openingPriceYCoord, tradePriceYCoord) -
                    min(openingPriceYCoord, tradePriceYCoord)
                )
                $0.backgroundColor = color
            }
            self.layers.dataLayer.addSublayer(lineLayer)
            self.layers.dataLayer.addSublayer(rectLayer)
        }
    }
    
    /// 아래의 날짜 시간을 그려주는 메소드.
    private func drawDateTime() {
        // 몇개의 캔들스틱당 날짜 & 세로그리드를 그려 줘야 하는지?
        let drawPerCandleStickCount: Int = Int(
            (self.scrollView.bounds.size.width / CGFloat(self.setting.number.dateTimeInFrame)) /
            (self.setting.size.candleStickWidth + self.setting.size.candleStickSpace)
        )
        self.drawingTargetIndex.forEach { index in
            guard ((self.candleSticks.count - 1) - index) % drawPerCandleStickCount == 0 else {
                return
            }
            let xCoord: CGFloat = getXCoord(indexOf: index)
            let date: Date = self.candleSticks[index].date
            let thornLineLayer: CAShapeLayer = CAShapeLayer.lineLayer(
                from: CGPoint(x: xCoord, y: 0),
                to: CGPoint(x: xCoord, y: self.setting.size.thornLength),
                color: self.setting.color.defaultColor,
                width: self.setting.size.defaultLineWidth
            )
            let textLayer: CATextLayer = CATextLayer().then {
                $0.frame = CGRect(
                    x: xCoord - (self.setting.size.dateTimeTextSize.width / 2),
                    y: self.setting.size.thornLength + self.setting.size.thornTextSpace,
                    width: self.setting.size.dateTimeTextSize.width,
                    height: self.setting.size.dateTimeTextSize.height
                )
                $0.foregroundColor = self.setting.color.defaultColor
                $0.backgroundColor = UIColor.clear.cgColor
                $0.alignmentMode = CATextLayerAlignmentMode.center
                $0.contentsScale = UIScreen.main.scale
                $0.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                $0.fontSize = self.setting.size.defaultFontSize
                $0.string = self.setting.format.defaultTimeFormatter.string(from: date)
            }
            self.layers.dateTimeLayer.addSublayer(thornLineLayer)
            self.layers.dateTimeLayer.addSublayer(textLayer)
            let gridLayer: CAShapeLayer = CAShapeLayer.lineLayer(
                from: CGPoint(x: xCoord, y: 0),
                to: CGPoint(x: xCoord, y: self.bounds.height - self.setting.size.dateTimeHeight),
                color: self.setting.color.gridColor,
                width: self.setting.size.gridWidth
            )
            self.layers.verticalGridLayer.addSublayer(gridLayer)
        }
    }
    
    /// 행열 구분선을 그려주는 메소드.
    private func drawDivivisionLine() {
        let horizontalLine: CAShapeLayer = CAShapeLayer.lineLayer(
            from: CGPoint(x: -(2 * self.layers.mainLayer.bounds.size.width), y: 0),
            to: CGPoint(x: (2 * self.layers.mainLayer.bounds.size.width), y: 0),
            color: self.setting.color.defaultColor,
            width: self.setting.size.defaultLineWidth
        )
        let verticalLine: CAShapeLayer = CAShapeLayer.lineLayer(
            from: .zero,
            to: CGPoint(x: 0, y: self.bounds.height - self.setting.size.dateTimeHeight),
            color: self.setting.color.defaultColor,
            width: self.setting.size.defaultLineWidth
        )
        self.layers.dateTimeLayer.addSublayer(horizontalLine)
        self.layers.valueLayer.addSublayer(verticalLine)
    }
    
    /// 오른쪽 값들을 그려주는 메소드.
    private func drawValue() {
        let valueGap: Double = (self.maxPrice - self.minPrice) / Double(self.setting.number.valueInFrame - 1)
        (0..<self.setting.number.valueInFrame).forEach { valueCount in
            let value: Double = self.maxPrice - valueGap * Double(valueCount)
            guard let yCoord: CGFloat = getYCoord(of: value) else {
                return
            }
            let thornLineLayer: CAShapeLayer = CAShapeLayer.lineLayer(
                from: CGPoint(x: 0, y: yCoord),
                to: CGPoint(x: self.setting.size.thornLength, y: yCoord),
                color: self.setting.color.defaultColor,
                width: self.setting.size.defaultLineWidth
            )
            let textLayer: CATextLayer = VerticalCenterCATextLayer().then {
                $0.frame = CGRect(
                    x: self.setting.size.thornLength + self.setting.size.thornTextSpace,
                    y: yCoord - self.setting.size.valueTextSize.height / 2,
                    width: self.setting.size.valueTextSize.width,
                    height: self.setting.size.valueTextSize.height
                )
                $0.foregroundColor = self.setting.color.defaultColor
                $0.backgroundColor = UIColor.clear.cgColor
                $0.alignmentMode = CATextLayerAlignmentMode.left
                $0.contentsScale = UIScreen.main.scale
                $0.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                $0.fontSize = self.setting.size.defaultFontSize
                $0.string = String.insertComma(value: Int(value))
            }
            self.layers.valueLayer.addSublayer(thornLineLayer)
            self.layers.valueLayer.addSublayer(textLayer)
            
            let gridLayer: CAShapeLayer = CAShapeLayer.lineLayer(
                from: CGPoint(x: 0, y: yCoord),
                to: CGPoint(x: self.layers.verticalGridLayer.bounds.width, y: yCoord),
                color: self.setting.color.gridColor,
                width: self.setting.size.gridWidth
            )
            self.layers.horizontalGridLayer.addSublayer(gridLayer)
        }
    }
}

extension CandleStickChartView {
    /// 현재 탭한 지점이 캔들스틱 구간 안에 속했는지 판단해주는 메소드.
    private func isCandlestickInclude(point: CGPoint) -> Bool {
        return self.getSelectedCandleStick(on: point) != nil
    }
    /// 현재 탭한 지점이 가르키는 캔들스틱을 반환해주는 메소드.
    private func getSelectedCandleStick(on point: CGPoint) -> CandleStick? {
        guard !self.candleSticks.isEmpty else {
            return nil
        }
        let xCoordInDataLayer: CGFloat = self.scrollView.contentOffset.x + point.x
        guard let index = self.drawingTargetIndex.filter({ index in
            return self.getXCoord(indexOf: index) - (self.setting.size.candleStickWidth / 2.0) <=
            xCoordInDataLayer &&
            xCoordInDataLayer <=
            self.getXCoord(indexOf: index) + (self.setting.size.candleStickWidth / 2.0)
        }).first else {
            return nil
        }
        return self.candleSticks[index]
    }
    
    /// 선택 정보창의 레이어들을 모두 지워주는 메소드.
    private func removeFocus(with point: CGPoint?) {
        self.layers.focusHorizontalLayer.removeFromSuperlayer()
        self.layers.focusVerticalLayer.removeFromSuperlayer()
        self.layers.focusDateTimeLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layers.focusValueLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        if point == nil || self.isCandlestickInclude(point: point!) {
            self.layers.focusInfoTextLayer.sublayers?.forEach{ $0.removeFromSuperlayer() }
            self.layers.focusInfoLayer.removeFromSuperlayer()
            self.layers.focusInfoTextLayer.removeFromSuperlayer()
        }
    }
    
    /// 선택 정보창을 그려주는 메소드.
    private func drawFocus(on point: CGPoint) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        self.removeFocus(with: point)
        self.drawFocusLine(on: point)
        self.drawFocusInfo(from: point)
        self.drawFocusDateTime(on: point)
        self.drawFocusValue(on: point)
        CATransaction.commit()
    }
    
    /// 선택 시간을 그려주는 메소드
    private func drawFocusDateTime(on point: CGPoint) {
        guard let candleStick: CandleStick = self.getSelectedCandleStick(on: point) ??
                self.getSelectedCandleStick(on: CGPoint(
                    x: point.x + self.setting.size.candleStickSpace,
                    y: point.y
                ))
        else {
            return
        }
        let _: CAShapeLayer = CAShapeLayer.lineLayer(
            from: CGPoint(x: point.x, y: 0),
            to: CGPoint(x: point.x, y: self.setting.size.thornLength),
            color: self.setting.color.focusLineColor,
            width: self.setting.size.defaultLineWidth
        ).then {
            self.layers.focusDateTimeLayer.addSublayer($0)
        }
        let _: CATextLayer = CATextLayer().then {
            $0.frame = CGRect(
                x: max(point.x - self.setting.size.dateTimeTextSize.width / 2, 0.0),
                y: self.setting.size.thornLength + self.setting.size.thornTextSpace,
                width: self.setting.size.dateTimeTextSize.width,
                height: self.setting.size.dateTimeTextSize.height
            )
            $0.foregroundColor = UIColor.white.cgColor
            $0.backgroundColor = self.setting.color.focusDateTimeColor
            $0.alignmentMode = CATextLayerAlignmentMode.center
            $0.contentsScale = UIScreen.main.scale
            $0.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            $0.fontSize = self.setting.size.defaultFontSize
            $0.string = self.setting.format.defaultTimeFormatter.string(from: candleStick.date)
            self.layers.focusDateTimeLayer.addSublayer($0)
        }
    }
    
    /// 선택 값을 그려주는 메소드
    private func drawFocusValue(on point: CGPoint) {
        guard let value: Double = self.getValue(from: point.y) else {
            return
        }
        let _: CAShapeLayer = CAShapeLayer.lineLayer(
            from: CGPoint(x: 0, y: point.y),
            to: CGPoint(x: self.setting.size.thornLength, y: point.y),
            color: self.setting.color.focusLineColor,
            width: self.setting.size.defaultLineWidth
        ).then {
            self.layers.focusValueLayer.addSublayer($0)
        }
        let _: CATextLayer = VerticalCenterCATextLayer().then {
            $0.frame = CGRect(
                x: self.setting.size.thornLength + self.setting.size.thornTextSpace,
                y: point.y - self.setting.size.valueTextSize.height / 2,
                width: self.setting.size.valueTextSize.width,
                height: self.setting.size.valueTextSize.height
            )
            $0.foregroundColor = UIColor.white.cgColor
            $0.backgroundColor = self.setting.color.focusDateTimeColor
            $0.alignmentMode = CATextLayerAlignmentMode.left
            $0.contentsScale = UIScreen.main.scale
            $0.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            $0.fontSize = self.setting.size.defaultFontSize
            $0.string = String.insertComma(value: Int(value))
            self.layers.focusValueLayer.addSublayer($0)
        }
    }
    
    /// 선택 정보창의 가로 세로 선을 그려주는 메소드.
    private func drawFocusLine(on point: CGPoint) {
        self.layers.focusHorizontalLayer = CAShapeLayer.lineLayer(
            from: CGPoint(x: 0, y: point.y),
            to: CGPoint(x: self.scrollView.bounds.width, y: point.y),
            color: self.setting.color.focusLineColor,
            width: self.setting.size.defaultLineWidth
        )
        self.layers.focusVerticalLayer = CAShapeLayer.lineLayer(
            from: CGPoint(x: point.x, y: 0),
            to: CGPoint(x: point.x, y: self.layers.dataLayer.bounds.height),
            color: self.setting.color.focusLineColor,
            width: self.setting.size.defaultLineWidth
        )
        self.layer.addSublayer(self.layers.focusHorizontalLayer)
        self.layer.addSublayer(self.layers.focusVerticalLayer)
    }
    
    /// 선택 정보창의 정보창을 그려주는 메소드.
    private func drawFocusInfo(from point: CGPoint) {
        guard let candleStick: CandleStick = self.getSelectedCandleStick(on: point) else {
            return
        }
        let infoFrame: CGRect = CGRect(
            x: point.x < self.scrollView.bounds.width / 2 ?
            self.scrollView.bounds.width - self.setting.size.focusInfoMargin.x - self.setting.size.focusInfoSize.width :
            self.setting.size.focusInfoMargin.x,
            y: point.x < self.scrollView.bounds.width / 2 ?
            self.setting.size.focusInfoMargin.y : self.setting.size.focusInfoMargin.y,
            width: self.setting.size.focusInfoSize.width,
            height: self.setting.size.focusInfoSize.height
        )
        self.layers.focusInfoLayer.frame = infoFrame
        self.layers.focusInfoTextLayer.frame = infoFrame
        self.layer.addSublayer(self.layers.focusInfoLayer)
        self.layer.addSublayer(self.layers.focusInfoTextLayer)

        let labelHeight: CGFloat = (self.setting.size.focusInfoSize.height - 2 * self.setting.size.focusInfoPadding.y) / 6
        let focusInfoInnerWidth: CGFloat = self.setting.size.focusInfoSize.width - 2 * self.setting.size.focusInfoPadding.x
        let _ = VerticalCenterCATextLayer().then {
            $0.string = self.setting.format.infoTimeFormatter.string(from: candleStick.date)
            $0.frame = CGRect(
                x: self.setting.size.focusInfoPadding.x,
                y: self.setting.size.focusInfoPadding.y,
                width: focusInfoInnerWidth,
                height: labelHeight
            )
            $0.foregroundColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear.cgColor
            $0.contentsScale = UIScreen.main.scale
            $0.fontSize = self.setting.size.defaultFontSize
            self.layers.focusInfoTextLayer.addSublayer($0)
        }
        func drawPriceLayer(row: Int, title: String, value: Double, defaultColor: CGColor) {
            let _ = VerticalCenterCATextLayer().then {
                $0.string = title
                $0.frame = CGRect(
                    x: self.setting.size.focusInfoPadding.x,
                    y: self.setting.size.focusInfoPadding.y + labelHeight * CGFloat(row),
                    width: focusInfoInnerWidth,
                    height: labelHeight
                )
                $0.foregroundColor = defaultColor
                $0.backgroundColor = UIColor.clear.cgColor
                $0.contentsScale = UIScreen.main.scale
                $0.fontSize = self.setting.size.defaultFontSize
                self.layers.focusInfoTextLayer.addSublayer($0)
            }
            let _ = VerticalCenterCATextLayer().then {
                $0.string = String.insertComma(value: value)
                $0.frame = CGRect(
                    x: self.setting.size.focusInfoPadding.x,
                    y: self.setting.size.focusInfoPadding.y + labelHeight * CGFloat(row),
                    width: focusInfoInnerWidth,
                    height: labelHeight
                )
                $0.foregroundColor = defaultColor
                $0.backgroundColor = UIColor.clear.cgColor
                $0.contentsScale = UIScreen.main.scale
                $0.fontSize = self.setting.size.defaultFontSize
                $0.alignmentMode = .right
                self.layers.focusInfoTextLayer.addSublayer($0)
            }
        }
        drawPriceLayer(row: 1, title: "시가", value: candleStick.openingPrice, defaultColor: UIColor.white.cgColor)
        drawPriceLayer(row: 2, title: "고가", value: candleStick.highPrice, defaultColor: self.setting.color.redColor)
        drawPriceLayer(row: 3, title: "저가", value: candleStick.lowPrice, defaultColor: self.setting.color.blueColor)
        drawPriceLayer(row: 4, title: "종가", value: candleStick.tradePrice, defaultColor: UIColor.white.cgColor)
        let _ = VerticalCenterCATextLayer().then {
            $0.string = "거래량"
            $0.frame = CGRect(
                x: self.setting.size.focusInfoPadding.x,
                y: self.setting.size.focusInfoPadding.y + labelHeight * 5.0,
                width: focusInfoInnerWidth,
                height: labelHeight
            )
            $0.foregroundColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear.cgColor
            $0.contentsScale = UIScreen.main.scale
            $0.fontSize = self.setting.size.defaultFontSize
            self.layers.focusInfoTextLayer.addSublayer($0)
        }
        let _ = VerticalCenterCATextLayer().then {
            $0.string = String.insertComma(value: candleStick.tradeVolume)
            $0.frame = CGRect(
                x: self.setting.size.focusInfoPadding.x,
                y: self.setting.size.focusInfoPadding.y + labelHeight * 5.0,
                width: focusInfoInnerWidth,
                height: labelHeight
            )
            $0.foregroundColor = UIColor.white.cgColor
            $0.backgroundColor = UIColor.clear.cgColor
            $0.contentsScale = UIScreen.main.scale
            $0.alignmentMode = .right
            $0.fontSize = self.setting.size.defaultFontSize
            self.layers.focusInfoTextLayer.addSublayer($0)
        }
    }
}

extension CandleStickChartView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNeedsLayout()
    }
}
