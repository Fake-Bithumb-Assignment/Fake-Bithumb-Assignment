//
//  CandleStickChartView.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/02/26.
//

import UIKit

import Then

class CandleStickChartView: UIView {
    
    // MARK: - instance property
    
    /// 스크롤 뷰
    private let scrollView: UIScrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    /// 스크롤 뷰를 가득 채울 레이어
    private let mainLayer: CALayer = CALayer()
    /// dateTimeLayer를 제외하고 실제 차트가 그려질 레이어 (스크롤에 포함)
    private let dataLayer: CALayer = CALayer()
    /// 아래 날짜, 시간 영역을 그려 줄 레이어 (스크롤에 포함)
    private let dateTimeLayer: CALayer = CALayer()
    /// 오른쪽 값 영역을 그려줄 레이어
    private let valueLayer: CALayer = CALayer()
    /// 가로줄을 그려줄 레이어
    private let horizontalGridLayer: CALayer = CALayer()
    /// 세로줄을 그려줄 레이어 (스크롤에 포함)
    private let verticalGridLayer: CALayer = CALayer()
    
    /// 양봉 색상
    private let redColor: CGColor = CGColor(red: 194/255, green: 72/255, blue: 79/255, alpha: 1.0)
    /// 음봉 색상
    private let blueColor: CGColor = CGColor(red: 50/255, green: 93/255, blue: 202/255, alpha: 1.0)
    /// 기본 선 색상
    private let defaultColor: CGColor = CGColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1.0)
    /// 기본 선 너비
    private let defaultLineWidth: CGFloat = 0.5
    /// 기본 텍스트 크기
    private let defaultFontSize: CGFloat = 11.0
    /// 오른쪽 값 영역의 너비
    private let valueWidth: CGFloat = 40.0
    /// 아래 날짜, 시간 영역의 높이
    private let dateTimeHeight: CGFloat = 20.0
    /// 한 화면에 나올 날짜, 시간 레이블의 개수
    private let numbersOfDateTimeInFrame: Int = 4
    /// 한 화면에 나올 날짜, 시간 레이블의 개수
    private let dateTimeTextWidth: Int = 4
    /// 수치 표시할 때 튀어나온 선 길이
    private let thornLength: CGFloat = 2.0
    /// 수치 표시할 때 튀어나온 선 - 수치 텍스트 간격
    private let thornTextSpace: CGFloat = 1.0
    /// 날짜, 시간 레이블의 크기
    private let dateTimeTextSize: CGSize = CGSize(width: 5.0, height: 3.0)
    /// 캔들스틱 너비
    private var candleStickWidth: CGFloat = 5.0
    /// 캔들스틱 얇은 선 너비
    private var candleStickLineWidth: CGFloat = 1.0
    /// 캔들스틱 간격
    private var candleStickSpace: CGFloat = 1.0
    /// 캔들스틱 차트 영역 위, 빈 공간 비율
    private let verticalFrontRearSpaceRate: CGFloat = 0.1
    /// 그래프 맨앞, 맨 뒤의 빈 공간
    private var horizontalFrontRearSpace: CGFloat {
        get {
            self.frame.size.width / 2
        }
    }
    
    /// 캔들스틱 값들
    private var candleSticks: [CandleStick] = []
    
    // MARK: - Initializer
    
    init(frame: CGRect, with candleSticks: [CandleStick]) {
        self.candleSticks = candleSticks
        super.init(frame: frame)
        setupLayers()
    }
    
    convenience init(with candleSticks: [CandleStick]) {
        self.init(frame: CGRect.zero, with: candleSticks)
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    // MARK: - custom func
    
    private func setupLayers() {
        // 스크롤에 포함될 전체 영역인 mainLayer
        self.mainLayer.addSublayer(self.dataLayer)
        self.mainLayer.addSublayer(self.dateTimeLayer)
        self.mainLayer.addSublayer(self.verticalGridLayer)
        self.scrollView.layer.addSublayer(self.mainLayer)
        // 가로줄, 값은 스크롤 되지 않음
        self.layer.addSublayer(self.horizontalGridLayer)
        self.layer.addSublayer(self.valueLayer)
        // subView로 추가
        self.addSubview(self.scrollView)
    }
    
    override func layoutSubviews() {
        setFrame()
        cleanLayers()
        drawChart()
        drawDateTime()
    }
    
    private func setFrame() {
        let chartContentWidth: CGFloat = 2 * self.horizontalFrontRearSpace
        + CGFloat(self.candleSticks.count) * self.candleStickWidth
        + CGFloat(self.candleSticks.count) - 1 * self.candleStickSpace
        let chartContentHeight: CGFloat = self.frame.size.height - self.dateTimeHeight
        
        self.scrollView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.frame.size.width - self.valueWidth,
                                       height: self.frame.size.height
        )
        self.scrollView.contentSize = CGSize(width: chartContentWidth,
                                             height: self.frame.size.height
        )
        self.mainLayer.frame = CGRect(x: 0,
                                      y: 0,
                                      width: chartContentWidth,
                                      height: self.frame.size.height
        )
        self.dataLayer.frame = CGRect(x: 0,
                                      y: 0,
                                      width: chartContentWidth,
                                      height: chartContentHeight
        )
        self.dateTimeLayer.frame = CGRect(x: 0,
                                          y: chartContentHeight,
                                          width: chartContentWidth,
                                          height: self.dateTimeHeight
        )
        self.valueLayer.frame = CGRect(x: chartContentWidth,
                                       y: 0,
                                       width: self.valueWidth,
                                       height: chartContentHeight
        )
        self.horizontalGridLayer.frame = CGRect(x: 0,
                                                y: 0,
                                                width: chartContentWidth,
                                                height: chartContentHeight
        )
        self.horizontalGridLayer.frame = CGRect(x: 0,
                                                y: 0,
                                                width: chartContentWidth,
                                                height: chartContentHeight
        )
    }
    
    private func cleanLayers() {
        self.mainLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.dataLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.dateTimeLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.valueLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.horizontalGridLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.verticalGridLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    private func drawChart() {
        self.candleSticks.indices.forEach { index in
            let candleStick: CandleStick = candleSticks[index]
            let xCoord: CGFloat = getXCoord(indexOf: index)
            let color: CGColor = candleStick.type == .blue ? self.blueColor : self.redColor
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
                $0.frame = CGRect(x: xCoord - self.candleStickLineWidth / 2,
                                  y: highPriceYCoord,
                                  width: self.candleStickLineWidth,
                                  height: lowPriceYCoord - highPriceYCoord
                )
                $0.backgroundColor = color
            }
            let rectLayer: CALayer = CALayer().then {
                $0.frame = CGRect(x: xCoord - self.candleStickWidth / 2,
                                  y: max(openingPriceYCoord, tradePriceYCoord),
                                  width: self.candleStickWidth,
                                  height: max(openingPriceYCoord, tradePriceYCoord) -
                                  min(openingPriceYCoord, tradePriceYCoord)
                )
                $0.backgroundColor = color
            }
            self.dataLayer.addSublayer(lineLayer)
            self.dataLayer.addSublayer(rectLayer)
        }
    }
    
    private func drawDateTime() {
        let drawPerCandleStickCount: Int = Int(
            (self.scrollView.frame.size.width / CGFloat(self.numbersOfDateTimeInFrame)) / (self.candleStickWidth + self.candleStickSpace)
        )
        self.candleSticks.indices.forEach {
            let index: Int = self.candleSticks.count - 1 - $0
            guard $0 % drawPerCandleStickCount == 0 else {
                return
            }
            let xCoord: CGFloat = getXCoord(indexOf: index)
            let thornLineLayer: CAShapeLayer  = CAShapeLayer.lineLayer(
                from: CGPoint(x: xCoord, y: 0),
                to: CGPoint(x: xCoord, y: self.thornLength),
                color: self.defaultColor,
                width: self.defaultLineWidth
            )
            let textLayer: CATextLayer = CATextLayer().then {
                $0.frame = CGRect(
                    x: xCoord - (self.dateTimeTextSize.width / 2),
                    y: self.thornLength + self.thornTextSpace,
                    width: self.dateTimeTextSize.width,
                    height: self.dateTimeTextSize.height
                )
                $0.foregroundColor = self.defaultColor
                $0.backgroundColor = UIColor.clear.cgColor
                $0.alignmentMode = CATextLayerAlignmentMode.center
                $0.contentsScale = UIScreen.main.scale
                $0.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
                $0.fontSize = self.defaultFontSize
                $0.string = self.candleSticks[index].date.formatted()
            }
            self.dateTimeLayer.addSublayer(thornLineLayer)
            self.dateTimeLayer.addSublayer(textLayer)
        }
    }
    
    private func getYCoord(of current: Double) -> CGFloat? {
        guard let maxPrice: Double = self.candleSticks.max(by: { $0.highPrice < $1.highPrice })?.highPrice else {
            return nil
        }
        guard let minPrice: Double = self.candleSticks.max(by: { $0.highPrice > $1.highPrice })?.highPrice else {
            return nil
        }
        let chartContentHeight: CGFloat = self.frame.size.height - self.dateTimeHeight
        return ((maxPrice - current) / (maxPrice - minPrice)) *
        (chartContentHeight * (1 - self.verticalFrontRearSpaceRate)) +
        (chartContentHeight * self.verticalFrontRearSpaceRate) / 2
    }
    
    private func getXCoord(indexOf index: Int) -> CGFloat {
        return (self.horizontalFrontRearSpace + self.candleStickWidth / 2.0) +
        CGFloat(index - 1) * (self.candleStickWidth + self.candleStickSpace)
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
