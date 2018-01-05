//
//  CustomXAxisRenderer.swift
//  ChartsTest
//
//  Created by Sergey Pugach on 1/4/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import Charts


public class CustomXAxisRenderer: XAxisRenderer {
    
    @objc open var subAxisLineColor = NSUIColor.gray
    
    @objc public init(for baseView: BarLineChartViewBase) {
        
        super.init(viewPortHandler: baseView.viewPortHandler, xAxis: baseView.xAxis, transformer: baseView.getTransformer(forAxis: baseView.leftAxis.axisDependency))
    }
    
    fileprivate var _axisLineSegmentsBuffer = [CGPoint](repeating: CGPoint(), count: 2)

    open override func renderAxisLine(context: CGContext)
    {
        guard
            let xAxis = self.axis as? XAxis,
            let viewPortHandler = self.viewPortHandler,
            let transformer = self.transformer
            else { return }

        if !xAxis.isEnabled || !xAxis.isDrawAxisLineEnabled {
            return
        }

        context.saveGState()
        defer { context.restoreGState() }

        //Light line(bottom)
        var lineWidth = xAxis.labelHeight * 2
        
        context.setStrokeColor(subAxisLineColor.cgColor)
        context.setLineWidth(xAxis.labelHeight * 2)
        
        renderAxisLine(in: context, lineWidth: lineWidth)
        
        
        //Dark line(top)
        lineWidth = xAxis.axisLineWidth
        
        context.setStrokeColor(xAxis.axisLineColor.cgColor)
        context.setLineWidth(lineWidth)
        
        if xAxis.axisLineDashLengths != nil, xAxis.entries.count >= 2 {
            
            let arraySlice = xAxis.entries[..<2]
            let valueToPixelMatrix = transformer.valueToPixelMatrix
            
            var position: CGPoint = .zero
            position.x = CGFloat(arraySlice[0])
            position.y = position.x
            position = position.applying(valueToPixelMatrix)
            
            var nextPosition: CGPoint = .zero
            nextPosition.x = CGFloat(arraySlice[1])
            nextPosition.y = nextPosition.x
            nextPosition = nextPosition.applying(valueToPixelMatrix)
            
            let length = nextPosition.x - position.x - xAxis.gridLineWidth
            context.setLineDash(phase: xAxis.axisLineDashPhase, lengths: [length, 0])

        } else {
            context.setLineDash(phase: 0.0, lengths: [])
        }

        renderAxisLine(in: context, lineWidth: -lineWidth)
    }
    
    private func renderAxisLine(in context: CGContext, lineWidth: CGFloat) {
        
        guard
            let xAxis = self.axis as? XAxis,
            let viewPortHandler = self.viewPortHandler
            else { return }
        
        let halfOfLineWidth = lineWidth / 2
        
        if xAxis.labelPosition == .top
            || xAxis.labelPosition == .topInside
            || xAxis.labelPosition == .bothSided
        {
            
            _axisLineSegmentsBuffer[0].x = viewPortHandler.contentLeft
            _axisLineSegmentsBuffer[0].y = viewPortHandler.contentBottom - halfOfLineWidth
            _axisLineSegmentsBuffer[1].x = viewPortHandler.contentRight
            _axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom - halfOfLineWidth
            context.strokeLineSegments(between: _axisLineSegmentsBuffer)
        }
        
        if xAxis.labelPosition == .bottom
            || xAxis.labelPosition == .bottomInside
            || xAxis.labelPosition == .bothSided
        {
            
            _axisLineSegmentsBuffer[0].x = viewPortHandler.contentLeft
            _axisLineSegmentsBuffer[0].y = viewPortHandler.contentBottom + halfOfLineWidth
            _axisLineSegmentsBuffer[1].x = viewPortHandler.contentRight
            _axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom + halfOfLineWidth
            context.strokeLineSegments(between: _axisLineSegmentsBuffer)
        }

    }
}
