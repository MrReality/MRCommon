//
//  MRCurtainView.h
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRLabel.h"

@class MRCurtainView;

typedef void(^CloseButtonClickBlock)(UIButton *button);
typedef void(^ClickItemBlock)(MRCurtainView *curtainView, NSInteger index);

/// MARK: 类似 QQ 空间式 窗帘弹窗
@interface MRCurtainView : UIView


@property (nonatomic, strong) NSArray<MRIconLabelModel *> *models;

@property (nonatomic, strong, readonly) NSMutableArray<MRLabel *> *items;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, assign) CGSize itemSize;


/// 点击关闭按钮的 block
- (void)tapCloseButton:(CloseButtonClickBlock)block;

/// 点击按钮的 block
- (void)tapItem:(ClickItemBlock)block;


@end
