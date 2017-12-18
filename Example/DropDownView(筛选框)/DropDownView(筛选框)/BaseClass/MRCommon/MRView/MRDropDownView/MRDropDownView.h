//
//  MRDropDownView.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeletedIndex)(NSInteger tag, NSInteger index);
typedef void (^ViewTapBlock)(void);

/// MARK: 类似淘宝选择价位的筛选框
@interface MRDropDownView : UIView

/**
 创建筛选器  Create a filter view
 @param frame frame
 @param options 放置 综合排序, 价格由高到低 的数组
 */
- (instancetype)initWithFrame:(CGRect)frame andOptions:(NSArray *)options;

/// 选中选项的索引, 不要用这个方法, 会内存泄漏, 用代理方法
- (void)didseletedWithBlock:(SeletedIndex)block;

/// 点击蒙版视图调用的 block
- (void)clickBackGroundBlock:(ViewTapBlock)block;

/// 关闭背景视图  close the view
- (void)closeBgView;

/// 标题大小
@property (nonatomic, assign) CGFloat titleFont;
/// 选项大小
@property (nonatomic, assign) CGFloat optionFont;
/// 正常颜色
@property (nonatomic, strong) UIColor *normalColor;
/// 选中颜色
@property (nonatomic, strong) UIColor *seletedColor;



@end
