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
    
    @objc open var drawGridBackgroundGradientEnabled = true
    @objc open var drawGridBackgroundImagesEnabled = true
    
    @objc open var gridBackgroundGradientColors = [NSUIColor]()
    @objc open var gridBackgroundGradientColorsLocations = [CGFloat]()
    
    @objc open var gridBackgroundImages = [NSUIImage]()
    
    
    override func draw(_ rect: CGRect) {

        let optionalContext = UIGraphicsGetCurrentContext()
        guard let context = optionalContext else { return }
        
        drawGridBackground(in: context)
        super.draw(rect)
    }
    
    @objc internal func drawGridBackground(in context: CGContext) {
        
        context.saveGState()
        defer { context.restoreGState() }
        
        context.clip(to: viewPortHandler.contentRect)
        
        drawGridBackgroundGradient(in: context)
        drawGridBackgroundImages(in: context)
    }

    @objc internal func drawGridBackgroundGradient(in context: CGContext) {
        
        guard
            drawGridBackgroundGradientEnabled,
            gridBackgroundGradientColors.count == gridBackgroundGradientColorsLocations.count
            else { return }
        
        let gradientColors = gridBackgroundGradientColors.map { $0.cgColor }
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: gradientColors as CFArray,
                                  locations: gridBackgroundGradientColorsLocations) else { return }
        
        let startPoint = CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentBottom)
        let endPoint = CGPoint(x: viewPortHandler.contentRight, y: viewPortHandler.contentTop)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
    }
    
    @objc internal func drawGridBackgroundImages(in context: CGContext) {
        
        guard drawGridBackgroundImagesEnabled else { return }
        gridBackgroundImages.forEach { UIImageView(image: $0).layer.render(in: context) }
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
