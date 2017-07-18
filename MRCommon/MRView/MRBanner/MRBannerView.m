//
//  MRBannerView.m
//  轮播图
//
//  Created by Mac on 2017/7/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRBannerView.h"
#import "UIView+MRView.h"
#import "UIImageView+MRImageView.h"

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/// 未选中点的默认颜色
#define kNormalPagingControlColor [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00]
/// 选中点的默认颜色
#define kSeletedPagingControlColor [UIColor colorWithRed:0.69 green:0.96 blue:0.40 alpha:1.00]

@interface MRBannerView () <UIScrollViewDelegate>

/// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

/// 定时器
@property (nonatomic, strong) NSTimer *timer;

/// 点击的 block
@property (nonatomic, copy) ClickBannerBlock clickBlock;
/// 滚动的 block
@property (nonatomic, copy) BannerChangeBlock changeBlock;


@end

@implementation MRBannerView

- (void)dealloc{

    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)initWithImageNameArray:(NSMutableArray *)array andFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        
        /// 创建 UI
        [self _initUI];
        self.imgNameArray = array;
    }
    return self;
}

- (void)awakeFromNib{

    [super awakeFromNib];
    /// 创建 UI
    [self _initUI];
}

/// MARK: 创建 UI
- (void)_initUI{

    self.scrollView.size = self.size;
    
    self.layer.masksToBounds = YES;
}

/// MARK: setter
- (void)setImgNameArray:(NSMutableArray *)imgNameArray{

    if(!imgNameArray){          /// 安全判断
        return;
    }
    _imgNameArray = imgNameArray;
    /// 再加两个图片
    [_imgNameArray insertObject:imgNameArray.lastObject atIndex:0];
    [_imgNameArray addObject:imgNameArray[1]];
    
    CGFloat width = self.width;
    for (NSInteger i = 0; i < _imgNameArray.count; i++) {

        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, self.height)];
        imgView.image = [UIImage imageNamed:_imgNameArray[i]];
        [self.scrollView addSubview:imgView];
        
        NSInteger tag = 0;
        if(i != 0 && i != _imgNameArray.count - 1){
            tag = i;
            imgView.tag = tag;
            /// 点击图片的回调
            @weakify(self);
            [imgView tapWithBlock:^{
                @strongify(self);
                if(self.clickBlock){
                    self.clickBlock(self.tag, imgView.tag);
                }
            }];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(width * _imgNameArray.count, self.height);
    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    if(!self.imgNameArray){     /// 安全判断
        return;
    }
    /// 滚动点的 top, 默认值 50
    CGFloat pageTop = self.pageTop == 0 ? self.height - 30 : self.pageTop;
    
    self.pageControl.width = self.width;
    self.pageControl.height = 30;
    self.pageControl.top = pageTop;
    
    self.pageControl.numberOfPages = self.imgNameArray.count - 2;
    
    /// 如果未设置时间, 设置为 2 秒
    self.interval = self.interval == 0 ? 2 : self.interval;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    });
}

/// 点击轮播图片调用的 block
- (void)clickBannerWithBlock:(ClickBannerBlock)block{
    self.clickBlock = block;
}

/// 轮播图滚动调用的 block
- (void)bannerChangeWithBlock:(BannerChangeBlock)block{
    self.changeBlock = block;
}

/// MARK: scrollView delegate
/// 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.timer invalidate];
        _timer = nil;
    });
}

/// 停止拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    });
}

/// 开始滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat width = self.scrollView.width;
    NSInteger index = scrollView.contentOffset.x / width;
    self.pageControl.currentPage = index - 1;
    
    if(index >= self.imgNameArray.count - 1){           /// 已经滚到最后一个, 跳转回第一个
        [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    }
    
    if(scrollView.contentOffset.x == 0){                     /// 第一个往前滚, 滚到最后一个
        index = self.imgNameArray.count - 2;
        [scrollView setContentOffset:CGPointMake(width * index, 0) animated:NO];
    }
    
    if(self.changeBlock){
        self.changeBlock(self.tag, self.pageControl.currentPage);
    }
}

/// MARK: 懒加载
- (UIScrollView *)scrollView{

    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        /// 隐藏滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        // 设置分页
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{

    if(!_pageControl){
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = kSeletedPagingControlColor;
        _pageControl.pageIndicatorTintColor = kNormalPagingControlColor;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (NSTimer *)timer{

    if(!_timer){
        
        @weakify(self);
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.interval repeats:YES block:^(NSTimer * _Nonnull timer) {
            @strongify(self);

            CGFloat width = self.scrollView.width;
            /// 获取当前索引
            NSInteger index = self.scrollView.contentOffset.x / width;
            index += 1;
            [self.scrollView setContentOffset:CGPointMake(width * index, 0) animated:YES];
        }];
    }
    return _timer;
}


@end
