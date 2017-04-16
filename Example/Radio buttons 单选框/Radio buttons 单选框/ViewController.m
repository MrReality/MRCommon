//
//  ViewController.m
//  Radio buttons 单选框
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.button setCornerRadius:3];
    // 按钮点击事件 Button click event
    [self.button buttonActionWith:^(UIButton *button) {
        
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Present" bundle:nil] instantiateInitialViewController];
        [self presentViewController:vc animated:YES completion:NULL];
    }];
}




@end
