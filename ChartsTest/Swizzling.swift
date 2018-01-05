//
//  Swizzling.swift
//  ChartsTest
//
//  Created by Sergey Pugach on 1/4/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation

let exchangeSwizzling: (Method?, Method?) -> () = { originalMethod, swizzledMethod in
    
    guard
        let originalMethod = originalMethod,
        let swizzledMethod = swizzledMethod else { return }
    
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

let swizzling: (AnyClass, Method?, Method?) -> () = { forClass, originalMethod, swizzledMethod in
    
    guard
        let originalMethod = originalMethod,
        let swizzledMethod = swizzledMethod else { return }
    
    let didAddMethod = class_addMethod(forClass, method_getName(originalMethod), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    
    if didAddMethod {
        class_replaceMethod(forClass, method_getName(swizzledMethod), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        
    } else {
        exchangeSwizzling(originalMethod, swizzledMethod)
    }
}
