//
//  MRWaterfallFlowLayout.m
//  WaterfallFlow
//
//  Created by shiyuanqi on 2017/4/7.
//  Copyright © 2017年 shiyuanqi. All rights reserved.
//

#import "MRWaterfallFlowLayout.h"

@interface MRWaterfallFlowLayout ()

/**
 存放每列高度字典
 */
@property (nonatomic, strong) NSMutableDictionary *dicOfheight;

/**
 存放所有 item 的 attrubutes 属性
 */
@property (nonatomic, strong) NSMutableArray *array;
/**
 计算每个 item 高度的 block，必须实现
 */
@property (nonatomic, copy) HeightBlock block;

@end

@implementation MRWaterfallFlowLayout

- (instancetype)init {

    self = [super init];
    if (self) {

        // 对默认属性进行设置
        // 默认行数     3 行
        // 默认行间距   10.0f
        // 默认列间距   10.0f
        // 默认内边距   top:10 left:10 bottom:10 right:10

        self.lineNumber = 10;
        self.rowSpacing = 10.0f;
        self.lineSpacing = 10.0f;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _dicOfheight = [NSMutableDictionary dictionary];
        _array = [NSMutableArray array];
    }
    return self;
}

// MARK: 准备好布局时调用
- (void)prepareLayout {

    [super prepareLayout];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];

    // 初始化好每列的高度
    for (NSInteger i = 0; i < self.lineNumber ; i++) {

        [_dicOfheight setObject:@(self.sectionInset.top) forKey:[NSString stringWithFormat:@"%ld",i]];
    }
    // 得到每个 item 的属性值进行存储
    for (NSInteger i = 0 ; i < count; i ++) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

// MARK: 设置可滚动区域范围
- (CGSize)collectionViewContentSize {

//    NSLog(@"collectionViewContentSize");

    __block NSString *maxHeightline = @"0";
    [_dicOfheight enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {

        if ([_dicOfheight[maxHeightline] floatValue] < [obj floatValue] ) {
            maxHeightline = key;
        }
    }];
    return CGSizeMake(self.collectionView.bounds.size.width, [_dicOfheight[maxHeightline] floatValue] + self.sectionInset.bottom);

}

// MARK: 返回视图框内 item 的属性，可以直接返回所有 item 属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _array;
}

// MARK: 计算 indexPath 下 item 的属性的方法
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    // 通过 indexPath 创建一个 item 属性 attr
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    // 计算 item 宽
    CGFloat itemW = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.lineNumber - 1) * self.lineSpacing) / self.lineNumber;
    CGFloat itemH = 0.0;

    // 计算 item 高
    if (self.block != nil) {

        itemH = self.block(indexPath, itemW);
    } else {

        NSAssert(itemH != 0,@"Please implement computeIndexCellHeightWithWidthBlock Method");
    }
    // 计算 item 的 frame
    CGRect frame;
    frame.size = CGSizeMake(itemW, itemH);

    // 循环遍历找出高度最短行
    __block NSString *lineMinHeight = @"0";
    [_dicOfheight enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {

        if ([_dicOfheight[lineMinHeight] floatValue] > [obj floatValue]) {

            lineMinHeight = key;
        }
    }];
    int line = [lineMinHeight intValue];

    // 找出最短行后，计算 item 位置
    frame.origin = CGPointMake(self.sectionInset.left + line * (itemW + self.lineSpacing), [_dicOfheight[lineMinHeight] floatValue]);
    _dicOfheight[lineMinHeight] = @(frame.size.height + self.rowSpacing + [_dicOfheight[lineMinHeight] floatValue]);
    attr.frame = frame;
    return attr;
}

// MARK: 设置计算高度 block 方法
- (void)computeIndexCellHeightWithWidthBlock:(HeightBlock)block {

    if (self.block != block) {

        self.block = block;
    }
}

@end
