//
//  UIButton+MRButton.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Touch)(UIButton *button);

@interface UIButton (MRButton)

/**
 按钮点击的 block,
 */
@property (nonatomic, copy) Touch block;

/**
 按钮点击事件的 block, The block of button click
 */
- (void)buttonActionWith:(Touch)block;
/**
 设置圆角   Set the rounded corners
 */
- (void)setCornerRadius:(NSInteger)cornerRadius;

@end
