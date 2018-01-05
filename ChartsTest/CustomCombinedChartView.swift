//
//  CustomCombinedChartView.swift
//  ChartsTest
//
//  Created by Sergey Pugach on 1/5/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import Charts

class CustomCombinedChartView: CombinedChartView {
    
    @objc open var gridBackgroundImages = [NSUIImage]()
    
    
    override func draw(_ rect: CGRect) {

        let optionalContext = UIGraphicsGetCurrentContext()
        guard let context = optionalContext else { return }
        
        drawGridBackgroundImages(in: context)
        super.draw(rect)
    }
    
    @objc internal func drawGridBackgroundImages(in context: CGContext) {
        
        context.saveGState()
        defer { context.restoreGState() }

        context.clip(to: viewPortHandler.contentRect)
        
        let colors = [UIColor.yellow.cgColor, UIColor.blue.cgColor]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: colors as CFArray,
                                  locations: [0.0, 1.0])!

        let startPoint = CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentBottom)
        let endPoint = CGPoint(x: viewPortHandler.contentRight, y: viewPortHandler.contentTop)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
        gridBackgroundImages.forEach { UIImageView(image: $0).layer.render(in: context) }
    }
}
