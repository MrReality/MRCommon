//
//  ViewController.m
//  Filter box 筛选框
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"
#import "YYKit.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *clickView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // UIView 的轻击事件   UIView tap event
    @weakify(self);
    [self.clickView tapActionWithBlock:^{
        @strongify(self);
        // 弹出一个只有两个选项的 UIAlertController
        // pop-up a UIAlertController, only two option
        [MRCommonOther alertWithTitle:@"12" message:@"are you sure to jump" type:CommonOtherCancelAndOK viewController:self OKBlock:^{
            
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Push" bundle:nil] instantiateInitialViewController];
            [self.navigationController pushViewController:vc animated:YES];
            
        } CancelBlock:^{
            NSLog(@"click cancel");
        }];
    }];
}





@end
