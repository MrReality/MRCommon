//
//  PushCtrl.m
//  DropDownView(筛选框)
//
//  Created by Mac on 2017/12/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "PushCtrl.h"
#import "MRCommon.h"

@interface PushCtrl ()

// 筛选框 Filter box
@property (nonatomic, strong) MRDropDownView *dropView;

@end

@implementation PushCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithRed:0.51 green:0.82 blue:0.95 alpha:1.00];
    self.navigationLabel.text = @"test";
    
    [self.view addSubview:self.dropView];
}

// MARK: 懒加载 Lazy loading
- (MRDropDownView *)dropView{
    
    if(!_dropView){
        
        // 创建筛选器 Create a filter box
        _dropView = [[MRDropDownView alloc] initWithFrame:CGRectMake(10, 74, 150, 40) andOptions:@[@"with time", @"abcdefg", @"hijklmn", @"opqrsturwxyz"]];
        // 设置代理 set delegate
//        _dropView.delegate = self;
        _dropView.tag = 100;
        
        // 设置标题大小 默认 15, Set the title size The default is 15
        _dropView.titleFont = 17;
        // 设置选项字体大小 默认 16, Set the options for font size The default is 16
        _dropView.optionFont = 20;
        // 设置未选择颜色 默认 [UIColor blackColor], Set did not choose a color he default is  [UIColor blackColor]
        _dropView.normalColor = [UIColor blackColor];
        // 设置选中颜色 默认 [UIColor orangeColor], Set the selected color  The default is  [UIColor orangeColor]
        _dropView.seletedColor = [UIColor orangeColor];
        
        @weakify(self);
        //// MARK: 点击选项调用的方法 Click on the option method call
        [self.dropView didseletedWithBlock:^(NSInteger tag, NSInteger index) {
            @strongify(self);
            NSArray *array = @[@"with time", @"abcdefg", @"hijklmn", @"opqrsturwxyz"];
            NSLog(@"dropView.tag -> %ld, seleted -> %@", tag, array[index]);
            // 关闭筛选框 Close the screen box
            [self.dropView closeBgView];
        }];
        
        /// 当点击筛选框时, 调用的方法 When click the filter box, the method called
        [_dropView clickBackGroundBlock:^{
            @strongify(self);
            [self.dropView closeBgView];
        }];
    }
    return _dropView;
}



@end
