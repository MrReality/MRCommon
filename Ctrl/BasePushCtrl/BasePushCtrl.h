//
//  BasePushCtrl.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BaseCtrl.h"

@interface BasePushCtrl : BaseCtrl
/// 发送按钮
@property (nonatomic, strong) UIButton *sendButton;
/// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;

/// 返回按钮点击事件
- (void)back:(UIButton *)button;


@end

