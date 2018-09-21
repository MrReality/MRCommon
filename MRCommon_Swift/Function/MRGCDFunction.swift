//
//  MRGCDFunction.swift
//  test
//
//  Created by mac on 2018/9/21.
//  Copyright © 2018年 mixReality. All rights reserved.
//

import UIKit

// MARK: gcd 相关方法

typealias Task = (_ cancel: Bool) -> Void

/// 延时调用
func delay(_ time: TimeInterval, task: @escaping () -> ()) -> Task? {
    func dispatch_later(block: @escaping () -> ()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure: (() -> Void)? = task
    var result: Task?
    
    let delayedClosure: Task = { cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result
}

/// 取消延时调用
func cancel(_ task: Task?) {
    task?(true)
}

