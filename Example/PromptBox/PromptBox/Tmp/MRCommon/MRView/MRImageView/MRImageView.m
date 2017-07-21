//
//  MRImageView.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRImageView.h"

@interface MRImageView ()

@property (nonatomic, copy) ImageTap block;

@end

@implementation MRImageView

- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){

        
    }
    return self;
}

- (void)TapWithBlock:(ImageTap)block{

    self.block = block;
    self.userInteractionEnabled = YES;
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

// 设置圆角
- (void)setCornerRadius:(NSInteger)cornerRadius{

    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    // 开启离屏渲染
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
}



@end
