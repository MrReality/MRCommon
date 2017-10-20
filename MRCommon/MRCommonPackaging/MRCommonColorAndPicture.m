//
//  MRCommonColorAndPicture.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRCommonColorAndPicture.h"
#import "UIButton+MRButton.h"
#import "UIImageView+MRImageView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MRCommonColorAndPicture () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{

    NSData *data = UIImageJPEGRepresentation(image, 1.0);

    CGFloat dataKBytes = data.length/1000.0;

    CGFloat maxQuality = 0.9f;

    CGFloat lastData = dataKBytes;

    while (dataKBytes > size && maxQuality > 0.01f) {

        maxQuality = maxQuality - 0.01f;

        data = UIImageJPEGRepresentation(image, maxQuality);

        dataKBytes = data.length/1000.0;

        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
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

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    scroll.userInteractionEnabled = YES;
//    [window addSubview:scroll];
//    scroll.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight * 2);
//    scroll.showsVerticalScrollIndicator = NO;
//    scroll.showsHorizontalScrollIndicator = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor clearColor];
    [window addSubview:view];

//    MRCommonColorAndPicture *common = [MRCommonColorAndPicture sharedMRCommon];
//    common.scrView = scroll;

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = image;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [imgView clipsToBounds];
    [view addSubview:imgView];
//    [scroll addSubview:imgView];
    imgView.userInteractionEnabled = YES;
//    common.imgView = imgView;
//    common.frame = frame;

    [UIView animateWithDuration:.5 animations:^{
        imgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2);
        imgView.center = window.center;
//        scroll.backgroundColor = [UIColor blackColor];
        view.backgroundColor = [UIColor blackColor];
    }];

//    // 创建轻击对象, 双击
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
//    [scroll addGestureRecognizer:tapGesture];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [scroll addSubview:button];
    [view addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

    [button buttonActionWith:^(UIButton *button) {
        [UIView animateWithDuration:.5 animations:^{
            imgView.frame = frame;
//            scroll.backgroundColor = [UIColor clearColor];
            view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
//            [scroll removeFromSuperview];
            [view removeFromSuperview];
        }];
    }];

}

- (void)tapGestureAction{
    NSLog(@"双击");
    MRCommonColorAndPicture *common = [MRCommonColorAndPicture sharedMRCommon];
    [UIView animateWithDuration:.5 animations:^{
        common.imgView.frame = self.frame;
        common.scrView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [common.scrView removeFromSuperview];
    }];
}

- (UIImage *)imageSnapshotWithWebView:(UIView *)webView {
    UIGraphicsBeginImageContextWithOptions(webView.bounds.size, YES, webView.contentScaleFactor);
    [webView drawViewHierarchyInRect:webView.bounds afterScreenUpdates:NO];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}





@end
