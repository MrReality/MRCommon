//
//  UIButton+MRButton.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "UIButton+MRButton.h"
#import <objc/runtime.h>

static const void *blockKey = &blockKey;

@implementation UIButton (MRButton)

@dynamic block;

// 用 Runtime 强制给类目添加属性
- (void)setBlock:(Touch)block{
    
    objc_setAssociatedObject(self, blockKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (Touch)block{
    
    return objc_getAssociatedObject(self, blockKey);
}


- (void)buttonActionWith:(Touch)block{
    
    self.block = block;
    // 调用此方法以触发block
    if(!self.block){
        return;
    }
    [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAction:(UIButton *)button{
    
    if(self.block){
        self.block(button);
    }
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
