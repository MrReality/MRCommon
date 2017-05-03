//
//  BaseCtrl.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BaseCtrl.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BaseCtrl ()

@end

@implementation BaseCtrl

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 防止在TableView ScrollView等下自动偏移 */
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.titleView = self.navigationLabel;
}

// 设置电池颜色
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    
//    return UIStatusBarStyleLightContent;
//}

#pragma mark -输入相关
// 开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);// 键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//点击输入框以外的部分，收起键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

// MARK: 懒加载
- (UILabel *)nonLabel{
    
    if(!_nonLabel){
        
        _nonLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, kScreenHeight / 2 - 15, 100, 30)];
        _nonLabel.text = @"暂无数据";
        [self.view addSubview:_nonLabel];
        [self.view bringSubviewToFront:_nonLabel];
        _nonLabel.textAlignment = NSTextAlignmentCenter;
        
        _nonLabel.textColor = [UIColor colorWithRed:0.58 green:0.66 blue:0.79 alpha:1.00];
    }
    return _nonLabel;
}

- (UILabel *)navigationLabel{
    
    if(!_navigationLabel){
        
        _navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 75, 27, 150, 30)];
        _navigationLabel.font = [UIFont systemFontOfSize:20];
        _navigationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navigationLabel;
}



@end
