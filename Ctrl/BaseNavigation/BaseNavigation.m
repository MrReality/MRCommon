//
//  BaseNavigation.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BaseNavigation.h"

@interface BaseNavigation ()<UIGestureRecognizerDelegate>
{
    id<UIGestureRecognizerDelegate> _delegate;
}

@end

@implementation BaseNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    //    self.navigationBar.barTintColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

// 设置电池颜色
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    
//    return UIStatusBarStyleLightContent;
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
//    self.interactivePopGestureRecognizer.delegate = _delegate;
}

#pragma mark - UIGestureRecognizerDelegate
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
