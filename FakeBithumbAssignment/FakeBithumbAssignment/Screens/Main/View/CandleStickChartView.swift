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
    
    /// 오른쪽 값 영역의 너비
    private var valueWidth: CGFloat = 40.0
    /// 아래 날짜, 시간 영역의 높이
    private var dateTimeHeight: CGFloat = 20.0
    /// 캔들스틱 너비
    private var candleStickWidth: CGFloat = 5.0
    /// 캔들스틱 간격
    private var candleStickSpace: CGFloat = 1.0
    /// 그래프 맨앞, 맨 뒤의 빈 공간
    private var widthFrontRearSpace: CGFloat = 40.0
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    // MARK: - custom func
    
    private func setupLayers() {
        // 스크롤에 포함될 전체 영역인 mainLayer
        mainLayer.addSublayer(dataLayer)
        mainLayer.addSublayer(dateTimeLayer)
        mainLayer.addSublayer(verticalGridLayer)
        scrollView.layer.addSublayer(mainLayer)
        // 가로줄, 값은 스크롤 되지 않음
        self.layer.addSublayer(horizontalGridLayer)
        self.layer.addSublayer(valueLayer)
        // subView로 추가
        self.addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        // Frame 설정
    }
}
