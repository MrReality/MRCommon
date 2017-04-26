//
//  MRSingleSwitch.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MRSignleSwitchBlock)(NSInteger index, NSInteger MRSingleSwitchTag);

@interface MRSingleSwitch : UIView

/**
 默认选中索引   Selected by default index
 */
@property (nonatomic, assign) NSInteger defaultSelete;
/**
 字体大小
 */
@property (nonatomic, assign) NSInteger titleFont;
/**
 字体颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 选中按钮回调的 block  Select the button callback block
 index 是按钮的索引, MRSingleSwitchTag 为 view 的索引
 Is the index of the button, MRSingleSwitchTag index for the view
 @param block (NSInteger index, NSInteger MRSingleSwitchTag)
 */
- (void)didseleted:(MRSignleSwitchBlock)block;
/**
 根据数组创建单选 view  According to the array to create radio view
 */
- (instancetype)initWithFrame:(CGRect)frame andNameArray:(NSArray *)array;
@end
