//
//  LoginCtrl.m
//  输入框
//
//  Created by Mac on 2017/7/19.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "LoginCtrl.h"
#import "MRCommon.h"

@interface LoginCtrl ()


@property (strong, nonatomic) IBOutlet MRInputBoxView *accInput;

@property (strong, nonatomic) IBOutlet MRInputBoxView *passInput;

@end

@implementation LoginCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    /// 创建 UI
    [self _initUI];
}

/// MARK: 创建 UI
- (void)_initUI{
    
    self.navView.hidden = YES;

    self.accInput.textField.placeholder = @"请输入账号";
    /// 首次输入前有字符
    self.accInput.firstText = @"aaa";
    /// 提示图片
    self.accInput.showImage = [UIImage imageNamed:@"creat_sucess"];
    /// 提示文字
    self.accInput.stateText = @"账号";
    
    self.passInput.textField.placeholder = @"请输入密码";
    /// 不显示输入框的框
    self.passInput.isNoBorder = YES;
}



@end
