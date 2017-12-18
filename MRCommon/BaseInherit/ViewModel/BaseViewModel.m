//
//  BaseViewModel.m
//  面向协议+MVVM+RAC 普通网络请求
//
//  Created by Mac on 2017/12/8.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)dealloc{
    NSLog(@"%@ --> 😒 delloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
