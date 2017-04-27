//
//  MRChangeView.m
//  ElevatorInspection
//
//  Created by shiyuanqi on 2017/4/27.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "MRChangeView.h"
#import "UIView+MRExtension.h"

/// 默认字体大小
#define kBaseTextFont 16
/// 默认未选中颜色
#define kTextNormalColor  [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00]
/// 默认选中颜色
#define kTextSeletedColor [UIColor colorWithRed:0.96 green:0.56 blue:0.40 alpha:1.00]
/// 边框颜色
#define kBorderColor [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1.00]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kSpace 5

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


- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
    
        self.delegate = self;
    }
    return self;
}

- (void)seletedIndex:(MRChangeViewBlock)block{
    self.block = block;
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.delegate = self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    NSArray *optionArray;
    self.labelWidth = 0;
    NSInteger index;
    
    if(_options){
        optionArray = _options;
    }else{
        NSAssert(!_options, @"需要传入选项数组");
        return;
    }
    
    self.normalColor = kTextNormalColor;
    self.seletedColor = kTextSeletedColor;
    
    if(_InitializeIndex){
        index = self.InitializeIndex;
    }else{
        index = 0;
    }
    
    if(!self.options.count){
        return;
    }

    /// 重新计算 frame
    UILabel *label = [[UILabel alloc] init];
    for (NSInteger i = 0; i < _options.count; i++) {
        
        label.text = _options[i];
        label.font = [UIFont systemFontOfSize:kBaseTextFont];
        [label sizeToFit];
        if(label.mr_width > self.labelWidth){
            self.labelWidth = label.mr_width;
        }
    }
    self.labelWidth += kSpace;
    /// 如果加起来的长度还是小于屏幕宽, 则平分宽度
    if(self.labelWidth * _options.count < kScreenWidth){
        self.labelWidth = kScreenWidth / _options.count;
    }
    
    self.contentSize = CGSizeMake(self.labelWidth * _options.count, self.mr_height);
    
    for (NSInteger i = 0; i < _options.count; i++) {
        
        UILabel *label = self.labelArray[i];
        label.mr_x = i * self.labelWidth;
        label.mr_width = self.labelWidth;
        label.mr_height = self.mr_height;
        label.mr_centerY = self.mr_height / 2;
        [self addSubview:label];
        label.textColor = self.normalColor;
        
        if(index == i){
            label.textColor = self.seletedColor;
            self.lineView.backgroundColor = self.seletedColor;
          
            if(_lineWidth){
                self.lineView.mr_width = _lineWidth;
            }else{
                self.lineView.mr_width = label.mr_width;
            }
            self.lineView.mr_centerX = label.mr_centerX;
            self.lineView.mr_y = self.mr_height - 3;
        }
        
        // 如果有热门话题, 加在这里
        UIButton *button = self.buttonArray[i];
        button.frame = label.frame;
        [self addSubview:button];
    }
}

- (void)setOptions:(NSArray *)options{

    _options = options;
    
    NSMutableArray *labelArray = [NSMutableArray array];
    NSMutableArray *buttonArray = [NSMutableArray array];

    /// 计算 label 最大宽
    for (NSInteger i = 0; i < _options.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _options[i];
        label.font = [UIFont systemFontOfSize:kBaseTextFont];
        [label sizeToFit];
        label.tag = 300 + i;
        [labelArray addObject:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 500 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:button];
    }
    self.labelWidth += kSpace;
    self.labelArray = labelArray;
    self.buttonArray = buttonArray;

    // 水平滑动条消失
    self.showsHorizontalScrollIndicator = NO;
    // 垂直滑动条消失
    self.showsVerticalScrollIndicator = NO;
}

- (void)buttonAction:(UIButton *)button{

    NSInteger index = button.tag - 500;
    
    for (UILabel *label in self.labelArray) {
        label.textColor = self.normalColor;
    }
    UILabel *label = self.labelArray[index];
    
    [UIView animateWithDuration:.2 animations:^{
        label.textColor = self.seletedColor;
        self.lineView.mr_centerX = label.mr_centerX;
    }];
    self.InitializeIndex = index;
    if(_block){
        self.block(self.tag, index);
    }
}

// MARK: 懒加载
- (UIView *)lineView{

    if(!_lineView){
    
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
        [self addSubview:_lineView];
        
//        self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mr_width, .5)];
//        self.topLine.backgroundColor = kBorderColor;
//        [self addSubview:self.topLine];
//        
//        
//        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.mr_height - .5, self.mr_width, .5)];
//        self.bottomLine.backgroundColor = kBorderColor;
//        [self addSubview:self.bottomLine];
    }
    return _lineView;
}


@end
