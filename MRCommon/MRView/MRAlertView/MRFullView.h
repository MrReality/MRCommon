//
//  MRFullView.h
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRLabel.h"

@interface MRFullView : UIView

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) NSArray<MRIconLabelModel *> *models;
@property (nonatomic, strong, readonly) NSMutableArray<MRLabel *> *items;

@property (nonatomic, copy) void (^didClickFullView)(MRFullView *fullView);
@property (nonatomic, copy) void (^didClickItems)(MRFullView *fullView, NSInteger index);

- (void)endAnimationsCompletion:(void (^)(MRFullView *fullView))completion; // 动画结束后执行block

@end
