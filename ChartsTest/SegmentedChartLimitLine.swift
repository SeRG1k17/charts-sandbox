//
//  SegmentedChartLimitLine.swift
//  ChartsTest
//
//  Created by Sergey Pugach on 1/5/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import Charts


open class SegmentedChartLimitLine: ChartLimitLine {
    
    @objc internal var firstLimitLine: ChartLimitLine!
    @objc internal var secondLimitLine: ChartLimitLine!

    fileprivate var _lineWidth = CGFloat(1.0)
    
    
    init(firstLimit: Double, secondLimit: Double, borderLineColor: NSUIColor) {
        
        let averageLimit = (firstLimit + secondLimit) / 2
        super.init(limit: averageLimit)
        
        firstLimitLine = ChartLimitLine(limit: firstLimit)
        firstLimitLine.lineColor = borderLineColor
        firstLimitLine.lineWidth = _lineWidth
        
        secondLimitLine = ChartLimitLine(limit: secondLimit)
        secondLimitLine.lineColor = borderLineColor
        secondLimitLine.lineWidth = _lineWidth
    }
    
    var borderLimitLines: [ChartLimitLine] {
        return [firstLimitLine, secondLimitLine]
    }
    
    /// set the line width of the chart (min = 0.2, max = 12); default 2
    @objc open override var lineWidth: CGFloat
        {
        get { return _lineWidth }
        set {
            if newValue < 0.2 {
                _lineWidth = 0.2
                
            } else {
                _lineWidth = newValue
            }
        }
    }
}
