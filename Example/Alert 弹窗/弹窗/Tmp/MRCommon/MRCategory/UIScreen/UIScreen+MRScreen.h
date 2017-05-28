//
//  UIScreen+MRScreen.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (MRScreen)

/// 屏幕宽度 Access to screen width
+ (CGFloat)width;
/// 屏幕高度 Access to the screen height
+ (CGFloat)height;
/// 分辨率 Get the screen resolution
+ (CGFloat)scale;

@end
