//
//  PresentCtrl.m
//  Radio buttons 单选框
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "PresentCtrl.h"
#import "MRCommon.h"
#import "YYKit.h"

@interface PresentCtrl ()
// Radio buttons
@property (nonatomic, strong) MRSingleSwitch *swiView;


@end

@implementation PresentCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navView.backgroundColor = [UIColor orangeColor];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.swiView];
}

// MARK: 懒加载 Lazy loading
- (MRSingleSwitch *)swiView{
    
    if(!_swiView){
        
        // 自动计算单选框宽度, 所以宽度不用在意
        // Automatic calculation sheet width of box, so the width of the don't care
        _swiView = [[MRSingleSwitch alloc] initWithFrame:CGRectMake(0, 100, 0, 40) andNameArray:@[@"boy", @"girl", @"care", @"back"]];
        _swiView.backgroundColor = [UIColor colorWithRed:0.26 green:0.86 blue:1.00 alpha:1.00];
        
        // 设置默认选项  如果不设置, 没有选项选中
        // Set the default option If not set, there is no option selected
//        _swiView.defaultSelete = 0;
        // 设置标题字号 Set the title font size
        _swiView.titleFont = 20;
        // 设置标题颜色 Set the title color
        _swiView.titleColor = [UIColor whiteColor];
        _swiView.tag = 1000;
        
        // 点击选项调用的 block
        // Click on the option call block
        @weakify(self);
        [_swiView didseleted:^(NSInteger index, NSInteger MRSingleSwitchTag) {
            @strongify(self);
            NSLog(@"the swiView.tag = %ld", MRSingleSwitchTag);
            NSArray *array = @[@"boy", @"girl", @"don't care", @"backgroundColor"];
            NSString *message = [NSString stringWithFormat:@"you click %@", array[index]];
            
            // 弹出一个只有一个选项的 UIAlertController
            // pop-up a UIAlertController, only one option
            [MRCommonOther alertSingleWithTitle:@"" message:message buttonName:@"OK" viewController:self OKBlock:^{
            }];
        }];
    }
    return _swiView;
}


@end
