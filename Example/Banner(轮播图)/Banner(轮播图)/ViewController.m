//
//  ViewController.m
//  Banner(轮播图)
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"
#import "MRBannerView.h"

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
    NSArray *array = @[@"index_banner1", @"index_banner2", @"index_banner3", @"index_banner4"];
    
    MRBannerView *banner = [[MRBannerView alloc] initWithImageNameArray:array.mutableCopy andFrame:CGRectMake(0, 20, kScreenWidth, 200)];
    banner.backgroundColor = [UIColor colorWithRed:0.69 green:0.96 blue:0.40 alpha:1.00];
    /// 动画时长
    banner.interval = 2;
    [self.view addSubview:banner];
    
    [banner clickBannerWithBlock:^(NSInteger selfId, NSInteger index) {
        NSLog(@"clickAtIndex: %ld", index);
    }];
}




@end
