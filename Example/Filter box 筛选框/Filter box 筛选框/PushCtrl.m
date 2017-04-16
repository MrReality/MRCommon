//
//  PushCtrl.m
//  Filter box 筛选框
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "PushCtrl.h"
#import "MRCommon.h"

@interface PushCtrl () <MRDropDelegate>

// 筛选框 Filter box
@property (nonatomic, strong) MRDropDownView *dropView;

@end

@implementation PushCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationLabel.text = @"test";
    
    [self.view addSubview:self.dropView];
}

// MARK: MRDropDelegate
// 当点击筛选框时, 调用的方法
// When click the filter box, the method called
- (void)viewDidTap{
    
    NSLog(@"The filter box was clicked");
    // 关闭筛选框 Close the screen box
    [_dropView closeBgView];
    _dropView = nil;
}
// 点击选项调用的方法
// Click on the option method call
- (void)seletedOptionWithSelfTag:(NSInteger)tag andIndex:(NSInteger)index{
    
    NSArray *array = @[@"with time", @"abcdefg", @"hijklmn", @"opqrsturwxyz"];
    NSLog(@"dropView.tag -> %ld, seleted -> %@", tag, array[index]);
    // 关闭筛选框 Close the screen box
    [self.dropView closeBgView];
    self.dropView = nil;
}

// MARK: 懒加载 Lazy loading
- (MRDropDownView *)dropView{
    
    if(!_dropView){
        
        // 创建筛选器 Create a filter box
        _dropView = [[MRDropDownView alloc] initWithFrame:CGRectMake(10, 74, 150, 40) andOptions:@[@"with time", @"abcdefg", @"hijklmn", @"opqrsturwxyz"]];
        // 设置代理 set delegate
        _dropView.delegate = self;
        _dropView.tag = 100;
        
        // 设置标题大小 Set the title size
        // 默认 15 The default is 15
        _dropView.titleFont = 17;
        // 设置选项字体大小 Set the options for font size
        // 默认 16 The default is 16
        _dropView.optionFont = 20;
        // 设置未选择颜色 Set did not choose a color
        // 默认 [UIColor whiteColor]   The default is  [UIColor whiteColor]
//        _dropView.normalColor = [UIColor blackColor];
        // 设置选中颜色 Set the selected color
        // 默认 [UIColor orangeColor]  The default is  [UIColor orangeColor]
//        _dropView.seletedColor = [UIColor colorWithRed:0.75 green:0.65 blue:0.71 alpha:1.00];
    }
    return _dropView;
}


@end
