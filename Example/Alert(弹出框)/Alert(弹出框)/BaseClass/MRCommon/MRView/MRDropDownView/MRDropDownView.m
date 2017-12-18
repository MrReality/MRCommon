//
//  MRDropDownView.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRDropDownView.h"
#import "UIView+MRExtension.h"
#import "UIView+MRView.h"

#define kSpace 10
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
// 筛选框 上下的图片
#define kDownImg [UIImage imageNamed:@"down_img.png"]
#define kUpImg [UIImage imageNamed:@"up_img.png"]
// 标题字默认大小
#define kTitleFont    15
// 选项字默认大小
#define kOptionFont   16
// 选中字体默认颜色
#define kSeletedColor [UIColor orangeColor]
// 未选中字体默认颜色
#define kNormalColor  [UIColor whiteColor]

@interface MRDropDownView ()

/**
 选项标题的 label
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 选项标题旁边 显示上下图片
 */
@property (nonatomic, strong) UIImageView *upDownImgView;
/**
 当选项栏拉开, bgView 出现
 */
@property (nonatomic, strong) UIView *bgView;
/**
 放置选项的 scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 选项数组
 */
@property (nonatomic, strong) NSArray *optionArray;
/**
 scrollView 的 高
 */
@property (nonatomic, assign) CGFloat scrollHeight;
/**
 选中索引
 */
@property (nonatomic, assign) NSInteger seletedIndex;
/**
 盖住界面的 半透明视图
 */
@property (nonatomic, strong) UIView *masView;
/**
 是否是打开状态
 */
@property (nonatomic, assign) BOOL isOpen;
// 边框线
@property (nonatomic, assign) UIView *lineView;
@property (nonatomic, copy) SeletedIndex block;
@end

@implementation MRDropDownView

- (instancetype)initWithFrame:(CGRect)frame andOptions:(NSArray *)options{

    if(self = [super initWithFrame:frame]){

        self.userInteractionEnabled = YES;
        self.optionArray = options;

        // 点击 调用代理
        [self tapActionWithBlock:^{
            if(self.isOpen == NO){
                if([self.delegate respondsToSelector:@selector(viewDidTap)]){
                    [self.delegate viewDidTap];
                }
            }
            self.isOpen = YES;

            // 如果背景视图存在, 就让他消失
            if(_bgView){
                [self closeBgView];
                return;
            }

            self.bgView.alpha = 1;
            self.upDownImgView.image = kUpImg;
            [UIView animateWithDuration:.25 animations:^{

                self.scrollView.mr_height = self.scrollHeight;
                self.masView.mr_y = self.scrollHeight;
            }];
        }];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];

    // 标题字大小
    CGFloat titleFont;
    // 选项字大小
    CGFloat optionFont;
    // 正常字大小
    UIColor *normalTextColor;
    // 选中颜色
    UIColor *seletedTextColor;

    if(_titleFont){
        titleFont = self.titleFont;
    }else{
        titleFont = kTitleFont;
    }

    if(_optionFont){
        optionFont = self.optionFont;
    }else{
        optionFont = kOptionFont;
    }

    if(_normalColor){
        normalTextColor = self.normalColor;
    }else{
        normalTextColor = kNormalColor;
    }

    if(_seletedColor){
        seletedTextColor = self.seletedColor;
    }else{
        seletedTextColor = kSeletedColor;
    }

    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    self.titleLabel.textColor = seletedTextColor;

    [self _initUIWithOptions:self.optionArray];
    [self addSubview:self.lineView];
}

// MARK: 根据选项设置 scrollView
- (void)_initUIWithOptions:(NSArray *)options{

    if(options.count < 5){
        self.scrollHeight = options.count * 40;
    }else{
        self.scrollHeight = 4 * 40;
    }

    CGFloat imgWidth = 15;
    self.upDownImgView.mr_size = CGSizeMake(imgWidth, imgWidth);

    self.titleLabel.text = self.optionArray[self.seletedIndex];
    [self.titleLabel sizeToFit];
    self.titleLabel.mr_centerY = self.mr_height / 2;
    self.titleLabel.mr_centerX = self.mr_width / 2 - 10;

    // 设置 上下图片的 frame
    self.upDownImgView.mr_x = self.titleLabel.mr_x + self.titleLabel.mr_width + 5;
    self.upDownImgView.mr_centerY = self.mr_height / 2;
}

- (void)didseletedWithBlock:(SeletedIndex)block{

    self.block = block;
}

// MARK: 关闭背景视图
- (void)closeBgView{

    [_bgView removeFromSuperview];
    _bgView = nil;
    self.upDownImgView.image = kDownImg;
    self.scrollView = nil;
    self.masView = nil;
    self.isOpen = NO;
}

// MARK: 懒加载
- (UILabel *)titleLabel{

    if(!_titleLabel){

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)upDownImgView{

    if(!_upDownImgView){

        _upDownImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_upDownImgView];
        _upDownImgView.image = kDownImg;
    }
    return _upDownImgView;
}

- (UIView *)bgView{

    if(!_bgView){

        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mr_y + self.mr_height + .5, kWidth, kHeight)];
        [self.superview addSubview:_bgView];
        _bgView.backgroundColor = [UIColor clearColor];

        self.masView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, _bgView.mr_height)];
        self.masView.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.11 alpha:1.00];
        self.masView.alpha = .25;
        [_bgView addSubview:self.masView];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBgView)];
        tapGesture.numberOfTapsRequired = 1;
        [_bgView addGestureRecognizer:tapGesture];
    }
    return _bgView;
}

- (UIScrollView *)scrollView{

    if(!_scrollView){

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0)];
        [self.bgView addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.clipsToBounds = YES;
        _scrollView.contentSize = CGSizeMake(kWidth, self.optionArray.count * 40);
        _scrollView.showsVerticalScrollIndicator = NO;

        // 创建选项
        for (NSInteger i = 0; i < self.optionArray.count; i++) {

            if(i == 0){
                // 最上面的线
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
                line.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.85 alpha:1.00];
                [_scrollView addSubview:line];
            }

            if(i > 0 && i <= self.optionArray.count - 1){

                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kSpace, i * 40, kWidth - kSpace, 1)];
                line.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.85 alpha:1.00];
                [_scrollView addSubview:line];
            }

            // 标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kSpace,i * 40, kWidth - 3 * kSpace - 20, 40)];
            if(!_normalColor){
                self.normalColor = [UIColor blackColor];
            }
            if(!_optionFont){
                self.optionFont = 15;
            }
            label.font = [UIFont systemFontOfSize:self.optionFont];
            label.textColor = self.normalColor;
            [_scrollView addSubview:label];
            label.text = self.optionArray[i];
            label.userInteractionEnabled = YES;
            label.tag = 100 + i;

            // MARK: label 点击事件
            [label tapActionWithBlock:^{
                NSInteger index = label.tag - 100;
                self.seletedIndex = index;

                // 更新 标题
                self.titleLabel.text = self.optionArray[self.seletedIndex];
                [self.titleLabel sizeToFit];
                self.titleLabel.mr_centerY = self.mr_height / 2;

                // 设置 上下图片的 frame
                self.upDownImgView.mr_x = self.titleLabel.mr_x + self.titleLabel.mr_width + 5;
                self.upDownImgView.mr_centerY = self.mr_height / 2;
                
                // 关闭 背景视图
                [self closeBgView];
                
                if(_block){
                    self.block(self.tag, index);
                }

                if([self.delegate respondsToSelector:@selector(seletedOptionWithSelfTag:andIndex:)]){
                    [self.delegate seletedOptionWithSelfTag:self.tag andIndex:index];
                }
            }];

            // 如果是选中索引, 变颜色
            if(i == self.seletedIndex){
                if(!_seletedColor){
                    self.seletedColor = [UIColor orangeColor];
                }
                label.textColor = self.seletedColor;

                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - kSpace - 16, i * 40 + 12, 16, 16)];
                imgView.image = [UIImage imageNamed:@"seleted_right.png"];
                [_scrollView addSubview:imgView];
            }
        }
    }
    return _scrollView;
}

- (UIView *)lineView{

    if(!_lineView){

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mr_width, .5)];
        line.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.85 alpha:1.00];
        [_scrollView addSubview:line];
        _lineView = line;
        [self addSubview:line];

        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.mr_height - .5, self.mr_width, .5)];
        line2.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.85 alpha:1.00];
        [_scrollView addSubview:line2];
        [self addSubview:line2];

        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, .5, self.mr_height)];
        line3.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.85 alpha:1.00];
        [_scrollView addSubview:line3];
        [self addSubview:line3];

        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(self.mr_width, 0, .5, self.mr_height)];
        line4.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.85 alpha:1.00];
        [_scrollView addSubview:line4];
        [self addSubview:line4];
    }
    return _lineView;
}

@end
