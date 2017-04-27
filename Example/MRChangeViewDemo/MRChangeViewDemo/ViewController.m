//
//  ViewController.m
//  MRChangeViewDemo
//
//  Created by shiyuanqi on 2017/4/27.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation ViewController

- (void)dealloc{

    NSLog(@"delloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MRChangeView *changeView = [[MRChangeView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 50)];
    
    changeView.options = @[@"杰伦林", @"俊杰王", @"力宏李", @"小龙吴", @"孟达周", @"星驰张", @"国荣梁", @"朝伟周"];
    changeView.backgroundColor = [UIColor colorWithRed:0.51 green:0.84 blue:0.96 alpha:1.00];
    [self.view addSubview:changeView];
    
    __weak typeof(self)weakSelf = self;
    [changeView seletedIndex:^(NSInteger selfTag, NSInteger seletedIndex) {
//        __strong typeof(self)
        NSArray *array =@[@"杰伦林", @"俊杰王", @"力宏李", @"小龙吴", @"孟达周", @"星驰张", @"国荣梁", @"朝伟周"];
        weakSelf.label.text = array[seletedIndex];
//        NSLog(@"tag -> %ld, index -> %ld", selfTag, seletedIndex);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 50, 50, 50);
    [self.view addSubview:button];
    button.backgroundColor = [UIColor orangeColor];
    
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
