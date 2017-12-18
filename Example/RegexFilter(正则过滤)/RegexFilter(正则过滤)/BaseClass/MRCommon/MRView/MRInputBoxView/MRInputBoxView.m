//
//  MRInputBoxView.m
//  InputBox
//
//  Created by shiyuanqi on 2017/4/26.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "MRInputBoxView.h"
#import "UIView+MRExtension.h"

/// 提示标题字体大小
#define kBaseTitleStateFont 14
/// 提示标题字体颜色未选中颜色
#define kBaseColor [UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1.00]
#define kSpace 5
#define kBackGroundColor [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00]
/// 点的颜色, 标题选中的颜色
#define kPointColor [UIColor colorWithRed:0.51 green:0.84 blue:0.96 alpha:1.00]
/// 提示图片宽
#define kShowImgViewWidth 32

@interface MRInputBoxView () <UITextFieldDelegate>

/// 输入框
@property (nonatomic, strong, nonnull) UITextField *textField;
/// 提示信息
@property (nonatomic, strong, nullable) UILabel *titleLabel;
/// 提示 view
@property (nonatomic, strong, nullable) UIView *promptView;
/// 提示图片
@property (nonatomic, strong, nullable) UIImageView *showImgView;
/// 当有提示图片时, 添加下划线
@property (nonatomic, strong, nullable) UIView *lineView;

@end

@implementation MRInputBoxView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, (frame.size.width) >= 150 ? frame.size.width : 150, kInputViewHeight);
    }
    return self;
}

- (void)awakeFromNib{
    self.mr_height = kInputViewHeight;
    [super awakeFromNib];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.promptView.mr_size = CGSizeMake(0, 0);
    self.promptView.center = point;
    
    [UIView animateWithDuration:.5 animations:^{
        self.promptView.mr_size = CGSizeMake(10, 10);
        self.promptView.center = point;
        self.promptView.hidden = NO;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3 animations:^{
            self.promptView.mr_size = CGSizeMake(0, 0);
            self.promptView.center = point;
            self.promptView.hidden = YES;
        }];
    }];
    [self.textField resignFirstResponder];
}

- (void)layoutSubviews{

    [super layoutSubviews];

    /// 字号大小
    NSInteger font = _titleFont ? self.titleFont : kBaseTitleStateFont;
    /// 背景色
    UIColor *backGroundColor = _backColor ? self.backColor : kBackGroundColor;
    self.backgroundColor = backGroundColor;
    
    /// 上面的小显示文字
    self.titleLabel.text = _stateText.length ? _stateText : (self.textField.placeholder.length) ? self.textField.placeholder : @" ";
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    [self.titleLabel sizeToFit];
    self.titleLabel.mr_y = 0;
    self.titleLabel.mr_x = 2 * kSpace;
    
    if(_showImage){         /// 有显示图片
        self.showImgView.mr_x = 2 * kSpace;
        self.showImgView.mr_y = self.titleLabel.mr_y + self.titleLabel.mr_height + kSpace / 2;
        self.showImgView.image = self.showImage;
        
        self.textField.frame = CGRectMake(self.showImgView.mr_width + 4 * kSpace, self.showImgView.mr_y, self.mr_width - 6 * kSpace - self.showImgView.mr_width, 35);
        self.textField.borderStyle = UITextBorderStyleNone;
        self.lineView.frame = CGRectMake(self.textField.mr_x, self.textField.mr_y + self.textField.mr_height - 3, self.textField.mr_width, 1);
    }
    
    if(!_showImage){            /// 没有显示图片
        self.textField.frame = CGRectMake(2 * kSpace, self.titleLabel.mr_y + self.titleLabel.mr_height + kSpace / 2, self.mr_width - 4 * kSpace, 35);
    }
    
    if(_isNoBorder){                /// 没有边框
        self.textField.borderStyle = UITextBorderStyleNone;
        self.lineView.frame = CGRectMake(self.textField.mr_x, self.textField.mr_y + self.textField.mr_height - 3, self.textField.mr_width, 1);
    }
    
    if(_firstText.length){         /// 初始有文字, 让提示文本显示
        self.textField.text = _firstText;
        self.titleLabel.hidden = NO;
        _firstText = nil;
    }
    
    [self addSubview:self.promptView];
}

- (void)textStateChange{

    /// 获取光标位置
    UITextPosition *position = self.textField.endOfDocument;
    CGRect rect = [self.textField caretRectForPosition:position];
    
    if(rect.origin.x > self.textField.frame.size.width - 55){
        self.textField.tintColor = kPointColor;
        return;
    }
    
    if(!_showImage && !_isNoBorder){            // 没有框
        self.promptView.mr_size = CGSizeMake(0, 0);
        self.promptView.mr_x = self.textField.mr_x + rect.origin.x;
        self.promptView.mr_centerY = self.textField.mr_centerY;
    }
    
    if(_showImage){                                        // 有图片没框
        self.promptView.mr_size = CGSizeMake(0, 0);
        self.promptView.mr_x = self.textField.mr_x + rect.origin.x;
        self.promptView.mr_centerY = self.textField.mr_centerY;
    }
    
    if(_isNoBorder){                                        // 没图片没框
        self.promptView.mr_size = CGSizeMake(0, 0);
        self.promptView.mr_x = self.textField.mr_x + rect.origin.x;
        self.promptView.mr_centerY = self.textField.mr_centerY;
    }

    [UIView animateWithDuration:.3 animations:^{
        if(!_showImage && !_isNoBorder){
            self.promptView.mr_x = self.textField.mr_x + 3 + rect.origin.x;
            self.promptView.mr_size = CGSizeMake(10, 10);
            self.promptView.mr_centerY = self.textField.mr_centerY;
            self.promptView.hidden = NO;
        }
        
        if(_showImage){
            self.promptView.mr_x = self.textField.mr_x - 4 + rect.origin.x;
            self.promptView.mr_size = CGSizeMake(10, 10);
            self.promptView.mr_centerY = self.textField.mr_centerY;
            self.promptView.hidden = NO;
        }
        
        if(_isNoBorder){                                     // 没图片没框
            self.promptView.mr_x = self.textField.mr_x + rect.origin.x;
            self.promptView.mr_size = CGSizeMake(10, 10);
            self.promptView.mr_centerY = self.textField.mr_centerY;
            self.promptView.hidden = NO;
        }
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 animations:^{
            
            if(!_showImage && !_isNoBorder){
                self.promptView.mr_x = self.textField.mr_x + 7 + rect.origin.x;
                self.promptView.mr_size = CGSizeMake(2, 27);
                self.promptView.mr_centerY = self.textField.mr_centerY;
            }
            
            if(_showImage){
                self.promptView.mr_x = self.textField.mr_x + rect.origin.x;
                self.promptView.mr_size = CGSizeMake(2, 25);
                self.promptView.mr_centerY = self.textField.mr_centerY;
            }
            
            if(_isNoBorder){
                self.promptView.mr_x = self.textField.mr_x + rect.origin.x;
                self.promptView.mr_size = CGSizeMake(2, 27);
                self.promptView.mr_centerY = self.textField.mr_centerY;
                self.promptView.hidden = NO;
            }
         
        } completion:^(BOOL finished) {
            self.promptView.hidden = YES;
            self.textField.tintColor = kPointColor;
        }];
    }];
}

// MARK: textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.tintColor = [UIColor whiteColor];
    
    if(textField.text.length){
        [UIView animateWithDuration:.3 animations:^{
            self.titleLabel.hidden = NO;
        }completion:^(BOOL finished) {
            self.titleLabel.textColor = kBaseColor;
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.titleLabel.hidden = YES;
        }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self textStateChange];
    
    if(self.textField.text.length){
        [UIView animateWithDuration:.3 animations:^{
            self.titleLabel.hidden = NO;
        }completion:^(BOOL finished) {
            self.titleLabel.textColor = kPointColor;
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.titleLabel.hidden = YES;
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(str.length){
        [UIView animateWithDuration:.3 animations:^{
            self.titleLabel.hidden = NO;
        } completion:^(BOOL finished) {
            self.titleLabel.textColor = kPointColor;
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.titleLabel.hidden = YES;
        }];
    }
    
    return YES;
}

// MARK: 懒加载
- (UITextField *)textField{
    if(!_textField){
        UITextField *textFd = [[UITextField alloc]init];
        textFd.placeholder = @"";
        textFd.borderStyle = UITextBorderStyleRoundedRect;
        textFd.clearButtonMode = UITextFieldViewModeWhileEditing; // 编辑时存在
        textFd.keyboardType = UIKeyboardTypeDefault;
        textFd.returnKeyType = UIReturnKeyDone;
        [self addSubview:textFd];
        
        _textField = textFd;
        _textField.delegate = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        view.backgroundColor = [UIColor orangeColor];
        _textField.leftView = view;
        // 光标的yan'se
        _textField.tintColor = [UIColor whiteColor];
    }
    return _textField;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBaseColor;
        [self addSubview:_titleLabel];
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UIView *)promptView{
    if(!_promptView){
        _promptView = [[UIView alloc] init];
        _promptView.layer.cornerRadius = 5;
        _promptView.hidden = YES;
        _promptView.backgroundColor = kPointColor;
        _promptView.layer.shadowOpacity = .5;
        _promptView.layer.shadowOffset = CGSizeMake(0, 0);
        _promptView.layer.shadowRadius = 5;
        _promptView.layer.shadowColor = kPointColor.CGColor;
    }
    return _promptView;
}

- (UIImageView *)showImgView{
    if(!_showImgView){
        _showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kShowImgViewWidth, kShowImgViewWidth)];
        [self addSubview:_showImgView];
    }
    return _showImgView;
}

- (UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.00];
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
