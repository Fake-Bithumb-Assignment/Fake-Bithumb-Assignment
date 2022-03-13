//
//  CoinInformation.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/13.
//

import UIKit

struct CoinInformation {
    
    // MARK: - Instance Property
    
    let rows: [Row]
    
    struct Row {
        
        // MARK: - Instance Property

        let title: String
        let value: Double
        var color: UIColor
        var type: RowType = .info
        
        // MARK: - Type Property
        
        static let line: Row = {
            var line = Row(title: "", value: 0.0, color: .lightGray)
            line.type = .line
            return line
        }()
    }
    
    enum RowType {
        case info, line
    }
}
