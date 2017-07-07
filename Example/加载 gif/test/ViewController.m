//
//  ViewController.m
//  test
//
//  Created by Mac on 2017/7/7.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "MRGifView.h"
#import "MRCommon.h"

@interface ViewController ()

/// gif
@property (nonatomic, strong) MRGifView *gifView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *gifUrl = [[NSBundle mainBundle] URLForResource:@"加载中" withExtension:@"gif"];
    
    /// 配置 gif
    self.gifView = [[MRGifView alloc] initWithFrame:self.nonImgView.bounds fileURL:gifUrl];
    
    self.gifView.backgroundColor = [UIColor clearColor];
    self.gifView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.nonImgView addSubview:self.gifView];
    
    /// 播放 gif
    [self.gifView startGif];

//    [self.nonImgView addSubview:self.gifView];
    
}





@end
