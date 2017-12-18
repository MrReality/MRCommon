//
//  BasePushCtrl.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BasePushCtrl.h"

#define kButtonWidth  30
#define kButtonHeight 30

@interface BasePushCtrl () <UIGestureRecognizerDelegate>

@end

@implementation BasePushCtrl

- (instancetype)init{
    
    if(self = [super init]){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancelButton];
    self.navigationItem.titleView = self.navigationLabel;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

//// 设置电池条颜色
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    
//    return UIStatusBarStyleLightContent;
//}

- (void)back:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: 懒加载
// 发送按钮
- (UIButton *)sendButton{
    
    if(!_sendButton){
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(0, 0, kButtonWidth, kButtonHeight);
//        [_sendButton setTitle:@"完成" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 将自定义的按钮视图添加到导航栏上显示
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_sendButton];
        // 将视图添加到右侧的导航栏上显示
        self.navigationItem.rightBarButtonItems = @[rightBarItem];
    }
    return _sendButton;
}

- (UIButton *)cancelButton{

    if(!_cancelButton){
        
        // 自定义返回按钮
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)];
        [button setImage:[UIImage imageNamed:@"return123.png"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = button;
    }
    return _cancelButton;
}


@end
