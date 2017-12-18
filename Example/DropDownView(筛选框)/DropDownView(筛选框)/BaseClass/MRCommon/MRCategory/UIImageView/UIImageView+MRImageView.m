//
//  UIImageView+MRImageView.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "UIImageView+MRImageView.h"
#import <objc/runtime.h>

static const void *blockKey = &blockKey;

@implementation UIImageView (MRImageView)

@dynamic block;

- (void)setBlock:(ImageTap)block{
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ImageTap)block{
    return objc_getAssociatedObject(self, blockKey);
}


// 给 imageView 添加点击事件
- (void)tapWithBlock:(ImageTap)block{

    self.block = block;
    self.userInteractionEnabled = YES;
    if(!self.block){
        return;
    }
    // 创建轻击对象
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];

    // 设置单击触发事件 (默认就是1)
    tapGesture.numberOfTapsRequired = 1;

    // 将轻击对象添加到 imageView 上
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGestureAction{

    self.block();
}

/**
 设置圆角
 */
- (void)setCornerRadius:(NSInteger)cornerRadius{

    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    // 开启离屏渲染
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
}




@end
