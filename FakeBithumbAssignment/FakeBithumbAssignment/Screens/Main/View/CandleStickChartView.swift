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
    /// 음복 색상
    private let blueColor: CGColor = CGColor(red: 50/255, green: 93/255, blue: 202/255, alpha: 1.0)
    /// 오른쪽 값 영역의 너비
    private let valueWidth: CGFloat = 40.0
    /// 아래 날짜, 시간 영역의 높이
    private let dateTimeHeight: CGFloat = 20.0
    /// 캔들스틱 너비
    private var candleStickWidth: CGFloat = 5.0
    /// 캔들스틱 간격
    private var candleStickSpace: CGFloat = 1.0
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
                return .red
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
