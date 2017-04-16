//
//  MRWaterfallFlowLayout.h
//  WaterfallFlow
//
//  Created by shiyuanqi on 2017/4/7.
//  Copyright © 2017年 shiyuanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath , CGFloat height);

@interface MRWaterfallFlowLayout : UICollectionViewLayout

/**
 *  列数
 */
@property (nonatomic, assign) NSInteger lineNumber;
/**
 *  行间距
 */
@property (nonatomic, assign) CGFloat rowSpacing;
/**
 *  列间距
 */
@property (nonatomic, assign) CGFloat lineSpacing;
/**
 *  内边距
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/**
 *  对象方法
 *
 *  @param block 在 block 中最后要返回一个 item 的高度
 */
- (void)computeIndexCellHeightWithWidthBlock:(HeightBlock)block;


@end
