//
//  UIView+MRView.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MRView)

/**
 添加轻击手势 Add a tap gesture With UIView
 */
- (void)tapActionWithBlock:(void (^)(void))block;


@end
