//
//  ViewController.m
//  PromptBox
//
//  Created by Mac on 2017/7/17.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"
#import "MRHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)buttonAction:(id)sender {
    
    [MRHUD showWithState:@"忠实的法律" andCenterY:600];
    [MRHUD dismissWithDelay:1];
    
//    [SVProgressHUD showWithStatus:@"阿萨德;发斯蒂芬"];
//    [SVProgressHUD dismissWithDelay:1];
}






@end
