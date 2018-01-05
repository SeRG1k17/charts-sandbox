//
//  CustomYAxisRenderer.swift
//  ChartsTest
//
//  Created by Sergey Pugach on 1/5/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import Charts


class CustomYAxisRenderer: YAxisRenderer {
    
    @objc open var segmentedLimitLines = [SegmentedChartLimitLine]()
    
    @objc public init(for baseView: BarLineChartViewBase) {
        
        super.init(viewPortHandler: baseView.viewPortHandler, yAxis: baseView.leftAxis, transformer: baseView.getTransformer(forAxis: baseView.leftAxis.axisDependency))
    }
    
    open override func renderLimitLines(context: CGContext) {
        super.renderLimitLines(context: context)
        
        renderSegmentedLimitLines(in: context)
    }
    
    open func renderSegmentedLimitLines(in context: CGContext) {
        
        var limitLines = segmentedLimitLines
        
        for l in segmentedLimitLines {
            
            guard l.isEnabled else { continue }
            
            context.saveGState()
            defer { context.restoreGState() }
            
            renderSegmentedLimitLine(l, in: context)
        }
    }
    
    open func renderSegmentedLimitLine(_ l: SegmentedChartLimitLine, in context: CGContext) {
        
        guard
            let viewPortHandler = self.viewPortHandler,
            let transformer = self.transformer
            else { return }
        
        let trans = transformer.valueToPixelMatrix
        
        let firstPosition = position(for: l.firstLimitLine, trans: trans)
        let secondPosition = position(for: l.secondLimitLine, trans: trans)
        
        var startY = firstPosition.y + l.firstLimitLine.lineWidth / 2
        var endY = secondPosition.y - l.secondLimitLine.lineWidth / 2
        
        if startY > endY {
            
            startY = secondPosition.y + l.secondLimitLine.lineWidth / 2
            endY = firstPosition.y - l.firstLimitLine.lineWidth / 2
        }
        
        let width = viewPortHandler.contentRight - viewPortHandler.contentLeft
        let height = fabs(endY - startY)
        
        let rect = CGRect(x: viewPortHandler.contentLeft, y: startY, width: width, height: height)
        
        context.setFillColor(l.lineColor.cgColor)
        context.fill(rect)
    }
    
    func position(for limitLine: ChartLimitLine, trans: CGAffineTransform) -> CGPoint {
        
        var position: CGPoint = .zero
        position.x = 0.0
        position.y = CGFloat(limitLine.limit)
        position = position.applying(trans)
        
        return position
    }
}
