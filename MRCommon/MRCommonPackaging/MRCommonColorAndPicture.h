//
//  MRCommonColorAndPicture.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TakePicture)(UIImage *image);

/// MARK: 处理图片和颜色的类
@interface MRCommonColorAndPicture : NSObject

/**
 1 生成随机颜色 Generate random color
 */
+ (UIColor *)randomColor;

/**
 2 16 进制颜色改为 UIcolor
 */
+(UIColor *)getColor:(NSString *) hexColor;

/**
 3 压缩图片到指定尺寸大小  Compressed image to the specified size
 */
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 4 压缩图片到指定文件大小 Compressed image to the specified file size
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/**
 5 对图片进行模糊处理 Blurred images
 // CIGaussianBlur ---> 高斯模糊
 // CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
 // CIDiscBlur    ---> 环形卷积模糊(Available in iOS 9.0 and later)
 // CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
 // CIMotionBlur  ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
 */
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;

/**
 6 对图片进行滤镜处理  To filter the image
 // 怀旧 --> CIPhotoEffectInstant                        单色 --> CIPhotoEffectMono
 // 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
 // 色调 --> CIPhotoEffectTonal                          冲印 --> CIPhotoEffectProcess
 // 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
 // CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;


/**
 7 调整图片饱和度, 亮度, 对比度 Adjust the picture saturation, brightness, contrast
 @param image 目标图片
 @param saturation 饱和度
 @param brightness 亮度   -1.0 ~ 1.0
 @param contrast 对比度
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;
/**
 8 全屏截图 Print screen
 */
+ (UIImage *)screenshot;

/**
 9 截取一个 view 上面的图 Capture a view of the above figure
 */
+ (UIImage *)screenshotWithView:(UIView *)view;

/**
 10 截取一个 view 上面某个区域的图 Capture a view above the figure of a region
 */
+ (UIImage *)screenshotWithView:(UIView *)view andArea:(CGRect)area;

/**
 11 拍照 Taking pictures
 */
+ (void)takeAPictureWithViewController:(UIViewController *)ctrl andBlock:(TakePicture)block;

/**
 12 选照片 Choose photos
 */
+ (void)chosePictureWithViewController:(UIViewController *)ctrl andBlock:(TakePicture)block;

/**
 13 点击照片展示照片 Click the pictures show
 */
+ (void)showPictureWithFrame:(CGRect)frame andPicture:(UIImage *)image;

/// 14 webView 导出图片调用的方法, The method called webView export images
- (UIImage *)imageSnapshotWithWebView:(UIView *)webView;

@end
