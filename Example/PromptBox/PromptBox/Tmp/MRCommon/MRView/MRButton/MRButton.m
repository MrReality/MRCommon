//
//  MRButton.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRButton.h"

@interface MRButton ()

@property (nonatomic, copy) TouchBlock block;

@end

@implementation MRButton

- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){

        // 按钮边框美化
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.adjustsImageWhenHighlighted = NO;

        // 为按钮添加阴影
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(3, 3);
//        self.layer.shadowRadius = 3;
    }
    return self;
}

- (void)buttonActionWith:(TouchBlock)block{

    self.block = block;
    // 调用此方法以触发block
    [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAction:(MRButton *)button{

    if(_block){
        self.block(button);
    }
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
