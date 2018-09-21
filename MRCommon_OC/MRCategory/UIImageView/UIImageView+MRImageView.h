//
//  UIImageView+MRImageView.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageTap)(void);

@interface UIImageView (MRImageView)

/**
 图片点击的 block
 */
@property (nonatomic, copy) ImageTap block;


/**
 给 imageView 添加点击事件   Add the click event with UIImageView
 */
- (void)tapWithBlock:(ImageTap)block;
/**
 设置圆角   Set the rounded corners
 */
- (void)setCornerRadius:(NSInteger)cornerRadius;

@end
