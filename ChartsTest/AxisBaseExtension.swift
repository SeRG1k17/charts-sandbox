//
//  AxisBaseExtension.swift
//  ChartsTest
//
//  Created by Sergey Pugach on 1/5/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import Charts


extension AxisBase {
    
    func addLimitLines(_ lines: [ChartLimitLine]) {
        lines.forEach { addLimitLine($0) }
    }
    
}
