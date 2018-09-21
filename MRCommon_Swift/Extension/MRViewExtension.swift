//
//  MRViewExtension.swift
//  test
//
//  Created by mac on 2018/9/21.
//  Copyright © 2018年 mixReality. All rights reserved.
//

import UIKit

// MARK: view 延展
extension UIView {
    
    /// 截图
    func screenShot() -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 设置圆角
    func setConerRadius(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        /// 设置离屏渲染
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }
    
    /// 移除所有子视图
    func removeAllSubViews() {
        while self.subviews.count != 0 {
            if let child = subviews.last {
                child.removeFromSuperview()
            }
        }
    }
    
    /// 设置阴影
    /// - Parameters:
    ///   - color:      颜色
    ///   - radius:     半径
    ///   - offset:     偏移位置
    ///   - opacity:    不透明度
    func setShadow(color: UIColor, radius: CGFloat = 5, offset: CGSize = CGSize(width: 0, height: 2), opacity: CGFloat = 1) {
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowOpacity = Float(opacity)
    }
    
//    func tapActionWithBlock(_ closure: @escaping NoParamClouser) {
//        isUserInteractionEnabled = true
//        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(gestureAction(gesture:)))
//        addGestureRecognizer(gesture)
//    }
//
//    @objc func gestureAction(gesture: UITapGestureRecognizer) {
//        if gesture.state == .recognized {
//            Log("123")
////            void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
////            if (action) action();
//        }
//    }
//
    // MARK: --------------------------- 尺寸 ---------------------------
    /// 左
    func left() -> CGFloat { return frame.origin.x }
    func left<T>(_ value: T) {
        var frame = self.frame
        if value is Int     { frame.origin.x = CGFloat(value as! Int)    }
        if value is Double  { frame.origin.x = CGFloat(value as! Double) }
        if value is Float   { frame.origin.x = CGFloat(value as! Float)  }
        if value is CGFloat { frame.origin.x = value as! CGFloat         }
        if value is UInt    { frame.origin.x = CGFloat(value as! UInt)   }
        self.frame = frame
    }
    /// 顶部
    func top() -> CGFloat { return self.frame.origin.y }
    func top<T>(_ value: T) {
        var frame = self.frame
        if value is Int     { frame.origin.y = CGFloat(value as! Int)    }
        if value is Double  { frame.origin.y = CGFloat(value as! Double) }
        if value is Float   { frame.origin.y = CGFloat(value as! Float)  }
        if value is CGFloat { frame.origin.y = value as! CGFloat         }
        if value is UInt    { frame.origin.y = CGFloat(value as! UInt)   }
        self.frame = frame
    }
    /// 右侧
    func right() -> CGFloat { return frame.origin.x + frame.size.width }
    func right<T>(_ value: T) {
        var frame = self.frame
        if value is Int     { frame.origin.x = CGFloat(value as! Int) - frame.size.width    }
        if value is Double  { frame.origin.x = CGFloat(value as! Double) - frame.size.width }
        if value is Float   { frame.origin.x = CGFloat(value as! Float) - frame.size.width  }
        if value is CGFloat { frame.origin.x = value as! CGFloat - frame.size.width         }
        if value is UInt    { frame.origin.x = CGFloat(value as! UInt) - frame.size.width   }
        self.frame = frame
    }
    /// 底部
    func bottom() -> CGFloat { return frame.origin.y + frame.size.height }
    func bottom<T>(_ value: T) {
        var frame = self.frame
        if value is Int     { frame.origin.y = CGFloat(value as! Int) - frame.size.height    }
        if value is Double  { frame.origin.y = CGFloat(value as! Double) - frame.size.height }
        if value is Float   { frame.origin.y = CGFloat(value as! Float) - frame.size.height  }
        if value is CGFloat { frame.origin.y = value as! CGFloat - frame.size.height         }
        if value is UInt    { frame.origin.y = CGFloat(value as! UInt) - frame.size.height   }
        self.frame = frame
    }
    /// 宽度
    func width() -> CGFloat { return frame.size.width }
    func width<T>(_ value: T) {
        var frame = self.frame
        if value is Int     { frame.size.width = CGFloat(value as! Int)    }
        if value is Double  { frame.size.width = CGFloat(value as! Double) }
        if value is Float   { frame.size.width = CGFloat(value as! Float)  }
        if value is CGFloat { frame.size.width = value as! CGFloat         }
        if value is UInt    { frame.size.width = CGFloat(value as! UInt)   }
        self.frame = frame
    }
    /// 高度
    func height() -> CGFloat { return frame.size.height }
    func height<T>(_ value: T) {
        var frame = self.frame
        if value is Int     { frame.size.height = CGFloat(value as! Int)    }
        if value is Double  { frame.size.height = CGFloat(value as! Double) }
        if value is Float   { frame.size.height = CGFloat(value as! Float)  }
        if value is CGFloat { frame.size.height = value as! CGFloat         }
        if value is UInt    { frame.size.height = CGFloat(value as! UInt)   }
        self.frame = frame
    }
    /// x 方向中心
    func centerX() -> CGFloat { return center.x }
    func centerX<T>(_ value: T) {
        if value is Int     { center = CGPoint(x: CGFloat(value as! Int), y: center.y)    }
        if value is Double  { center = CGPoint(x: CGFloat(value as! Double), y: center.y) }
        if value is Float   { center = CGPoint(x: CGFloat(value as! Float), y: center.y)  }
        if value is CGFloat { center = CGPoint(x: value as! CGFloat, y: center.y)         }
        if value is UInt    { center = CGPoint(x: CGFloat(value as! UInt), y: center.y)   }
    }
    /// y 方向中心
    func centerY() -> CGFloat { return center.y }
    func centerY<T>(_ value: T) {
        if value is Int     { center = CGPoint(x: center.x, y: CGFloat(value as! Int))    }
        if value is Double  { center = CGPoint(x: center.x, y: CGFloat(value as! Double)) }
        if value is Float   { center = CGPoint(x: center.x, y: CGFloat(value as! Float))  }
        if value is CGFloat { center = CGPoint(x: center.x, y: value as! CGFloat)         }
        if value is UInt    { center = CGPoint(x: center.x, y: CGFloat(value as! UInt))   }
    }
    /// 尺寸
    func size() -> CGSize { return frame.size }
    func size(_ size: CGSize) {
        var frame = self.frame
        frame.size = size
        self.frame = frame
    }
    /// 位置
    func origin() -> CGPoint { return frame.origin }
    func origin(_ origin: CGPoint) {
        var frame = self.frame
        frame.origin = origin
        self.frame = frame
    }
    /// x 坐标最小值
    func minX() -> CGFloat { return left() }
    func minX<T>(_ value: T) { left(value) }
    /// x 坐标最大值
    func maxX() -> CGFloat { return right() }
    func maxX<T>(_ value: T) { right(value) }
    /// y 坐标最小值
    func minY() -> CGFloat { return top() }
    func minY<T>(_ value: T) { top(value) }
    /// y 坐标最大值
    func maxY() -> CGFloat { return bottom() }
    func maxY<T>(_ value: T) { bottom(value) }

}
