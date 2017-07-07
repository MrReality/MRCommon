//
//  MRImageView.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageTap)();

@interface MRImageView : UIImageView

// 给 imageView 添加点击事件
- (void)TapWithBlock:(ImageTap)block;
/**
 设置圆角
 */
- (void)setCornerRadius:(NSInteger)cornerRadius;


@end
