//
//  MRCommonColorAndPicture.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRCommonColorAndPicture.h"
#import "UIButton+MRButton.h"
#import "UIView+MRView.h"
#import "UIImageView+MRImageView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MRCommonColorAndPicture () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) TakePicture block;
// 获取过来的控制器
@property (nonatomic, weak) UIViewController *ctrl;
// 查看图片的 ScroView
@property (nonatomic, weak) UIScrollView *scrView;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, weak) UIImageView *imgView;

@end

@implementation MRCommonColorAndPicture

+ (instancetype)sharedMRCommon{

    static MRCommonColorAndPicture *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MRCommonColorAndPicture alloc] init];
    });
    return instance;
}

// 生成随机颜色
+ (UIColor *)randomColor{

    CGFloat red = random() % 256;
    CGFloat green = random() % 256;
    CGFloat blue = random() % 256;

    return [UIColor colorWithRed:red / 256 green:green / 256 blue:blue / 256 alpha:1];
}

// 16 进制颜色改为 UIcolor
+(UIColor *)getColor:(NSString *) hexColor{

    unsigned int red,green,blue;

    NSRange range;

    range.length = 2;

    range.location = 0;

    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];

    range.location = 2;

    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];

    range.location = 4;

    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];

    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

// 等比例压缩
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if(newImage == nil){
        NSLog(@"scale image fail");
    }

    UIGraphicsEndImageContext();

    return newImage;
    
}


//压缩图片到指定文件大小
+ (UIImage *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{

    NSData * imageData = UIImageJPEGRepresentation(image,1);
    double lenth = imageData.length;
    if(lenth > size){    // 大于 1M
        double imgLenth = lenth;
        UIImage *smallImage = image;
        while (imgLenth > size) {
            
            CGFloat fixelW = CGImageGetWidth(smallImage.CGImage);
            CGFloat fixelH = CGImageGetHeight(smallImage.CGImage);
            smallImage = [self imageCompressForSize:smallImage targetSize:CGSizeMake(fixelW / 2, fixelH / 2)];
            NSData * imageData = UIImageJPEGRepresentation(smallImage, 1);
            imgLenth = imageData.length;
        }
        return smallImage;
    }
    return image;
}

#pragma mark - 对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊

// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)

// CIDiscBlur    ---> 环形卷积模糊(Available in iOS 9.0 and later)

// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)

// CIMotionBlur  ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius{

    CIContext *context = [CIContext contextWithOptions:nil];

    CIImage *inputImage = [[CIImage alloc] initWithImage:image];

    CIFilter *filter;

    if (name.length != 0) {

        filter = [CIFilter filterWithName:name];

        [filter setValue:inputImage forKey:kCIInputImageKey];

        if (![name isEqualToString:@"CIMedianFilter"]) {

            [filter setValue:@(radius) forKey:@"inputRadius"];

        }

        CIImage *result = [filter valueForKey:kCIOutputImageKey];

        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];

        UIImage *resultImage = [UIImage imageWithCGImage:cgImage];

        CGImageRelease(cgImage);

        return resultImage;

    }else{

        return nil;

    }
}

#pragma mark - 对图片进行滤镜处理
// 怀旧 --> CIPhotoEffectInstant                        单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                          冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name{

    CIContext *context = [CIContext contextWithOptions:nil];

    CIImage *inputImage = [[CIImage alloc] initWithImage:image];

    CIFilter *filter = [CIFilter filterWithName:name];

    [filter setValue:inputImage forKey:kCIInputImageKey];

    CIImage *result = [filter valueForKey:kCIOutputImageKey];

    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];

    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);

    return resultImage;
}

/**
 调整图片饱和度, 亮度, 对比度

 @param image 目标图片
 @param saturation 饱和度
 @param brightness 亮度   -1.0 ~ 1.0
 @param contrast 对比度
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:kCIInputImageKey];

    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    [filter setValue:@(brightness) forKey:@"inputBrightness"];// 0.0 ~ 1.0
    [filter setValue:@(contrast) forKey:@"inputContrast"];

    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}

// 全屏截图
+ (UIImage *)screenshot{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContext(window.bounds.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 截取一个 view 上面的图
+ (UIImage *)screenshotWithView:(UIView *)view{

    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 截取一个 view 上面某个区域的图
+ (UIImage *)screenshotWithView:(UIView *)view andArea:(CGRect)area{

    CGImageRef imageRef = CGImageCreateWithImageInRect([self screenshotWithView:view].CGImage, area);

    UIGraphicsBeginImageContext(area.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, area.size.width, area.size.height);

    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, rect, imageRef);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGImageRelease(imageRef);
//    CGContextRelease(context);

    return image;
}

+ (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

/**
 拍照
 */
+ (void)takeAPictureWithViewController:(UIViewController *)ctrl andBlock:(TakePicture)block{

    MRCommonColorAndPicture *common = [MRCommonColorAndPicture sharedMRCommon];
    common.block = block;
    common.ctrl = ctrl;
    [common takepictureWithVC:ctrl];
}

/**
 选照片
 */
+ (void)chosePictureWithViewController:(UIViewController *)ctrl andBlock:(TakePicture)block{

    MRCommonColorAndPicture *common = [MRCommonColorAndPicture sharedMRCommon];
    common.block = block;
    common.ctrl = ctrl;
    [common chosePictureWithCtrl:ctrl];
}

- (void)chosePictureWithCtrl:(UIViewController *)ctrl{

    UIImagePickerController *imagePC = [[UIImagePickerController alloc]init];
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePC.delegate = self;
    [ctrl presentViewController:imagePC animated:YES completion:nil];
}

- (void)takepictureWithVC:(UIViewController *)ctrl{
    
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){

        UIImagePickerController *canemaPC = [[UIImagePickerController alloc]init];
        canemaPC.sourceType = UIImagePickerControllerSourceTypeCamera ;
        canemaPC.delegate = self;
        [ctrl presentViewController:canemaPC animated:YES completion:nil];

    }else{

        UIAlertController *alterCtrl = [UIAlertController alertControllerWithTitle:@"你好" message:@"该设备没有相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alterCtrl addAction:action2];
        [ctrl presentViewController:alterCtrl animated:YES completion:nil];
        return;
    }
}

#pragma mark - UIImagePickCOntroller 的代理方法实现
// 选择照片、视频，拍照、拍视频后，最终都会调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    MRCommonColorAndPicture *common = [MRCommonColorAndPicture sharedMRCommon];

    NSString *mediaType = info[@"UIImagePickerControllerMediaType"];
    if([mediaType isEqualToString:@"public.image"]){

        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        if(!common.block){
            return;
        }
        common.block(image);
    }
    [common.ctrl dismissViewControllerAnimated:YES completion:nil];
}

// 点击了相册的取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    MRCommonColorAndPicture *common = [MRCommonColorAndPicture sharedMRCommon];
    [common.ctrl dismissViewControllerAnimated:YES completion:nil];
}

/**
 点击照片展示照片
 */
+ (void)showPictureWithFrame:(CGRect)frame andPicture:(UIImage *)image{
    MRCommonColorAndPicture *common = [MRCommonColorAndPicture sharedMRCommon];
    [common initScrollViewWithFrame:frame andPicture:image];
}

- (void)initScrollViewWithFrame:(CGRect)frame andPicture:(UIImage *)image{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scroll.userInteractionEnabled = YES;
    [window addSubview:scroll];
    scroll.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.maximumZoomScale = 2;
    scroll.minimumZoomScale = 1;
    scroll.directionalLockEnabled = YES;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = image;
    imgView.tag = 100;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [imgView clipsToBounds];
    [scroll addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    
    self.scrView = scroll;
    self.imgView = imgView;
    self.frame = frame;
    scroll.delegate = self;
    
    [UIView animateWithDuration:.25 animations:^{
        imgView.size = CGSizeMake(kScreenWidth, kScreenHeight);
        imgView.center = CGPointMake(scroll.width / 2, scroll.height / 2);
        scroll.backgroundColor = [UIColor blackColor];
    }];
    
    // 创建轻击对象
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
    tapGesture.numberOfTapsRequired = 1;
    [scroll addGestureRecognizer:tapGesture];
    // 创建轻击对象, 双击
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction2)];
    tapGesture2.numberOfTapsRequired = 2;
    [scroll addGestureRecognizer:tapGesture2];
    
    // 设置当 tapGesture2 触发时, tapGesture 不触发响应
    [tapGesture requireGestureRecognizerToFail:tapGesture2];
}

/// 单击事件
- (void)tapGestureAction{
    MRCommonColorAndPicture *common = [MRCommonColorAndPicture sharedMRCommon];
    [UIView animateWithDuration:.25 animations:^{
        common.imgView.frame = common.frame;
        common.scrView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [common.scrView removeFromSuperview];
    }];
}

/// 双击事件
- (void)tapGestureAction2{
    if(self.scrView.zoomScale != 1){
        [self.scrView setZoomScale:1 animated:YES];
    }else{
      [self.scrView setZoomScale:2 animated:YES];
    }
}

- (UIImage *)imageSnapshotWithWebView:(UIView *)webView {
    UIGraphicsBeginImageContextWithOptions(webView.bounds.size, YES, webView.contentScaleFactor);
    [webView drawViewHierarchyInRect:webView.bounds afterScreenUpdates:NO];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/// MARK: scrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView viewWithTag:100];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if(scrollView.zoomScale == 2){
        CGFloat top = scrollView.zoomScale * kScreenHeight / 4;
        if(y != top){
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, top) animated:NO];
        }
    }

}



@end
