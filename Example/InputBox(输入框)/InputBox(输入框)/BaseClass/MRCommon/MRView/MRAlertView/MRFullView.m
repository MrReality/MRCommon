//
//  MRFullView.m
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "MRFullView.h"
#import "UIView+MRExtension.h"
#import "NSDate+MRDate.h"

#define kRow_count  4       // 每行显示 4 个
#define kRows       2       // 每页显示 2 行
#define kPages      2       // 共 2 页

#define kDateColor [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00]  // 日期字体颜色
#define kWeekColor [UIColor colorWithRed:0.95 green:0.13 blue:0.19 alpha:1.00]  // 星期字体颜色
#define kTextColor [UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1.00]  // label 字体颜色

@interface MRFullView () <UIScrollViewDelegate> {
    CGFloat _gap, _space;
}
@property (nonatomic, strong) UILabel  *dateLabel;
@property (nonatomic, strong) UILabel  *weekLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *closeIcon;
@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *pageViews;


@end

@implementation MRFullView

- (void)dealloc{

    NSLog(@"%@ --> delloc", self);
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewClicked:)]];
        
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont fontWithName:@"Heiti SC" size:42];
        _dateLabel.textColor = kDateColor;
        _dateLabel.textColor = [UIColor blackColor];
        [self addSubview:_dateLabel];
        
        _weekLabel = [UILabel new];
        _weekLabel.numberOfLines = 0;
        _weekLabel.font = [UIFont fontWithName:@"Heiti SC" size:12];
        _weekLabel.textColor = kWeekColor;
        [self addSubview:_weekLabel];
        
        _closeButton = [UIButton new];
        _closeButton.backgroundColor = [UIColor whiteColor];
        _closeButton.userInteractionEnabled = NO;
        [_closeButton addTarget:self action:@selector(closeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        
        _closeIcon = [UIButton new];
        _closeIcon.userInteractionEnabled = NO;
        _closeIcon.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_closeIcon setImage:[UIImage imageNamed:@"sina_关闭"] forState:UIControlStateNormal];
        [self addSubview:_closeIcon];
        
        [self setContent];
        [self commonInitialization];
    }
    return self;
}

- (void)setContent {
    NSDate *date = [NSDate date];
    _dateLabel.text = [NSString stringWithFormat:@"%.2ld", (long)date.day];
    _dateLabel.mr_size = [_dateLabel sizeThatFits:CGSizeMake(40, 40)];
    _dateLabel.mr_x = 15;
    _dateLabel.mr_y = 65;
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", date.dayFromWeekday, [date stringWithFormat:[NSDate myFormat]]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [paragraphStyle setLineSpacing:5];
    _weekLabel.attributedText = string;
    _weekLabel.mr_size = [_weekLabel sizeThatFits:CGSizeMake(100, 40)];
    _weekLabel.mr_x = _dateLabel.mr_x + _dateLabel.mr_y + 10;
    _weekLabel.mr_centerY = _dateLabel.mr_centerY;
    
    _closeButton.mr_size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 44);
    _closeButton.mr_y = [UIScreen mainScreen].bounds.size.height - _closeButton.mr_height;
    _closeIcon.mr_size = CGSizeMake(30, 30);
    _closeIcon.center = _closeButton.center;
}

- (void)commonInitialization {
    _scrollContainer = [[UIScrollView alloc] init];
    _scrollContainer.bounces = YES;
    _scrollContainer.pagingEnabled = YES;
    _scrollContainer.showsHorizontalScrollIndicator = NO;
    _scrollContainer.delaysContentTouches = YES;
    _scrollContainer.delegate = self;
    [self addSubview:_scrollContainer];
    
    _itemSize = CGSizeMake(60, 95);
    _gap = 15;
    _space = ([UIScreen mainScreen].bounds.size.width - kRow_count * _itemSize.width) / (kRow_count + 1);
    
    _scrollContainer.mr_size = CGSizeMake([UIScreen mainScreen].bounds.size.width, _itemSize.height * kRows + _gap  + 150);
    _scrollContainer.mr_y = [UIScreen mainScreen].bounds.size.height - _closeButton.mr_height - _scrollContainer.mr_height;
    _scrollContainer.contentSize = CGSizeMake(kPages * [UIScreen mainScreen].bounds.size.width, _scrollContainer.mr_height);
    
    _pageViews = @[].mutableCopy;
    for (NSInteger i = 0; i < kPages; i++) {
        UIImageView *pageView = [UIImageView new];
        pageView.mr_size = _scrollContainer.mr_size;
        pageView.mr_x = i * [UIScreen mainScreen].bounds.size.width;
        pageView.userInteractionEnabled = YES;
        [_scrollContainer addSubview:pageView];
        [_pageViews addObject:pageView];
    }
}

- (void)setModels:(NSArray<MRIconLabelModel *> *)models {
    
    _items = @[].mutableCopy;
    [_pageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        for (NSInteger i = 0; i < kRows * kRow_count; i++) {
            NSInteger l = i % kRow_count;
            NSInteger v = i / kRow_count;
            
            MRLabel *item = [MRLabel new];
            [imageView addSubview:item];
            [_items addObject:item];
            item.tag = i + idx * (kRows * kRow_count);
            
            if (item.tag < models.count) {
                [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)]];
                item.model = [models objectAtIndex:item.tag];
                item.iconView.userInteractionEnabled = NO;
                item.textLabel.font = [UIFont systemFontOfSize:14];
                item.textLabel.textColor = kTextColor;
                [item updateLayoutBySize:_itemSize finished:^(MRLabel *item) {
                    item.mr_x = _space + (_itemSize.width  + _space) * l;
                    item.mr_y = (_itemSize.height + _gap) * v + _gap + 100;
                }];
            }
        }
    }];
    
    [self startAnimationsCompletion:NULL];
}

- (void)fullViewClicked:(UITapGestureRecognizer *)recognizer {
    __weak typeof(self) _self = self;
    [self endAnimationsCompletion:^(MRFullView *fullView) {
        if (nil != self.didClickFullView) {
            _self.didClickFullView((MRFullView *)recognizer.view);
        }
    }];
}

- (void)itemClicked:(UITapGestureRecognizer *)recognizer  {
    if (kRows * kRow_count - 1 == recognizer.view.tag) {
        [_scrollContainer setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:YES];
    } else {
        if (nil != self.didClickItems) {
            self.didClickItems(self, recognizer.view.tag);
        }
    }
}

- (void)closeClicked:(UIButton *)sender {
    [_scrollContainer setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width + 0.5;
    _closeButton.userInteractionEnabled = index > 0;
    [_closeIcon setImage:[UIImage imageNamed:(index ? @"sina_返回" : @"sina_关闭")] forState:UIControlStateNormal];
}

- (void)startAnimationsCompletion:(void (^ __nullable)(BOOL finished))completion {
    
    [UIView animateWithDuration:0.5 animations:^{
        _closeIcon.transform = CGAffineTransformMakeRotation(M_PI_4);
    } completion:NULL];
    
    [_items enumerateObjectsUsingBlock:^(MRLabel *item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.alpha = 0;
        item.transform = CGAffineTransformMakeTranslation(0, kRows * _itemSize.height);
        [UIView animateWithDuration:0.85 delay:idx * 0.035 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            item.alpha = 1;
            item.transform = CGAffineTransformIdentity;
        } completion:completion];
    }];
}

- (void)endAnimationsCompletion:(void (^)(MRFullView *))completion {
    if (!_closeButton.userInteractionEnabled) {
        [UIView animateWithDuration:0.35 animations:^{
            _closeIcon.transform = CGAffineTransformIdentity;
        } completion:NULL];
    }
    
    [_items enumerateObjectsUsingBlock:^(MRLabel * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [UIView animateWithDuration:0.35 delay:0.025 * (_items.count - idx) options:UIViewAnimationOptionCurveLinear animations:^{
                             
            item.alpha = 0;
            item.transform = CGAffineTransformMakeTranslation(0, kRows * _itemSize.height);
        
        } completion:^(BOOL finished) {
            
            if (finished) {
                if (idx == _items.count - 1) {
                    completion(self);
                }
            }
        }];
    }];
}




@end
