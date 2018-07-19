//
//  MRListDownView.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRListDownView.h"
#import "UIView+MRView.h"
#import "MRCommonOther.h"

#define kSpace 10

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 默认下拉栏背景颜色
#define kBackColor  [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00]
// 默认下拉栏线颜色
#define kLineColor  [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.00]
// 默认下拉栏字体颜色
#define kTitleColor [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00]
// 默认蒙版颜色
#define kBgColor    [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:.4]
// MARK: 尖和下拉栏的位置
#define kSkewing    15

@interface MRListDownView ()

/**
 背景的蒙版视图
 */
@property (nonatomic, strong) UIView *bgView;
/**
 下拉栏
 */
@property (nonatomic, strong) UIView *buttonView;
/**
 选项数组
 */
@property (nonatomic, strong) NSMutableArray *optionArray;
/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;
/**
 起始点坐标
 */
@property (nonatomic, assign) CGPoint beginPoint;
/**
 下拉栏的 尖
 */
@property (nonatomic, strong) UIImageView *sharpImgView;
@property (nonatomic, copy) MRListDownBlock block;
@property (nonatomic, copy) MRCloseBgBlock closeBlock;
@end

@implementation MRListDownView

- (void)dealloc{
    NSLog(@"%@ --> delloc", NSStringFromClass([self class]));
}

/**
 创建下拉 view
 @param options 按钮数组
 @param images  图片数组
 */
- (instancetype)initWithOptions:(NSArray *)options andImages:(NSArray *)images andBeginPoint:(CGPoint)point{

    if(self = [super initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)]){

        self.optionArray = [options mutableCopy];
        self.imageArray = [images mutableCopy];
        if(point.x == 0 && point.y == 0)
            self.beginPoint = CGPointMake(kScreenWidth - kSpace, kSpace / 2 + 64);
        else
            self.beginPoint = point;
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];

    // 下拉栏宽度
    CGFloat width = 0.0;
    // 下拉栏单个高度
    CGFloat height = self.height ? self.height : 40;
    // 下拉栏个数
    CGFloat count;
    // 字大小
    NSInteger font = self.titleFont ? self.titleFont : 15;
    // 标题色
    UIColor *titleColor = self.titleColor ? self.titleColor : kTitleColor;
    // 下拉栏背景色
    UIColor *backColor = self.listBackColor ? self.listBackColor : kBackColor;
    // 分割线颜色
    UIColor *lineColor = self.lineColor ? self.lineColor : kLineColor;
    // 圆角
    CGFloat cornerRadius = self.cornerRadius ? self.cornerRadius : 3;
    // 图片宽
    CGFloat imageWidth = self.imageWidth ? self.imageWidth : 20;

    // 如果没有数组, 就返回
    if(!self.optionArray.count)
        return;
    count = self.optionArray.count;

    // 计算 width
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    for (NSInteger i = 0; i < count; i++) {
        label.text = self.optionArray[i];
        [label sizeToFit];
        if(label.width > width)
            width = label.width;
    }
    if(self.imageArray.count){
        width += 3 * kSpace + imageWidth;
    }else{
        width += 2 * kSpace;
    }

    self.sharpImgView.left = self.beginPoint.x - 4;
    self.sharpImgView.top = self.beginPoint.y;
    // 下拉栏起始点的位置
    __block CGPoint buttonPoint;
    // 判断初始点的位置, 确定动画从左往右还是从右往左
    if(self.beginPoint.x < kScreenWidth / 2)          // 动画从左往右
        buttonPoint = CGPointMake(self.sharpImgView.left - kSkewing, self.beginPoint.y + self.sharpImgView.height);
    
    if(self.beginPoint.x > kScreenWidth / 2)          // 动画从右往左
        buttonPoint = CGPointMake(self.sharpImgView.left + kSkewing + self.sharpImgView.width, self.beginPoint.y + self.sharpImgView.height);
    
    self.buttonView.frame = CGRectMake(buttonPoint.x, buttonPoint.y, 0, 0);
    self.buttonView.layer.cornerRadius = cornerRadius;
    self.buttonView.backgroundColor = backColor;

    // 设置阴影
    self.buttonView.layer.shadowOpacity = .5;
    // 设置阴影偏移的方向和宽度
    self.buttonView.layer.shadowOffset = CGSizeMake(2, 3);
    self.buttonView.layer.shadowRadius = cornerRadius;
    self.buttonView.layer.shadowColor = lineColor.CGColor;

    CGFloat leftSpace;
    CGFloat labelWidht;
    if(self.imageArray.count){
        labelWidht = width - 2 * kSpace - imageWidth;
        if(self.imageType == ListDownImgTypeLeft)        // 右边有图片
            leftSpace = imageWidth + 2 * kSpace;
        else                                                                   // 左边有图片
            leftSpace = kSpace;
    
    }else{                          // 没有图片
        labelWidht = width - 2 * kSpace;
        leftSpace = kSpace;
    }


    CGFloat duration = 0.5 / count;
    for (NSInteger i = 0; i < count; i++) {
        [UIView animateWithDuration:duration animations:^{
            
            if(self.beginPoint.x > kScreenWidth / 2)           // 动画从右往左
                self.buttonView.left = buttonPoint.x - width;
            self.buttonView.width = width;
            self.buttonView.height = height * (i + 1);
        } completion:^(BOOL finished) {

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, height / 2 - 15 + height * i, labelWidht, 30)];
            label.font = [UIFont systemFontOfSize:font];
            [self.buttonView addSubview:label];
            label.text = self.optionArray[i];
            label.textColor = titleColor;

            // 如果有图片, 才创建图片
            if(self.imageArray.count){
                
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.width = imageWidth;
                imageView.height = imageWidth;
                imageView.top = height / 2 - imageWidth / 2 + i * height;
                if(!self.imageType)                // 图片在左边
                    imageView.left = kSpace;
                else                                       // 图片在右边
                    imageView.left = width - kSpace - imageWidth;
                
                imageView.image = [UIImage imageNamed:self.imageArray[i]];
                [self.buttonView addSubview:imageView];
            }

            if(i > 0){
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kSpace, i * height - .5, width - 2 * kSpace, .5)];
                line.backgroundColor = lineColor;
                line.alpha = .8;
                [self.buttonView addSubview:line];
            }

            // 创建 button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            [self.buttonView addSubview:button];
            button.frame = CGRectMake(0, i * height, width, height);
            button.tag = 300 + i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}

- (void)buttonAction:(UIButton *)button{

    [self closeView];
    // 延时调用
    [self performSelector:@selector(delayBLock:) withObject:button afterDelay:.2];
}

- (void)delayBLock:(UIButton *)button{
    if(_block)
        _block(self.tag, button.tag - 300);
}

- (void)clickWithBlock:(MRCloseBgBlock)block{
    self.closeBlock = block;
}


/// MARK: 关闭视图
- (void)closeView{

    self.buttonView.clipsToBounds = YES;
    [self.sharpImgView removeFromSuperview];
    self.sharpImgView = nil;
    [UIView animateWithDuration:.2 animations:^{
        self.buttonView.frame = CGRectMake(self.beginPoint.x, self.beginPoint.y, 0, 0);
    } completion:^(BOOL finished) {
        [self.buttonView removeFromSuperview];
        self.buttonView = nil;

        [self.bgView removeFromSuperview];
        self.bgView = nil;
        [self removeFromSuperview];
    }];
}

/// 选中调用的 block
- (void)seletedWithBlock:(MRListDownBlock)block{
    self.block = block;
}

- (void)closeDelay{
    if(_closeBlock)
        _closeBlock();
}

// MARK: 懒加载
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_bgView];
        _bgView.backgroundColor = kBgColor;
        [_bgView tapActionWithBlock:^{
            [self closeView];
            [self performSelector:@selector(closeDelay) withObject:nil afterDelay:.2];
        }];
    }
    return _bgView;
}

- (NSMutableArray *)optionArray{
    if(!_optionArray){
        _optionArray = [NSMutableArray array];
    }
    return _optionArray;
}

- (NSMutableArray *)imageArray{
    if(!_imageArray){
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (UIView *)buttonView{
    if(!_buttonView){
        _buttonView = [[UIView alloc] init];
        [self.bgView addSubview:_buttonView];
    }
    return _buttonView;
}

- (UIImageView *)sharpImgView{
    if(!_sharpImgView){
        _sharpImgView = [[UIImageView alloc] init];
        _sharpImgView.size = CGSizeMake(8, 6);
        _sharpImgView.image = [UIImage imageNamed:@"sharp_List.png"];
        [self.bgView addSubview:_sharpImgView];
    }
    return _sharpImgView;
}



@end
