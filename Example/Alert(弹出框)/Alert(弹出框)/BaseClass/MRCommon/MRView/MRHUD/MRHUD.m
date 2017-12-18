//
//  MRHUD.m
//  PromptBox
//
//  Created by Mac on 2017/7/17.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRHUD.h"
#import "MRCommon.h"

/// 弹窗背景色
#define kBackGroundColor [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.00]
/// 字体颜色
#define kTitleColor [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00]
/// 字体大小
#define kTitleFont 14
/// 空隙
#define kSpace 5
/// 弹窗高度
#define kHUDHeight 30
/// 圆角
#define kCornerRadius 5
/// 动画时间
#define kDuration .1


@interface MRHUD ()

/// window
@property (nonatomic, strong) UIWindow *window;
/// 提示文字
@property (nonatomic, strong) UILabel *label;
/// 中心点 Y 轴坐标
@property (nonatomic, assign) CGFloat cenY;


@end

@implementation MRHUD

/// MARK: 单例
+ (instancetype)sharedInstance{

    static MRHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MRHUD alloc] init];
    });
    return instance;
}

/// MARK: 显示文字
/// 显示文字, state 显示的文字, centerY 弹窗中心点显示的 Y 轴位置, 如果为 0 则为居中
+ (void)showWithState:(NSString *)state andCenterY:(CGFloat)centerY{
    
//    [MRHUD dismiss];
    
    MRHUD *hud = [MRHUD sharedInstance];
    hud.alpha = 1;
    hud.label.text = state;
    [hud.label sizeToFit];
    /// 如果为 0, 则直接设置为中心点
    hud.cenY = centerY == 0 ? hud.window.height / 2 : centerY;
    
    hud.backgroundColor = kBackGroundColor;
    hud.layer.cornerRadius = kCornerRadius;
    // 开启离屏渲染
    hud.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    hud.layer.shouldRasterize = YES;
    hud.layer.masksToBounds = YES;
    
    /// 弹窗和文字实际大小
    CGSize labelSize = hud.label.size;
    CGSize hudSize = CGSizeMake(hud.label.width + kSpace * 2, kHUDHeight);
    
    hud.frame = CGRectMake(hud.window.width / 2, hud.cenY, 0, 0);
    hud.label.frame = CGRectMake(hud.width / 2, hud.height / 2, 0, 0);
    
    [UIView animateWithDuration:kDuration animations:^{
        
        hud.size = hudSize;
        hud.centerX = hud.window.width / 2;
        hud.centerY = hud.cenY;
        
        hud.label.size = labelSize;
        hud.label.centerX = hud.width / 2;
        hud.label.centerY = hud.height / 2;
        [hud.window addSubview:hud];
    }];
}

/// MARK: 消失
+ (void)dismiss{
    
    MRHUD *hud = [MRHUD sharedInstance];
    /// 找到 hud 并移除
    for (UIView *view in hud.window.subviews) {
        if([view isKindOfClass:[MRHUD class]]){
            [view removeFromSuperview];
        }
    }
}

/// MARK: 延时消失
+ (void)dismissWithDelay:(NSInteger)timer{

    MRHUD *hud = [MRHUD sharedInstance];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
        [UIView animateWithDuration:kDuration animations:^{
            hud.frame = CGRectMake(hud.window.width / 2, hud.cenY, 0, 0);
            hud.label.frame = CGRectMake(hud.width / 2, hud.height / 2, 0, 0);
            hud.alpha = 0;
            
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
        }];
    });
}

/// MARK: 懒加载
- (UIWindow *)window{

    if(!_window){
        _window = [UIApplication sharedApplication].keyWindow;
    }
    return _window;
}

- (UILabel *)label{
    
    if(!_label){
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:kTitleFont];
        _label.textColor = kTitleColor;
        [[MRHUD sharedInstance] addSubview:_label];
    }
    return _label;
}


@end
