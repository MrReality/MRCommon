//
//  BasePresentCtrl.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BasePresentCtrl.h"
#import "UIView+MRExtension.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BasePresentCtrl ()

@property (nonatomic, strong) UIView *line;

@end

@implementation BasePresentCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.cancelButton];
    [self.navView addSubview:self.sendButton];
    
    // 监听横竖屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    [self changeRotate:nil];
}

// 设置电池条颜色
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    
//    return UIStatusBarStyleLightContent;
//}

// 监听横竖屏
- (void)changeRotate:(NSNotification*)noti {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        [UIView animateWithDuration:.5 animations:^{
            
            _navView.frame = CGRectMake(0, 0, width, 64);
            _sendButton.frame = CGRectMake(width - 50, 20 + 7, 40, 30);
            _cancelButton.frame = CGRectMake(10, 20 + 7, 40, 30);
            _line.frame = CGRectMake(0, 64 - .5, _navView.mr_width, .5);
            self.navigationLabel.mr_centerX = self.view.mr_centerX;
            self.navigationLabel.mr_y = 20 + 44 / 2 - self.navigationLabel.mr_height / 2;
        }];
    } else {
        //横屏
        [UIView animateWithDuration:.5 animations:^{
            
            _navView.frame = CGRectMake(0, 0, width, 44);
            _sendButton.frame = CGRectMake(width - 50, 7, 40, 30);
            _cancelButton.frame = CGRectMake(10, 7, 40, 30);
            _line.frame = CGRectMake(0, 44 - .5, _navView.mr_width, .5);
            self.navigationLabel.mr_centerX = self.view.mr_centerX;
            self.navigationLabel.mr_y = 44 / 2 - self.navigationLabel.mr_height / 2;
        }];
    }
}

// MARK: 懒加载
// 类似于导航栏的 view
- (UIView *)navView{
    
    if(!_navView){
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        [self.view addSubview:_navView];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, _navView.mr_height, kScreenWidth, .5)];
        [_navView addSubview:self.line];
        self.line.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00];
        [_navView addSubview:self.navigationLabel];
    }
    return _navView;
}

// 取消按钮
- (MRButton *)cancelButton{
    
    if(!_cancelButton){
        
        _cancelButton = [[MRButton alloc] initWithFrame:CGRectMake(10, 20 + 7, 40, 30)];
        [self.navView addSubview:_cancelButton];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        __weak typeof(self)weakSelf = self;
        [_cancelButton buttonActionWith:^(MRButton *button) {
            
            [weakSelf dismissViewControllerAnimated:YES completion:NULL];
        }];
    }
    return _cancelButton;
}

// 发送按钮
- (UIButton *)sendButton{
    
    if(!_sendButton){
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(kScreenWidth - 50, 20 + 7, 40, 30);
        [_sendButton setTitle:@"完成" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return _sendButton;
}




@end
