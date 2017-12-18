//
//  ViewController.m
//  InputBox(输入框)
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"
#import "MRInputBoxView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 创建 UI
    [self _initUI];
    
    [self _action];
}

/// MARK: 创建 UI
- (void)_initUI{
    
    MRInputBoxView *inputBoxView = [[MRInputBoxView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, kInputViewHeight)];
    [self.view addSubview:inputBoxView];
    inputBoxView.textField.placeholder = @"请输入文字";
    /// 提示框字体大小, 默认 14
    inputBoxView.titleFont = 14;
    /// 设置输入框背景色, 默认灰色
    inputBoxView.backColor = [UIColor colorWithRed:0.94 green:1.00 blue:0.93 alpha:1.00];
    /// 显示图片
    inputBoxView.showImage = [UIImage imageNamed:@"show"];
    /// 是否不显示边框, 默认是 NO
    inputBoxView.isNoBorder = YES;
    /// 第一次的显示文字
    inputBoxView.firstText = @"first Hold Text";
    /// 当 textField 有文字时的提示文字, 默认为 textField placeholder 的文字
    inputBoxView.stateText = @"提示";
    
    MRInputBoxView *inputBox = [[MRInputBoxView alloc] initWithFrame:CGRectMake(0, 140, kScreenWidth, kInputViewHeight)];
    [self.view addSubview:inputBox];
    inputBox.textField.placeholder = @"test";
}

- (void)_action{
    @weakify(self);
    [self.view tapActionWithBlock:^{
        @strongify(self);
        [self.view endEditing:YES];
    }];
}



@end
