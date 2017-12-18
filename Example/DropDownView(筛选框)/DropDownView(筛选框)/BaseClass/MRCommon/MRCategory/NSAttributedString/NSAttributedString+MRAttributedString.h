//
//  NSAttributedString+MRAttributedString.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (MRAttributedString)
/// 使用图像和文本生成上下排列的属性文本 Use images and text generation and the properties of the text
///
/// @param image      图像
/// @param imageWH    图像宽高
/// @param title      标题文字
/// @param fontSize   标题字体大小
/// @param titleColor 标题颜色
/// @param spacing    图像和标题间距
///
/// @return 属性文本
+ (instancetype)imageTextWithImage:(UIImage *)image
                           imageWH:(CGFloat)imageWH
                             title:(NSString *)title
                          fontSize:(CGFloat)fontSize
                        titleColor:(UIColor *)titleColor
                           spacing:(CGFloat)spacing;


@end
