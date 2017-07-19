//
//  MRListDownView.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MRListDownBlock)(NSInteger tag, NSInteger index);
typedef void(^MRCloseBgBlock)();

typedef NS_ENUM(NSInteger, ListDownImgType){

    ListDownImgTypeLeft  = 0, // 图片在标题前面  Pictures in front of the title
    ListDownImgTypeRight = 1  // 图片在标题后面  Pictures at the back of the title
};

@interface MRListDownView : UIView

/**
 创建下拉 view                  Create the drop-down view
 @param options 按钮名称数组     The button name array
 @param images  图片名称数组     Image name array
 @param point   下拉栏尖的起始点坐标, 如果设置 CGPointZero, 则为右上角起始坐标   beginPoint
 */
- (instancetype)initWithOptions:(NSArray *)options andImages:(NSArray *)images andBeginPoint:(CGPoint)point;
/**
 关闭视图   Close the view
 */
- (void)closeView;
/**
 选中调用的 block        Select the call block
 */
- (void)seletedWithBlock:(MRListDownBlock)block;
/**
 点击背景调用的 block     Click on the background call block
 */
- (void)clickWithBlock:(MRCloseBgBlock)block;

/**
 下拉视图的背景色
 */
@property (nonatomic, strong) UIColor *listBackColor;
/**
 下拉视图上面字的颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 分割线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;
/**
 标题字号
 */
@property (nonatomic, assign) NSInteger titleFont;
/**
 标题高
 */
@property (nonatomic, assign) CGFloat height;
/**
 圆角大小
 */
@property (nonatomic, assign) CGFloat cornerRadius;
/**
 图片宽
 */
@property (nonatomic, assign) CGFloat imageWidth;
/**
 图片的样式, ListDownImgTypeLeft: 在标题前面,  ListDownImgTypeRight: 在标题后面
 */
@property (nonatomic, assign) ListDownImgType imageType;

@end
