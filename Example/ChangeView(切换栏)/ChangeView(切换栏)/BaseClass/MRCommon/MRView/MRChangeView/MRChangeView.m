//
//  MRChangeView.m
//  ElevatorInspection
//
//  Created by shiyuanqi on 2017/4/27.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "MRChangeView.h"
#import "UIView+MRView.h"

/// 默认字体大小
#define kBaseTextFont 16
/// 默认未选中颜色
#define kTextNormalColor  [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00]
/// 默认选中颜色
#define kTextSeletedColor [UIColor colorWithRed:0.20 green:0.67 blue:0.87 alpha:1.00]
/// 边框颜色
#define kBorderColor [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1.00]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kSpace 5

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object)              autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object)              autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object)              try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object)              try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object)            autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object)            autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object)            try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object)            try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

@interface MRChangeView() <UIScrollViewDelegate>
/// 字宽
@property (nonatomic, assign) CGFloat labelWidth;
/// label 数组
@property (nonatomic, strong) NSMutableArray *labelArray;
/// 按钮数组
@property (nonatomic, strong) NSMutableArray *buttonArray;
/// 正常颜色
@property (nonatomic, strong) UIColor *normalColor;
/// 选中颜色
@property (nonatomic, strong) UIColor *seletedColor;
/// 线
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) MRChangeViewBlock block;
@end

@implementation MRChangeView


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ --> delloc", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
    
        self.delegate = self;
        
        // 屏幕旋转调用的方法
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willChangeAction) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)seletedIndex:(MRChangeViewBlock)block{
    self.block = block;
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.delegate = self;
    
    // 屏幕旋转调用的方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willChangeAction) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)willChangeAction{
    
    [self layoutSubviews];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
    
    if(!self.options.count){
        NSAssert(!self.options.count, @"需要传入选项数组");
        return;
    }

    self.labelWidth = 0;
    NSInteger index = self.InitializeIndex ? self.InitializeIndex : 0;
    self.normalColor = kTextNormalColor;
    self.seletedColor = kTextSeletedColor;
    self.space = self.space ? : kSpace;
    
    /// 重新计算 frame
    UILabel *label = [[UILabel alloc] init];
    for (NSInteger i = 0; i < _options.count; i++) {
        
        label.text = _options[i];
        label.font = [UIFont systemFontOfSize:kBaseTextFont];
        [label sizeToFit];
        if(label.width > self.labelWidth){
            self.labelWidth = label.width;
        }
    }
    self.labelWidth += self.space;
    /// 如果加起来的长度还是小于屏幕宽, 则平分宽度
    if(self.labelWidth * _options.count < kScreenWidth){
        self.labelWidth = kScreenWidth / _options.count;
    }
    
    self.contentSize = CGSizeMake(self.labelWidth * _options.count, self.height);
    
    for (NSInteger i = 0; i < _options.count; i++) {
        
        UILabel *label = self.labelArray[i];
        label.left = i * self.labelWidth;
        label.width = self.labelWidth;
        label.height = self.height;
        label.centerY = self.height / 2;
        [self addSubview:label];
        label.textColor = self.normalColor;
        
        if(index == i){
            label.textColor = self.seletedColor;
            self.lineView.backgroundColor = self.seletedColor;
          
            if(_lineWidth){
                self.lineView.width = _lineWidth;
            }else{
                self.lineView.width = label.width;
            }
            self.lineView.centerX = label.centerX;
            self.lineView.top = self.height - 3;
        }
        
        // label 点击事件
        @weakify(self);
        [label tapActionWithBlock:^{
            @strongify(self);
            NSInteger index = label.tag - 300;
            
            for (UILabel *label in self.labelArray) {
                label.textColor = self.normalColor;
            }
            UILabel *label = self.labelArray[index];
            
            [UIView animateWithDuration:.2 animations:^{
                label.textColor = self.seletedColor;
                self.lineView.centerX = label.centerX;
            }];
            self.InitializeIndex = index;
            if(self.block){
                self.block(self.tag, index);
            }

        }];
    }
}

- (void)setOptions:(NSArray *)options{

    _options = options;
    
    NSMutableArray *labelArray = [NSMutableArray array];

    /// 计算 label 最大宽
    for (NSInteger i = 0; i < _options.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _options[i];
        label.font = [UIFont systemFontOfSize:kBaseTextFont];
        [label sizeToFit];
        label.tag = 300 + i;
        [labelArray addObject:label];
    }
    self.labelWidth += self.space;
    for (UILabel *label in self.labelArray) {
        [label removeFromSuperview];
    }
    self.labelArray = labelArray;

    // 水平滑动条消失
    self.showsHorizontalScrollIndicator = NO;
    // 垂直滑动条消失
    self.showsVerticalScrollIndicator = NO;
    
    [self layoutSubviews];
}

- (void)setChangeIndex:(NSInteger)changeIndex{

    for (UILabel *label in self.labelArray) {
        label.textColor = self.normalColor;
    }
    if(changeIndex < self.labelArray.count){
        UILabel *label = self.labelArray[changeIndex];
        
        [UIView animateWithDuration:.2 animations:^{
            label.textColor = self.seletedColor;
            self.lineView.centerX = label.centerX;
        }];
    }
}

- (void)buttonAction:(UIButton *)button{

    NSInteger index = button.tag - 500;
    
    for (UILabel *label in self.labelArray) {
        label.textColor = self.normalColor;
    }
    UILabel *label = self.labelArray[index];
    
    [UIView animateWithDuration:.2 animations:^{
        label.textColor = self.seletedColor;
        self.lineView.centerX = label.centerX;
    }];
    self.InitializeIndex = index;
    if(_block){
        self.block(self.tag, index);
    }
}

// MARK: 懒加载
- (UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 3)];
        _lineView.layer.cornerRadius = 1.5;
        [self addSubview:_lineView];
    }
    return _lineView;
}


@end
