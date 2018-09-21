//
//  MRSingleSwitch.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRSingleSwitch.h"
#import "UIView+MRView.h"

// 默认字体大小
#define kTitleFont  16
#define kTitleColor [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00]
#define kSingleButtonHeight 30       // 完整按钮的高
#define kSpace 5                     // 图片和 label 的距离
#define kButtonSpace  10             // 按钮和按钮之间的距离
#define kLabelHeight  30             // label 的高
#define kSeleImgName    @"MRSingleSwitch_选中.png"
#define kNormalImgName  @"MRSingleSwitch_未选中"

@interface MRSingleSwitch ()

/// 按钮数
@property (nonatomic, assign) NSInteger buttonCount;
/// 选项名称
@property (nonatomic, strong) NSArray *nameArray;
/// 切换按钮图片数组
@property (nonatomic, strong) NSMutableArray *imgViewArray;
/// 按钮数组
@property (nonatomic, strong) NSMutableArray *buttonArray;
/// label 数组
@property (nonatomic, strong) NSMutableArray *labelArray;
/// 是否设置默认选项了
@property (nonatomic, assign) BOOL isDef;

@property (nonatomic, copy) MRSignleSwitchBlock block;

@end

@implementation MRSingleSwitch

- (void)dealloc{
    NSLog(@"%@ --> delloc", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame andNameArray:(NSArray *)array{

    if(self = [super initWithFrame:frame]){

        self.buttonCount = array.count;
        self.nameArray = array;

        for (NSInteger i = 0; i < self.buttonCount; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            [self.imgViewArray addObject:imgView];
            
            UILabel *label = [[UILabel alloc] init];
            [self.labelArray addObject:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.buttonArray addObject:button];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    // 按钮完整的宽
    CGFloat buttonWidth = 0.0;
    // 选项字体大小
    NSInteger titleFont = self.titleFont ? self.titleFont : kTitleFont;
    // 字体颜色
    UIColor *titleColor = self.titleColor ? : kTitleColor;

    // 计算按钮宽度
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:titleFont];
    CGFloat imgWidth = kSingleButtonHeight - 2 * kSpace;
    for (NSString *str in self.nameArray) {
        label.text = str;
        [label sizeToFit];
        if(label.width > buttonWidth)
            buttonWidth = label.width;
    }
    buttonWidth += imgWidth + kButtonSpace;

    // 选项图片
    for(NSInteger i = 0; i < self.buttonCount; i++){

        UIImageView *imgView = self.imgViewArray[i];
        imgView.frame = CGRectMake(kButtonSpace + i * buttonWidth + i * kButtonSpace, self.bounds.size.height / 2 - imgWidth / 2, imgWidth, imgWidth);
        if(_defaultSelete == i && self.isDef == YES)
            imgView.image = [UIImage imageNamed:kSeleImgName];
        else
            imgView.image = [UIImage imageNamed:kNormalImgName];
        
        [self addSubview:imgView];
    }

    // 字
    CGFloat labelWidth = buttonWidth - kButtonSpace - imgWidth;
    for(NSInteger i = 0; i < self.buttonCount; i++){

        UILabel *label = self.labelArray[i];
        label.frame = CGRectMake(kButtonSpace + imgWidth + kSpace + i * buttonWidth + i * kButtonSpace, self.height / 2 - kLabelHeight / 2, labelWidth, kLabelHeight);
        label.textColor = titleColor;
        label.font = [UIFont systemFontOfSize:titleFont];
        label.text = self.nameArray[i];
        [self addSubview:label];
    }

    // 按钮
    for (NSInteger i = 0; i < self.buttonCount; i++) {

        UIButton *button = self.buttonArray[i];
        button.frame = CGRectMake(kButtonSpace + i * buttonWidth + i * kButtonSpace, self.bounds.size.height / 2 - kSingleButtonHeight / 2, buttonWidth, kSingleButtonHeight);
        button.tag = 900 + i;
        button.backgroundColor = [UIColor clearColor];
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonSeleted:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.width = self.buttonCount * (buttonWidth + kButtonSpace);
}

- (void)setDefaultSelete:(NSInteger)defaultSelete{

    self.isDef = YES;
    _defaultSelete = defaultSelete;

    if(_defaultSelete >= self.imgViewArray.count)
        return;
    UIImageView *imgView = self.imgViewArray[defaultSelete];
    imgView.image = [UIImage imageNamed:kSeleImgName];
}

// MARK: 按钮点击事件
- (void)buttonSeleted:(UIButton *)button{

    NSInteger index = button.tag - 900;
    for (UIImageView *imgView in self.imgViewArray) {
        imgView.image = [UIImage imageNamed:kNormalImgName];
    }

    UIImageView *imgView = self.imgViewArray[index];
    imgView.image = [UIImage imageNamed:kSeleImgName];

    if(self.block)
        self.block(index, self.tag);
}

- (void)didseleted:(MRSignleSwitchBlock)block{
    self.block = block;
}

/// MARK: 懒加载
- (NSMutableArray *)imgViewArray{
    if(!_imgViewArray){
        _imgViewArray = [NSMutableArray array];
    }
    return _imgViewArray;
}

- (NSMutableArray *)buttonArray{
    if(!_buttonArray){
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)labelArray{
    if(!_labelArray){
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}


@end
