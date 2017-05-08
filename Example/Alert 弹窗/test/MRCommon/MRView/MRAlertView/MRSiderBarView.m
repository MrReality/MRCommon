//
//  MRSiderBarView.m
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "MRSiderBarView.h"
#import "UIView+MRExtension.h"

@interface MRSiderBarView ()

@property (nonatomic, strong) MRLabel *settingItem;
@property (nonatomic, strong) MRLabel *nightItem;

@property (nonatomic, copy) SiderBarBlock block;
@end

@implementation MRSiderBarView


- (instancetype)init {
    if (self = [super init]) {
        _settingItem = [self itemWithText:@"设置" imageNamed:@"sidebar_settings"];
        
        [self addSubview:_settingItem];
        
        _nightItem = [self itemWithText:@"夜间模式" imageNamed:@"sidebar_NightMode"];
        [self addSubview:_nightItem];
    }
    return self;
}

- (MRLabel *)itemWithText:(NSString *)text imageNamed:(NSString *)imageNamed {
    
    MRLabel *item = [[MRLabel alloc] init];
    
    item.autoresizingFlexibleSize = YES;
    item.textLabel.textColor = [UIColor whiteColor];
    item.textLabel.font = [UIFont systemFontOfSize:13];
    item.imageEdgeInsets = UIEdgeInsetsMake(5, 15, 10, 15);
    item.model = [MRIconLabelModel modelWithTitle:text image:[UIImage imageNamed:imageNamed]];
    [item updateLayoutBySize:CGSizeMake(60, 90) finished:^(MRLabel *item) {
        item.mr_y = [UIScreen mainScreen].bounds.size.height - 20 - item.mr_height;
    }];
    return item;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _settingItem.mr_x =  50;
    
    _nightItem.mr_x = self.mr_width - 50 - _nightItem.mr_width;
}


- (void)setModels:(NSArray<NSString *> *)models {
    _items = @[].mutableCopy;
    CGFloat _gap = 15;
    
    [models enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MRLabel *item = [[MRLabel alloc] init];
        item.textLabel.font = [UIFont systemFontOfSize:15];
        item.textLabel.textColor = [UIColor whiteColor];
        item.textLabel.font = [UIFont systemFontOfSize:16.f];
        item.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 30);
        item.horizontalLayout = YES;
        item.autoresizingFlexibleSize = YES;
        item.model = [MRIconLabelModel modelWithTitle:text image:[UIImage imageNamed:[NSString stringWithFormat:@"sidebar_%@", text]]];
        [self addSubview:item];
        [_items addObject:item];
        [item updateLayoutBySize:CGSizeMake(150, 50) finished:^(MRLabel *item) {
            item.mr_y = (_gap + item.mr_height) * idx + 150;
            item.mr_centerX = self.mr_width / 2;
        }];
        item.tag = idx;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)tapItem:(SiderBarBlock)block{

    self.block = block;
}

- (void)itemClicked:(MRLabel *)sender {

    if(_block){
        self.block(self, sender.tag);
    }
}


@end
