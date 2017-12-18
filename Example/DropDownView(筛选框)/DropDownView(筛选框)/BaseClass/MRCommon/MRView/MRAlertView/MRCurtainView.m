//
//  MRCurtainView.m
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "MRCurtainView.h"
#import "UIView+MRView.h"

#define kRowCount 3 // 每行显示3个

@interface MRCurtainView ()

@property (nonatomic, copy) CloseButtonClickBlock closeBlock;
@property (nonatomic, copy) ClickItemBlock clickBlock;
@end


@implementation MRCurtainView

- (void)dealloc{

    NSLog(@"%@ --> delloc", self);
}

- (instancetype)init {
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.size = CGSizeMake(35, 35);
        _closeButton.left = [UIScreen mainScreen].bounds.size.width - 35 - 15;
        _closeButton.top = 30;
        
        [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return self;
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
}

- (void)setModels:(NSArray<MRIconLabelModel *> *)models {
    
    if (CGSizeEqualToSize(CGSizeZero, _itemSize)) {
        _itemSize = CGSizeMake(60, 90);
    }
    CGFloat _gap = 35;
    CGFloat _space = (self.width - kRowCount * _itemSize.width) / (kRowCount + 1);
    
    _items = [NSMutableArray arrayWithCapacity:models.count];
    [models enumerateObjectsUsingBlock:^(MRIconLabelModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger l = idx % kRowCount;
        NSInteger v = idx / kRowCount;
        
        MRLabel *item = [[MRLabel alloc] init];
        [self addSubview:item];
        [_items addObject:item];
        item.model = model;
        item.iconView.tag = idx;
        [item.iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClicked:)]];
        
        [item updateLayoutBySize:CGSizeMake(_itemSize.width , _itemSize.height + 20)
                        finished:^(MRLabel *item) {
                            item.left = _space + (_itemSize.width  + _space) * l;
                            item.top = _gap + (_itemSize.height + _gap) * v + 45;
                        }];
        
        if (idx == models.count - 1) {
            self.height = item.height + item.top + 20;
        }
    }];
}

- (void)tapCloseButton:(CloseButtonClickBlock)block{

    self.closeBlock = block;
}

- (void)tapItem:(ClickItemBlock)block{

    self.clickBlock = block;
}

- (void)close:(UIButton *)button {
 
    if(_closeBlock){
        self.closeBlock(button);
    }
}

- (void)iconClicked:(UITapGestureRecognizer *)g {

    if(_clickBlock){
        self.clickBlock(self, g.view.tag);
    }
}



@end
