//
//  CandleStickChartViewLayers.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/07.
//

import UIKit

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
