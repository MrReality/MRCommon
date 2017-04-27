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
#define kBaseFont 14
/// 提示标题字体颜色
#define kBaseColor [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1.00]
#define kSpace 5
#define kBackGroundColor [UIColor whiteColor]
#define kPointColor [UIColor colorWithRed:0.51 green:0.84 blue:0.96 alpha:1.00]
/// 提示图片宽
#define kShowImgViewWidth 32

@interface MRInputBoxView () <UITextFieldDelegate>
/// 提示信息
@property (nonatomic, strong) UILabel *titleLabel;
/// 提示 view
@property (nonatomic, strong) UIView *promptView;
/// 提示图片
@property (nonatomic, strong) UIImageView *showImgView;
/// 当有提示图片时, 添加下划线
@property (nonatomic, strong) UIView *lineView;
@end

@implementation MRInputBoxView

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 60)]){
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textStateChange) name:UITextFieldTextDidBeginEditingNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib{

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

    NSInteger font;
    UIColor *titleColor;
    UIColor *backGroundColor;
    
    if(_titleFont){
        font = self.titleFont;
    }else{
        font = kBaseFont;
    }
    
    if(_titleColor){
        titleColor = self.titleColor;
    }else{
        titleColor = kBaseColor;
    }
    
    if(_backColor){
        backGroundColor = self.backColor;
    }else{
        backGroundColor = kBackGroundColor;
    }
    
    self.backgroundColor = backGroundColor;
    
    self.titleLabel.text = self.textField.placeholder;
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    self.titleLabel.textColor = titleColor;
    [self.titleLabel sizeToFit];
    self.titleLabel.mr_y = 0;
    self.titleLabel.mr_x = 2 * kSpace;
    
    if(_showImage){

        self.showImgView.mr_x = 2 * kSpace;
        self.showImgView.mr_y = self.titleLabel.mr_y + self.titleLabel.mr_height + kSpace / 2;
        self.showImgView.image = self.showImage;
        
        self.textField.frame = CGRectMake(self.showImgView.mr_width + 4 * kSpace, self.showImgView.mr_y, self.mr_width - 6 * kSpace - self.showImgView.mr_width, 35);
        self.textField.borderStyle = UITextBorderStyleNone;
        self.lineView.frame = CGRectMake(self.textField.mr_x, self.textField.mr_y + self.textField.mr_height - 3, self.textField.mr_width, 1);
    }
    if(!_showImage){
        self.textField.frame = CGRectMake(2 * kSpace, self.titleLabel.mr_y + self.titleLabel.mr_height + kSpace / 2, self.mr_width - 4 * kSpace, 35);
    }
 
    self.textField.backgroundColor = backGroundColor;
//    self.promptView.mr_x = self.textField.mr_x + 8;
//    self.promptView.mr_centerY = self.textField.mr_centerY;
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
    
    if(!_showImage){            // 没有框
        self.promptView.mr_size = CGSizeMake(0, 0);
        self.promptView.mr_x = self.textField.mr_x + rect.origin.x;
        self.promptView.mr_centerY = self.textField.mr_centerY;
    }
    
    if(_showImage){             // 有框
        self.promptView.mr_size = CGSizeMake(0, 0);
        self.promptView.mr_x = self.textField.mr_x + rect.origin.x;
        self.promptView.mr_centerY = self.textField.mr_centerY;
    }

    [UIView animateWithDuration:.3 animations:^{
        if(!_showImage){
        
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
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 animations:^{
            
            if(!_showImage){
                self.promptView.mr_x = self.textField.mr_x + 7 + rect.origin.x;
                self.promptView.mr_size = CGSizeMake(2, 27);
                self.promptView.mr_centerY = self.textField.mr_centerY;
            }
            
            if(_showImage){
                self.promptView.mr_x = self.textField.mr_x + rect.origin.x;
                self.promptView.mr_size = CGSizeMake(2, 25);
                self.promptView.mr_centerY = self.textField.mr_centerY;
            }
         
        } completion:^(BOOL finished) {
            self.promptView.hidden = YES;
            self.textField.tintColor = kPointColor;
        }];
    }];
}

- (void)textDidChange{

    if(self.textField.text.length){
        [UIView animateWithDuration:.3 animations:^{
            self.titleLabel.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.titleLabel.hidden = YES;
        }];
    }
}

// MARK: textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    [self textDidChange];
    textField.tintColor = [UIColor whiteColor];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    [self textDidChange];
    [self textStateChange];
}




// MARK: 懒加载
- (UITextField *)textField{

    if(!_textField){
        
        UITextField *textFd = [[UITextField alloc]init];
        textFd.placeholder = @"";
        textFd.borderStyle = UITextBorderStyleRoundedRect;
        textFd.clearButtonMode = UITextFieldViewModeWhileEditing; // 编辑时存在
        // 设置弹出键盘的样式
        textFd.keyboardType = UIKeyboardTypeDefault;
        // 指定返回事件的类型
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
        // 设置阴影
        _promptView.layer.shadowOpacity = .5;
        // 设置阴影偏移的方向和宽度
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
