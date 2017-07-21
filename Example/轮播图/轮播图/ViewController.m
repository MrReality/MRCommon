//
//  ViewController.m
//  轮播图
//
//  Created by Mac on 2017/7/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "PushCtrl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (IBAction)pushAction:(id)sender {
    
    UIViewController *pushCtrl = [[PushCtrl alloc] init];
    [self.navigationController pushViewController:pushCtrl animated:YES];
}



@end
