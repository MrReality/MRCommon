//
//  BaseCtrl.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface BaseCtrl : UIViewController 

/// 没有数据时, 给出的文本提示
@property (nonatomic, strong) UILabel *nonLabel;
/// 没有数据时, 给出的图片提示
@property (nonatomic, strong) UIImageView *nonImgView;
/// 中间的标题
@property (nonatomic, strong) UILabel *navigationLabel;
/// 是否是白色电池条
@property (nonatomic, assign) BOOL isWhiteStateBar;


/// 弹出键盘时调用的函数, height: 键盘高度, duration: 键盘弹出的时间
- (void)keyboardWillShowWithKeyBoardHeight:(CGFloat)height andDuration:(CGFloat)duration;

/// 横竖屏切换调用的函数
- (void)changeRotate;


@end
