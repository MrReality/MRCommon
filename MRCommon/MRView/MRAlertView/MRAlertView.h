//
//  MRAlertView.h
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import <UIKit/UIKit.h>

/// MARK: 普通弹窗
@interface MRAlertView : UIView

- (instancetype)init NS_UNAVAILABLE;    // NS_UNAVAILABLE 禁止掉这个方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;


/**
 创建弹框
 @param title       标题(可为空)
 @param message     信息(可为空)
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;


/**
 创建弹框
 @param title       标题(可为空)
 @param message     信息(可为空)
 @param width width 指定宽度
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message andWidth:(CGFloat)width;

/// 添加单个按钮
- (void)addSignalButton:(UIButton *)button;

/// 添加取消按钮 确认按钮
- (void)addCancelButton:(UIButton *)cancelButton andOKButton:(UIButton *)okButton;

/// 线颜色
@property (nonatomic, strong) UIColor *lineColor;
/// 线是否隐藏
@property (nonatomic, assign) BOOL isLineHidden;
/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/// 消息
@property (nonatomic, strong, readonly) UILabel *messageLabel;

@end
