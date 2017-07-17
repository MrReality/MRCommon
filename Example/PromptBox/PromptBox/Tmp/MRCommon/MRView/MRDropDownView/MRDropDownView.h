//
//  MRDropDownView.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeletedIndex)(NSInteger tag, NSInteger index);

@protocol MRDropDelegate <NSObject>

/**
 MRDropDownView 被点击调用的 delegate, 只有筛选器被点开时才调用
 MRDropDownView clicked invoke the delegate, only call filter was clicked on
 */
- (void)viewDidTap;
/**
 点击选项调用的方法, 不要用下面那个 block, 会内存泄漏
 Click on the option method call
 */
- (void)seletedOptionWithSelfTag:(NSInteger)tag andIndex:(NSInteger)index;

@end

@interface MRDropDownView : UIView


/**
 创建筛选器  Create a filter view
 @param frame frame
 @param options 放置 综合排序, 价格由高到低 的数组
 */
- (instancetype)initWithFrame:(CGRect)frame andOptions:(NSArray *)options;
/**
 选中选项的索引, 不要用这个方法, 会内存泄漏, 用代理方法
 */
- (void)didseletedWithBlock:(SeletedIndex)block;
/**
 关闭背景视图  close the view
 */
- (void)closeBgView;
/**
 标题大小
 */
@property (nonatomic, assign) CGFloat titleFont;
/**
 选项大小
 */
@property (nonatomic, assign) CGFloat optionFont;
/**
 正常颜色
 */
@property (nonatomic, strong) UIColor *normalColor;
/**
 选中颜色
 */
@property (nonatomic, strong) UIColor *seletedColor;

/**
 delegate
 */
@property (nonatomic, weak) id <MRDropDelegate> delegate;


@end
