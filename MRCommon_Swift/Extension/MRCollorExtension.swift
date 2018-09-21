//
//  MRCollorExtension.swift
//  test
//
//  Created by mac on 2018/9/21.
//  Copyright © 2018年 mixReality. All rights reserved.
//

import UIKit

// MARK: 颜色延展
extension UIColor {
    /// 256 颜色
    func rgb256Color(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat = 1.0) -> UIColor {
        return UIColor(red:CGFloat(r) / 255, green:CGFloat(g) / 255, blue:CGFloat(b) / 255, alpha:a)
    }
    
    /// 随机颜色
    func randomColor() -> UIColor {
        return UIColor(red:CGFloat(arc4random_uniform(256)), green:CGFloat(arc4random_uniform(256)), blue:CGFloat(arc4random_uniform(256)), alpha:1.00)
    }
    
    func hexColor(_ hex: UInt32) -> UIColor {
        let r = Int((hex & 0xff0000) >> 16)
        let g = Int((hex & 0x00ff00) >> 8)
        let b = Int(hex & 0x0000ff)
        return self.rgb256Color(r, g, b, 1)
    }
}
