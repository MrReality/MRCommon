//
//  MRHUD.h
//  PromptBox
//
//  Created by Mac on 2017/7/17.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

/// MARK: 弹窗
@interface MRHUD : UIView

/// 显示文字, state 显示的文字, centerY 弹窗中心点显示的 Y 轴位置, 如果为 0 则为居中
+ (void)showWithState:(NSString *)state andCenterY:(CGFloat)centerY;

/// 消失
+ (void)dismiss;

/// 延时消失
+ (void)dismissWithDelay:(NSInteger)timer;


@end
