//
//  MRAlertView.m
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "MRAlertView.h"
#import  <objc/runtime.h>
#import "UIView+MRView.h"

/// 关联对象的 key
static void *MRAlertViewKey = &MRAlertViewKey;

#define kBackColor  [UIColor whiteColor]                /// 背景色
#define kTitleColor [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00] /// 标题字体颜色
#define kMessageColor [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00] /// 消息字体颜色

#define kCornerRadius           10                      /// 圆角
#define kDefaultWidth           200                     /// 默认宽度
#define kSpace                  15                      /// 间距
#define kTitleFont              22                      /// 标题字体大小
#define kMessageFont            16                      /// 消息字体大小
#define kButtonHeight           49                      /// button 高度

@interface MRAlertView ()
{
    CGSize  _contentSize;       // 弹框尺寸

}
/// 按钮集合
@property (nonatomic, strong) NSMutableSet *buttonSet;
/// 线集合
@property (nonatomic, strong) NSMutableSet *lineSet;
@end

@implementation MRAlertView

- (void)dealloc{

    NSLog(@"%@ --> delloc", self);
}

/**
 创建弹框
 @param title       标题(可为空)
 @param message     信息(可为空)
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message{

    return [self initWithTitle:title message:message andWidth:0];
}


/**
 创建弹框
 @param title       标题(可为空)
 @param message     信息(可为空)
 @param width width 指定宽度
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message andWidth:(CGFloat)width{
    
    if(self = [super init]){
    
        self.backgroundColor = kBackColor;
        self.layer.cornerRadius = kCornerRadius;
        // 开启离屏渲染
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.shouldRasterize = YES;
        
        /// 设置弹框宽度
        if(width > 0){
            _contentSize.width = width;
        }else{
            _contentSize.width = kDefaultWidth;
        }
    
        if([self isHaveString:title]){  // 如果有值才创建标题 label
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = [UIFont systemFontOfSize:kTitleFont];
            _titleLabel.numberOfLines = 0;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.textColor = kTitleColor;
            _titleLabel.text = title;
            [self addSubview:_titleLabel];
            
            _titleLabel.size = [_titleLabel sizeThatFits:CGSizeMake(_contentSize.width - 2 * kSpace, MAXFLOAT)];
            _titleLabel.top = kSpace;
            _titleLabel.centerX = _contentSize.width / 2;
            _contentSize.height = _titleLabel.height + _titleLabel.top;
        }
        
        if([self isHaveString:message]){ // 如果有值才创建标题 label
            _messageLabel = [[UILabel alloc] init];
            _messageLabel.font = [UIFont systemFontOfSize:kMessageFont];
            _messageLabel.numberOfLines = 0;
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.textColor = kMessageColor;
            [self addSubview:_messageLabel];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, message.length)];
            _messageLabel.attributedText = string;
            
            _messageLabel.size = [_messageLabel sizeThatFits:CGSizeMake(_contentSize.width - 2 * kSpace, MAXFLOAT)];
            _messageLabel.top = _contentSize.height + kSpace;
            _messageLabel.centerX = _contentSize.width / 2;
            _contentSize.height = _messageLabel.top + _messageLabel.height;
        }
        
        /// 设置 size
        self.size = CGSizeMake(_contentSize.width, _contentSize.height + kSpace);
        if (![self isHaveString:title] && ![self isHaveString:message]) {
            self.size = CGSizeZero;
        }
    }
    return self;
}

/// 添加单个按钮
- (void)addSignalButton:(UIButton *)button{

    NSAssert(button != nil, @"按钮不能为空");

    [self removeWithSet:self.buttonSet];
    [self removeWithSet:self.lineSet];
    /// 获取关联对象
    id result = objc_getAssociatedObject(self, MRAlertViewKey);
    if(result != nil && [result isKindOfClass:[UIButton class]]){       // 有这个 button 了
        
        UIButton *lastButton = (UIButton *)result;  // 上次的 button
        if (![button isEqual:lastButton]) {         // 当前的 button
            
            CGFloat width = _contentSize.width;
            button.size = CGSizeMake(width, kButtonHeight);
            button.top = lastButton.top + lastButton.height;
            button.centerX = _contentSize.width / 2;
            if (!_isLineHidden) {
                CALayer *line = [self lineWithTop:button.top horizontal:YES];
                [self.layer addSublayer:line];
                [self.lineSet addObject:line];
            }
        }
    }else{                                                              // 第一次创建 button
        
        CGFloat width = _contentSize.width;
        button.size = CGSizeMake(width, kButtonHeight);
        button.top = _contentSize.height;
        button.centerX = _contentSize.width / 2;
        if (!CGSizeEqualToSize(self.size, CGSizeZero)) {
            button.top += kSpace;
        }
        if (!_isLineHidden) {
            CALayer *line = [self lineWithTop:button.top horizontal:YES];
            [self.layer addSublayer:line];
            [self.lineSet addObject:line];
        }
    }
    
    [self insertSubview:button atIndex:0];
    [self.buttonSet addObject:button];
    self.size = CGSizeMake(_contentSize.width, button.top + button.height);
    
    // 关联对象
    objc_setAssociatedObject(self, MRAlertViewKey, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 添加两个按钮
- (void)addCancelButton:(UIButton *)cancelButton andOKButton:(UIButton *)okButton{

    NSAssert(cancelButton != nil, @"取消按钮不能为空");
    NSAssert(okButton != nil, @"确认按钮不能为空");
    
    [self removeWithSet:self.buttonSet];
    [self removeWithSet:self.lineSet];

    objc_setAssociatedObject(self, MRAlertViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    cancelButton.size = CGSizeMake(_contentSize.width / 2, kButtonHeight);
    cancelButton.top = _contentSize.height;
    if (!CGSizeEqualToSize(self.size, CGSizeZero)) {
        cancelButton.top += kSpace;
    }
    
    okButton.size = CGSizeMake(_contentSize.width / 2, kButtonHeight);
    okButton.left = cancelButton.left + cancelButton.width;
    okButton.top = cancelButton.top;
    
    [self addSubview:cancelButton];
    [self addSubview:okButton];
    [self.buttonSet addObject:cancelButton];
    [self.buttonSet addObject:okButton];
    
    if(_isLineHidden){              // 隐藏线
        CALayer *line1 = [self lineWithTop:okButton.top horizontal:YES];
        CALayer *line2 = [self lineWithTop:okButton.top horizontal:NO];
        CGRect frame = line2.frame;
        frame.origin.x = _contentSize.width / 2 - frame.size.width * 0.5;
        line2.frame = frame;

        [self.layer addSublayer:line1];
        [self.layer addSublayer:line2];
        [self.lineSet addObject:line2];
        [self.lineSet addObject:line1];
    }

    self.size = CGSizeMake(_contentSize.width, okButton.top + kButtonHeight);
}

/// 清空集合并移除视图
- (void)removeWithSet:(NSMutableSet *)set{

    NSEnumerator *enumerator = [set objectEnumerator];
    NSString *value;
    while (value = [enumerator nextObject]) {
        if ([value isKindOfClass:[CALayer class]]) {        // 清空 layer
            [((CALayer *)value) removeFromSuperlayer];
        }
        if ([value isKindOfClass:[UIButton class]]) {       // 清空按钮
            [((UIButton *)value) removeFromSuperview];
        }
    }
    [set removeAllObjects];
}

- (CALayer *)lineWithTop:(CGFloat)top horizontal:(BOOL)isHorizontalLine {
    
    UIColor *color = _lineColor ? _lineColor : [UIColor grayColor];
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = color.CGColor;
    CGRect rect = (CGRect){.origin = CGPointMake(0, top), .size = CGSizeZero};;
    if (isHorizontalLine) { // 水平线
        rect.size = CGSizeMake(_contentSize.width, 1 / [UIScreen mainScreen].scale);
    } else {
        rect.size = CGSizeMake(1 / [UIScreen mainScreen].scale, kButtonHeight);
    }
    layer.frame = rect;
    return layer;
}

/// 判断是否有字符
- (BOOL)isHaveString:(NSString *)string{

    if (!string) return NO;
    if ([string isKindOfClass:[NSNull class]]) return NO;
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) return NO;
    return YES;

}

// MARK: setter
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    for (id value in self.lineSet) {
        if ([value isKindOfClass:[CALayer class]]) {
            ((CALayer *)value).backgroundColor = lineColor.CGColor;
        }
    }
}

- (void)setIsLineHidden:(BOOL)isLineHidden{
    
    _isLineHidden = isLineHidden;
    if(_isLineHidden){
        for (id value in self.lineSet) {
            if ([value isKindOfClass:[CALayer class]]) {
                [((CALayer *)value) removeFromSuperlayer];
            }
        }
    }
}

// MARK: 懒加载
- (NSMutableSet *)lineSet{

    if(!_lineSet){
        _lineSet = [NSMutableSet set];
    }
    return _lineSet;
}

- (NSMutableSet *)buttonSet{

    if(!_buttonSet){
        _buttonSet = [NSMutableSet set];
    }
    return _buttonSet;
}

@end
