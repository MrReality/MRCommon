//
//  ViewController.m
//  InputBox
//
//  Created by shiyuanqi on 2017/4/26.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) MRInputBoxView *input1;
@property (nonatomic, strong) MRInputBoxView *input2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.input1 = [[MRInputBoxView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 0)];
    // 改背景色
//    self.input1.backColor = [UIColor colorWithRed:0.96 green:0.56 blue:0.40 alpha:1.00];
    [self.view addSubview:self.input1];
    self.input1.textField.placeholder = @"姓名";
    
    
    self.input2 = [[MRInputBoxView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, 0)];
    // 展示字体大小
    self.input2.titleFont = 18;
    // 展示字的颜色
    self.input2.textField.placeholder = @"年龄";
    self.input2.showImage = [UIImage imageNamed:@"杨幂.jpg"];
    //    self.input2.backColor = [UIColor colorWithRed:0.51 green:0.84 blue:0.96 alpha:1.00];
    [self.view addSubview:self.input2];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}




@end
