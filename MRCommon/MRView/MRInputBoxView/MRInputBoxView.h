//
//  MRInputBoxView.h
//  InputBox
//
//  Created by shiyuanqi on 2017/4/26.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import <UIKit/UIKit.h>

/// MARK: 高端输入框
@interface MRInputBoxView : UIView
/// 输入框
@property (nonatomic, strong) UITextField *textField;
/// 提示字体大小
@property (nonatomic, assign) NSInteger titleFont;
/// 背景色
@property (nonatomic, strong) UIColor *backColor;
/// 展示图片
@property (nonatomic, strong) UIImage *showImage;
/// 是否是没有边框
@property (nonatomic, assign) BOOL isNoBorder;
/// 初始文字
@property (nonatomic, copy) NSString *firstText;
/// 当输入框有文字时, 提示显示的文字
@property (nonatomic, copy) NSString *stateText;

@end
