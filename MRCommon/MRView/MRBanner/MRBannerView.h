//
//  MRBannerView.h
//  轮播图
//
//  Created by Mac on 2017/7/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 点击轮播图的 block, selfId 自己的 id, index 索引
typedef void(^ClickBannerBlock)(NSInteger selfId, NSInteger index);
/// 轮播图滚动调用的 block, selfId 自己的 id, index 索引
typedef void(^BannerChangeBlock)(NSInteger selfId, NSInteger index);

/// MARK: 轮播图
@interface MRBannerView : UIView


/**
 创建轮播图
 @param array 图片名数组
 @param frame 轮播图的 frame
 */
- (instancetype)initWithImageNameArray:(NSMutableArray *)array andFrame:(CGRect)frame;

/// 图片名称数组
@property (nonatomic, strong) NSMutableArray *imgNameArray;

/// 点
@property (nonatomic, strong) UIPageControl *pageControl;

/// 点的高度
@property (nonatomic, assign) CGFloat pageTop;

/// 动画时间间隔
@property (nonatomic, assign) CGFloat interval;

//@property (nonatomic, strong)

/// 点击轮播图片调用的 block, index = 1 为第一张图片
- (void)clickBannerWithBlock:(ClickBannerBlock)block;
/// 轮播图滚动调用的 block, 会调很多次
- (void)bannerChangeWithBlock:(BannerChangeBlock)block;

@end
