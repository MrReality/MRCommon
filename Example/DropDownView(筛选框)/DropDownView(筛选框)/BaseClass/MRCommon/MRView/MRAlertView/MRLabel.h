//
//  MRLabel.h
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRIconLabelModel;

@interface MRLabel : UIControl

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

// UIEdgeInsets insets = {top, left, bottom, right}
/// default = UIEdgeInsetsZero 使用insets.bottom 或 insets.right 来调整间距
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
/// default is NO.
@property (nonatomic, assign) BOOL horizontalLayout;

/// default is NO. 根据内容适应自身高度
@property (nonatomic, assign) BOOL autoresizingFlexibleSize;

/// textLabel根据文本计算size时，如果纵向布局则限高，横向布局则限宽
@property (nonatomic, assign) CGFloat sizeLimit;

@property (nonatomic, strong) MRIconLabelModel *model;

/// 属性赋值后需更新布局
- (void)updateLayoutBySize:(CGSize)size finished:(void (^)(MRLabel *item))finished;

@end


@interface MRIconLabelModel : NSObject
/// 图片名
@property (nonatomic, strong) UIImage *icon;
/// 正文
@property (nonatomic, strong) NSString *text;
+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image;

@end
