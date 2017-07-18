//
//  PushCtrl.m
//  轮播图
//
//  Created by Mac on 2017/7/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "PushCtrl.h"
#import "MRCommon.h"
#import "MRBannerView.h"
#import "SVProgressHUD.h"

@interface PushCtrl ()

@end

@implementation PushCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *array = @[@"index_banner1", @"index_banner2", @"index_banner3", @"index_banner4"];

    
    MRBannerView *banner = [[MRBannerView alloc] initWithImageNameArray:array.mutableCopy andFrame:CGRectMake(0, 20, kScreenWidth, 200)];
    banner.backgroundColor = [UIColor colorWithRed:0.69 green:0.96 blue:0.40 alpha:1.00];
    banner.interval = 2;
    [self.view addSubview:banner];
    
    @weakify(self);
    [banner clickBannerWithBlock:^(NSInteger selfId, NSInteger index) {
        @strongify(self);
        NSString *str = [NSString stringWithFormat:@"点击了 : %ld", index];
        [SVProgressHUD showWithStatus:str];
        [SVProgressHUD dismissWithDelay:1];
        NSLog(@"%ld --- %.f", index, self.view.width / 100);
    }];
    
    /// 轮播图滚动调用的方法
//    [banner bannerChangeWithBlock:^(NSInteger selfId, NSInteger index) {
//        @strongify(self);
//        NSString *str = [NSString stringWithFormat:@"移动至 : %ld", index];
//        [SVProgressHUD showWithStatus:str];
//        NSLog(@"%ld --- %.f", index, self.view.width / 100);
//    }];
}




@end
