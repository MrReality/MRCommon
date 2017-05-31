//
//  BasePresentCtrl.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BaseCtrl.h"
#import "MRButton.h"

@interface BasePresentCtrl : BaseCtrl

/**
 类似于导航栏的 view
 */
@property (nonatomic, strong) UIView *navView;
/**
 取消按钮
 */
@property (nonatomic, strong) MRButton *cancelButton;
/**
 发送按钮
 */
@property (nonatomic, strong) UIButton *sendButton;

/// 是否不能横屏
@property (nonatomic, assign) BOOL isNotLandscape;
///// 是否隐藏电池栏
//@property (nonatomic, assign) BOOL isHiddenStateBar;

@end
