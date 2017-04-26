//
//  ViewController.m
//  InputBox
//
//  Created by shiyuanqi on 2017/4/26.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.90 green:0.92 blue:0.93 alpha:1.00];
    
    MRInputBoxView *inputView = [[MRInputBoxView alloc] initWithFrame:CGRectMake(0, 59, 375, 0)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    inputView.placeHolder = @"姓名";
    inputView.showImage = [UIImage imageNamed:@"123.png"];
    inputView.backColor = [UIColor colorWithRed:0.93 green:1.00 blue:0.96 alpha:1.00];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}




@end
