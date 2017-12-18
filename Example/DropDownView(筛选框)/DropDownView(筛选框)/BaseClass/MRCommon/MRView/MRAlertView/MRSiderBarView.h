//
//  MRSiderBarView.h
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRLabel.h"

@class MRSiderBarView;

typedef void(^SiderBarBlock)(MRSiderBarView *siderBarView, NSInteger index);

/// MARK: 侧拉一个 view, 类似与 MMDrawcontroller
@interface MRSiderBarView : UIView

@property (nonatomic, strong) NSArray<NSString *> *models;
@property (nonatomic, strong, readonly) NSMutableArray<MRLabel *> *items;

/// 点击按钮调用的 block
- (void)tapItem:(SiderBarBlock)block;
@end
