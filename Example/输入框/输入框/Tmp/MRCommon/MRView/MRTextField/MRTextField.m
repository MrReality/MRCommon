//
//  MRTextField.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRTextField.h"

@implementation MRTextField

- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){

        [self _creatTF];
    }
    return self;
}

// 配置信息
- (void)_creatTF{

    self.borderStyle = UITextBorderStyleRoundedRect;
    // 输入文字的时候进行隐藏 (输入密码时候选 YES) 默认为 NO
    //    textFd.secureTextEntry = YES;
    // 编辑的时候清除之前的文字 (半透明的不清除) YES 为 清除
    self.clearsOnBeginEditing = NO;
    // 清除按钮   UITextFieldViewModeNever                没有清除按钮
    //               UITextFieldViewModeAlways               一直存在
    self.clearButtonMode = UITextFieldViewModeWhileEditing; // 编辑时存在

    // 设置弹出键盘的样式
    self.keyboardType = UIKeyboardTypeDefault;
    // 指定返回事件的类型
    self.returnKeyType = UIReturnKeySend;
}

@end
