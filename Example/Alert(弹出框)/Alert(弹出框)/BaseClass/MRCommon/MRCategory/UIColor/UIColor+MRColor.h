//
//  UUIColor+MRColor.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MRColor)

/// 使用 16 进制数字创建颜色，例如 0xFF0000 创建红色
///
/// @param hex 16 进制无符号 32 位整数
///
/// @return 颜色
+ (instancetype)colorWithHex:(uint32_t)hex;

/// 生成随机颜色 Generate random color
///
/// @return 随机颜色
+ (instancetype)randomColor;

@end
