//
//  BaseNavigation.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BaseNavigation.h"

/// 当前设备版本
#define kDeviceVerson ([[UIDevice currentDevice].systemVersion floatValue])

/// 导航栏颜色
#define kNavBackGroundColor [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00]

@interface BaseNavigation ()<UIGestureRecognizerDelegate>{
    
    id<UIGestureRecognizerDelegate> _delegate;
}

@end

@implementation BaseNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = kNavBackGroundColor;
    if(kDeviceVerson < 11){         /// iOS 11 以下
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
//        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)setTransparenceNavigationBar:(BOOL)transparenceNavigationBar{
    if(transparenceNavigationBar == true){          /// 让导航栏透明
        self.navigationBar.translucent = YES;
        self.navigationBar.barTintColor = [UIColor clearColor];
        self.navigationBar.tintColor = [UIColor clearColor];
        [self.navigationBar setShadowImage:[UIImage new]];
        self.navigationBar.barStyle = UIBarStyleBlack;
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }else{                                                              /// 不让导航栏透明
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = kNavBackGroundColor;
    }
}

/// MARK: 屏幕旋转, 如果不想让屏幕旋转, 直接在 controller 中重写就好, 其他不用做
-(BOOL)shouldAutorotate {
    return self.viewControllers.lastObject.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.viewControllers.lastObject.supportedInterfaceOrientations;
}

/// MARK: 设置电池颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.viewControllers.lastObject.preferredStatusBarStyle;
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
//    self.interactivePopGestureRecognizer.delegate = _delegate;
}

/// MARK: UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    
//    return self.navigationController.childViewControllers.count > 1;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    
//    return self.navigationController.viewControllers.count > 1;
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    // fix 'nested pop animation can result in corrupted navigation bar'
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
//    [super pushViewController:viewController animated:animated];
//}
//
//- (void)navigationController:(UINavigationController *)navigationController
//       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

@end
