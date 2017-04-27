//
//  MRButton.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRButton;
typedef void(^TouchBlock)(MRButton *button);

@interface MRButton : UIButton

/**
 按钮点击事件的 block
 */
- (void)buttonActionWith:(TouchBlock)block;

/**
 设置圆角
 */
- (void)setCornerRadius:(NSInteger)cornerRadius;
@end
