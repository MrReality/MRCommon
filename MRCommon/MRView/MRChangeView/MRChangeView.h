//
//  MRChangeView.h
//  ElevatorInspection
//
//  Created by shiyuanqi on 2017/4/27.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import <UIKit/UIKit.h>
/// selfTag 是 MRChangeView 的 tag, seletedIndex 是点击的索引
typedef void(^MRChangeViewBlock)(NSInteger selfTag, NSInteger seletedIndex);

/// MARK: 导航栏下面左右切换的 view
@interface MRChangeView : UIScrollView
/// 选项数组
@property (nonatomic, strong) NSArray *options;

/// 下划线长度
@property (nonatomic, assign) CGFloat lineWidth;
/// 初始索引
@property (nonatomic, assign) NSInteger InitializeIndex;

/// 点击调用的 block
- (void)seletedIndex:(MRChangeViewBlock)block;

@end
