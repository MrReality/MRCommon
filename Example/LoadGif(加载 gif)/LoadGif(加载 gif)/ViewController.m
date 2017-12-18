//
//  ViewController.m
//  LoadGif(加载 gif)
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /// 创建 UI
    [self _initUI];
}

/// MARK: 创建 UI
- (void)_initUI{
    
    NSURL *gifUrl = [[NSBundle mainBundle] URLForResource:@"加载中" withExtension:@"gif"];

    MRGifView *gifView = [[MRGifView alloc] initWithFrame:CGRectZero fileURL:gifUrl];
    gifView.size = CGSizeMake(150, 150);
    gifView.centerX = self.view.width / 2;
    gifView.centerY = self.view.height / 2;
    gifView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:gifView];
    [gifView startGif];
}



@end
