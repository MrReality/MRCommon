//
//  NSAttributedString+MRAttributedString.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "NSAttributedString+MRAttributedString.h"

@implementation NSAttributedString (MRAttributedString)
+ (instancetype)imageTextWithImage:(UIImage *)image imageWH:(CGFloat)imageWH title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor spacing:(CGFloat)spacing {
    
    // 文本字典
    NSDictionary *titleDict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                NSForegroundColorAttributeName: titleColor};
    NSDictionary *spacingDict = @{NSFontAttributeName: [UIFont systemFontOfSize:spacing]};
    
    // 图片文本
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, imageWH, imageWH);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 换行文本
    NSAttributedString *lineText = [[NSAttributedString alloc] initWithString:@"\n\n" attributes:spacingDict];
    
    // 按钮文字
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:title attributes:titleDict];
    
    // 合并文字
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
    [attM appendAttributedString:lineText];
    [attM appendAttributedString:text];
    
    return attM.copy;
}

@end
