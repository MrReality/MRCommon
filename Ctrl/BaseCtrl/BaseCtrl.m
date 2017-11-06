//
//  BaseCtrl.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "BaseCtrl.h"
#import "UIView+MRView.h"

/// 屏幕宽
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
/// 屏幕高
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/// 导航栏字号
#define kNavLabelFont 18

/// 提示图片宽
#define kNonImgWidth  (kScreenWidth > kScreenHeight) ? kScreenHeight / 2 : kScreenWidth / 2
/// 提示图片和提示文字的间距
#define kSpace 15
/// 提示文本颜色
#define kNonLabelTextColor [UIColor colorWithRed:0.58 green:0.66 blue:0.79 alpha:1.00]
/// 提示文本字号
#define kNonLabelFont 14


@interface BaseCtrl () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation BaseCtrl

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ --> delloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 创建 UI
    [self _initBaseUI];
}

- (void)_initBaseUI{

    /// 防止在 tableView ScrollView 等下自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = self.navigationLabel;
    self.allowRotation = NO;
    
    // 监听键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShowWithNotify:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidenWithNotify:) name:UIKeyboardWillHideNotification object:nil];
    
    // 监听横竖屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (self.allowRotation) 
        return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}

/// MARK: 监听键盘
- (void)keyboardWillShowWithNotify:(NSNotification *)showNot{

    CGRect keyboardFrame = [showNot.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat upRectFrame = keyboardFrame.size.height;
    
    // 弹出时间
    CGFloat duration = [showNot.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self keyboardWillShowWithKeyBoardHeight:upRectFrame andDuration:duration];
}

/// 弹出键盘时调用的函数, height 为键盘高度
- (void)keyboardWillShowWithKeyBoardHeight:(CGFloat)height andDuration:(CGFloat)duration{

    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}

- (void)keyboardWillHidenWithNotify:(NSNotification *)hideNot{
    /// 键盘弹出时间
    CGFloat duration = [hideNot.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self keyboardWillHiddenWithDuration:duration];
}

/// 键盘将要消失的函数
- (void)keyboardWillHiddenWithDuration:(CGFloat)duration{

    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

//- (BOOL)prefersStatusBarHidden{
//    return NO;
//}

/// 横竖屏切换调用的函数
- (void)changeRotate{
    
    [self.view endEditing:YES];
    
    /// 判断是否有导航栏
    CGFloat height = 0;
    if(self.view.top > 0){
        height = self.view.top;
    }
    if(kScreenHeight > kScreenWidth){       // 竖屏
        _nonImgView.bottom = kScreenHeight / 2 - height;
        _nonLabel.top = _nonImgView.bottom + kSpace;
        if(!_nonImgView){
            _nonLabel.bottom = kScreenHeight / 2 - height;
        }
    }
    
    if(kScreenWidth > kScreenHeight){       // 横屏
        _nonImgView.centerY = kScreenHeight / 2 - height;
        _nonLabel.top = _nonImgView.bottom + kSpace;
        if(!_nonImgView){
            _nonLabel.centerY = kScreenHeight / 2 - height;
        }
    }
    
    _nonImgView.centerX = self.view.centerX;
    _nonLabel.centerX = self.view.centerX;
}

/// MARK:设置电池颜色
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    
//    if(self.isWhiteStateBar){       // 白色电池条
//        return UIStatusBarStyleLightContent;
//    }
//    return UIStatusBarStyleDefault;
//}

// MARK: textView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

/// MARK: textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/// MARK: 触摸屏幕, 结束编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

// MARK: 懒加载
- (UILabel *)nonLabel{
    
    if(!_nonLabel){
        
        _nonLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, kScreenHeight / 2 - 15, 100, 30)];
        _nonLabel.text = @"暂无数据";
        [self.view addSubview:_nonLabel];
        _nonLabel.font = [UIFont systemFontOfSize:kNonLabelFont];
        [self.view bringSubviewToFront:_nonLabel];
        _nonLabel.textAlignment = NSTextAlignmentCenter;
        _nonLabel.textColor = kNonLabelTextColor;
        
        [self changeRotate];
    }
    return _nonLabel;
}

- (UIImageView *)nonImgView{

    if(!_nonImgView){
        
        _nonImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kNonImgWidth, kNonImgWidth)];
        [self.view addSubview:_nonImgView];
        [self.view bringSubviewToFront:_nonImgView];
        
        [self changeRotate];
    }
    return _nonImgView;
}

- (UILabel *)navigationLabel{
    
    if(!_navigationLabel){
        
        _navigationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 75, 27, 150, 30)];
        _navigationLabel.font = [UIFont systemFontOfSize:kNavLabelFont];
        _navigationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navigationLabel;
}



@end
