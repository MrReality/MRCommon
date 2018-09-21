//
//  BaseNavigation.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigation : UINavigationController

/// 是否是白色电池条
@property (nonatomic, assign) BOOL isWhiteStateBar;

/// 让导航栏透明
@property (nonatomic, assign) BOOL transparenceNavigationBar;

@end
