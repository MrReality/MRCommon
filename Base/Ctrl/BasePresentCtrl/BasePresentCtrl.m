//
//  BasePresentCtrl.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BasePresentCtrl.h"
#import "UIView+MRExtension.h"

#define kButtonWidth  40
#define kButtonHeight 30

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kIs_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 导航栏
#define kNavigationHeight   (kIs_iPhone_X ? (kIsVerticalScreen? 88 : 32) : (kIsVerticalScreen? 64 : 32))

/// 是否是竖屏
#define kIsVerticalScreen (kScreenHeight > kScreenWidth)
/// 真实屏幕高
#define kScreenRealHeight (MAX(kScreenWidth, kScreenHeight))
#define kIs_iPhone_X (kIs_iPhone && kScreenRealHeight == 812.0)

@interface BasePresentCtrl ()

@property (nonatomic, strong) UIView *line;

@end

@implementation BasePresentCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.cancelButton];
    [self.navView addSubview:self.sendButton];
    
    [self changeRotate];
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    [self changeRotate];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    if(self.isHiddenStateBar){      // 如果已经隐藏电池条, 则需要把电池条打开
//        self.isHiddenStateBar = NO;
//        [self prefersStatusBarHidden];
//    }
//}

- (BOOL)shouldAutorotate{
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    if(self.isNotLandscape){    // 不能横屏
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

// 监听横竖屏
- (void)changeRotate{
    
    [super changeRotate];
    
    if(self.isNotLandscape){    // 不能横屏
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _navView.frame = CGRectMake(0, 0, width, kNavigationHeight);
        _sendButton.frame = CGRectMake(width - kButtonWidth - 15, 20 + 7, kButtonWidth, kButtonHeight);
        _cancelButton.frame = CGRectMake(15, 20 + 7, kButtonWidth, kButtonHeight);
        _line.frame = CGRectMake(0, 64 - .5, _navView.mr_width, .5);
        self.navigationLabel.mr_centerX = width / 2;
        self.navigationLabel.mr_y = 20 + 44 / 2 - self.navigationLabel.mr_height / 2;
        return;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    /// 横屏
    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight){
        [UIView animateWithDuration:.5 animations:^{
            _navView.frame = CGRectMake(0, 0, width, 44);
            _sendButton.frame = CGRectMake(width - kButtonWidth - 15, 7, kButtonWidth, kButtonHeight);
            _cancelButton.frame = CGRectMake(15, 7, kButtonWidth, kButtonHeight);
            _line.frame = CGRectMake(0, 44 - .5, _navView.mr_width, .5);
            self.navigationLabel.mr_centerX = self.view.mr_centerX;
            self.navigationLabel.mr_y = 44 / 2 - self.navigationLabel.mr_height / 2;
        }];
    }else{          /// 竖屏
        [UIView animateWithDuration:.5 animations:^{
            _navView.frame = CGRectMake(0, 0, width, kNavigationHeight);
            _sendButton.frame = CGRectMake(width - kButtonWidth - 15, 20 + 7, kButtonWidth, kButtonHeight);
            _cancelButton.frame = CGRectMake(15, 20 + 7, kButtonWidth, kButtonHeight);
            _line.frame = CGRectMake(0, 64 - .5, _navView.mr_width, .5);
            self.navigationLabel.mr_centerX = self.view.mr_centerX;
            self.navigationLabel.mr_y = 20 + 44 / 2 - self.navigationLabel.mr_height / 2;
        }];
    }
}

//- (BOOL)prefersStatusBarHidden{
//    if(self.isHiddenStateBar){      // 隐藏电池条
//        return YES;
//    }
//    return NO;
//}

/// 返回按钮点击事件
- (void)back:(UIButton *)button{

    [self dismissViewControllerAnimated:YES completion:NULL];
}

// MARK: 懒加载
// 类似于导航栏的 view
- (UIView *)navView{
    
    if(!_navView){
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kNavigationHeight)];
        [self.view addSubview:_navView];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, _navView.mr_height, kScreenWidth, .5)];
        [_navView addSubview:self.line];
        self.line.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00];
        [_navView addSubview:self.navigationLabel];
    }
    return _navView;
}

// 取消按钮
- (UIButton *)cancelButton{
    
    if(!_cancelButton){
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20 + 7, kButtonWidth, kButtonHeight)];
        [self.navView addSubview:_cancelButton];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

// 发送按钮
- (UIButton *)sendButton{
    
    if(!_sendButton){
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(kScreenWidth - kButtonWidth - 15, 20 + 7, kButtonWidth, kButtonHeight);
        [_sendButton setTitle:@"完成" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return _sendButton;
}




@end
