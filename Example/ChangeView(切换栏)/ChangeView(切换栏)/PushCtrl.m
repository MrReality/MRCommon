//
//  PushCtrl.m
//  ChangeView(切换栏)
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "PushCtrl.h"
#import "MRCommon.h"

@interface PushCtrl ()
@property (strong, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation PushCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    MRChangeView *changeView = [[MRChangeView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 50)];
    changeView.space = 20;
    changeView.options = @[@"周杰伦", @"林俊杰", @"王力宏", @"李小龙", @"周星驰", @"吴孟达", @"张国荣", @"梁朝伟"];
    changeView.backgroundColor = [UIColor colorWithRed:0.51 green:0.84 blue:0.96 alpha:1.00];
    [self.view addSubview:changeView];
    
    @weakify(self);
    [changeView seletedIndex:^(NSInteger selfTag, NSInteger seletedIndex) {
        @strongify(self);
        NSArray *array =@[@"周杰伦", @"林俊杰", @"王力宏", @"李小龙", @"周星驰", @"吴孟达", @"张国荣", @"梁朝伟"];
        self.showLabel.text = array[seletedIndex];
    }];
}


@end
