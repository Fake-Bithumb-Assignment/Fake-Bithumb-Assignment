//
//  CandleStickChartViewSetting.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/07.
//

import UIKit

class CandleStickChartViewSetting {
    let color: Color = Color()
    let number: Number = Number()
    let size: Size = Size()
    let format: Format = Format()
    
    class Color {
        /// 양봉 색상
        let redColor: CGColor = CGColor(red: 194/255, green: 72/255, blue: 79/255, alpha: 1.0)
        /// 음봉 색상
        let blueColor: CGColor = CGColor(red: 50/255, green: 93/255, blue: 202/255, alpha: 1.0)
        /// 기본 선 색상
        let defaultColor: CGColor = CGColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1.0)
        /// 그리드 선 색상
        let gridColor: CGColor = CGColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        /// 선택 선 색상
        let focusLineColor: CGColor = UIColor.black.cgColor
    }
    
    class Number {
        /// 오른쪽 값 영역에 표시될 값의 개수
        let valueInFrame: Int = 5
        /// 한 화면에 나올 날짜, 시간 레이블의 개수
        let dateTimeInFrame: Int = 3
    }
    
    class Size {
        /// 기본 선 너비
        let defaultLineWidth: CGFloat = 1.0
        /// 그리드 선 너비
        let gridWidth: CGFloat = 0.5
        /// 기본 텍스트 크기
        let defaultFontSize: CGFloat = 11.0
        /// 오른쪽 값 영역의 너비
        let valueWidth: CGFloat = 50.0
        /// 아래 날짜, 시간 영역의 높이
        let dateTimeHeight: CGFloat = 40.0
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
        var candleStickLineWidth: CGFloat = 1.0
        /// 캔들스틱 간격
        var candleStickSpace: CGFloat = 1.0
        /// 캔들스틱 차트 영역 위, 빈 공간 비율
        let verticalFrontRearSpaceRate: CGFloat = 0.1
        /// 그래프 맨앞, 맨 뒤의 빈 공간
        var horizontalFrontRearSpaceRatio: CGFloat = 3.0
        /// 선택 정보창 사이즈
        let focusInfoSize: CGSize = CGSize(width: 120.0, height: 120.0)
        /// 선택 정보창 바깥쪽 여백
        let focusInfoMargin: CGPoint = CGPoint(x: 10, y: 10)
        /// 선택 정보착 안쪽 여백
        let focusInfoPadding: CGPoint = CGPoint(x: 4, y: 4)
        /// 기본 날짜 포맷
    }
    
    class Format {
        let defaultTimeFormatter = DateFormatter().then {
            $0.dateFormat = "M/d HH:mm"
        }
        /// 선택 정보창 날짜 포맷
        let infoTimeFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy/MM/dd HH:mm:ss"
        }
    }
}
