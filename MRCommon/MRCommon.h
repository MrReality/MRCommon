//
//  MRCommon.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#ifndef MRCommonPackaging_h
#define MRCommonPackaging_h

#import "UIButton+MRButton.h"
#import "UIImageView+MRImageView.h"
#import "NSArray+MRLog.h"
#import "NSAttributedString+MRAttributedString.h"
#import "NSString+MRString.h"
#import "UIColor+MRColor.h"
#import "UIScreen+MRScreen.h"
#import "UIView+MRView.h"
#import "NSDate+MRDate.h"
#import "UIImage+MRScale.h"

#import "MRSingleSwitch.h"
#import "MRInputBoxView.h"
#import "MRDropDownView.h"
#import "MRListDownView.h"
#import "MRChangeView.h"
#import "MRAlertView.h"
#import "MRGifView.h"
#import "MRHUD.h"
#import "MRBannerView.h"

#import "MRCommonColorAndPicture.h"
#import "MRCommonTime.h"
#import "MRCommonString.h"
#import "MRCommonOther.h"
#import "MRCommonRuntime.h"

// 导航栏
#define kNavigationHeight   (kIs_iPhone_X ? (kIsVerticalScreen? 88 : 32) : (kIsVerticalScreen? 64 : 32))

#define kUserDefault [NSUserDefaults standardUserDefaults]

/// tableBar
#define kTabBarHeight       49
/// 屏幕宽
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
/// 屏幕高
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

/// 是否是横屏
#define kIslandscapeScreen (kScreenWidth > kScreenHeight)
/// 是否是竖屏
#define kIsVerticalScreen (kScreenHeight > kScreenWidth)

#define kIs_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kIs_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/// 真实屏幕高
#define kScreenRealHeight (MAX(kScreenWidth, kScreenHeight))
/// 真实屏幕宽
#define kScreenRealWidth (MIN(kScreenWidth, kScreenHeight))

#define kIs_iPhone_5 (kIs_iPhone && kScreenRealHeight == 568.0)
#define kIs_iPhone_6 (kIs_iPhone && kScreenRealHeight == 667.0)
#define kIs_iPhone_6P (kIs_iPhone && kScreenRealHeight == 736.0)
#define kIs_iPhone_X (kIs_iPhone && kScreenRealHeight == 812.0)

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

/// 单例方法, 在 .h 里写一下
#define singleton_interface(class) + (instancetype)shared##class;

// 单例方法, 在 .m 里写一下
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
\
return _instance; \
} \
\
+ (instancetype)shared##class \
{ \
if (_instance == nil) { \
_instance = [[class alloc] init]; \
} \
\
return _instance; \
}


/*
 <!-- 相册 -->
 <key>NSPhotoLibraryUsageDescription</key>
 <string>App需要您的同意,才能访问相册</string>
 <!-- 相机 -->
 <key>NSCameraUsageDescription</key>
 <string>App需要您的同意,才能访问相机</string>
 <!-- 麦克风 -->
 <key>NSMicrophoneUsageDescription</key>
 <string>App需要您的同意,才能访问麦克风</string>
 <!-- 位置 -->
 <key>NSLocationUsageDescription</key>
 <string>App需要您的同意,才能访问位置</string>
 <!-- 在使用期间访问位置 -->
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>App需要您的同意,才能在使用期间访问位置</string>
 <!-- 始终访问位置 -->
 <key>NSLocationAlwaysUsageDescription</key>
 <string>App需要您的同意,才能始终访问位置</string>
 <!-- 日历 -->
 <key>NSCalendarsUsageDescription</key>
 <string>App需要您的同意,才能访问日历</string>
 <!-- 提醒事项 -->
 <key>NSRemindersUsageDescription</key>
 <string>App需要您的同意,才能访问提醒事项</string>
 <!-- 运动与健身 -->
 <key>NSMotionUsageDescription</key> <string>App需要您的同意,才能访问运动与健身</string>
 <!-- 健康更新 -->
 <key>NSHealthUpdateUsageDescription</key>
 <string>App需要您的同意,才能访问健康更新 </string>
 <!-- 健康分享 -->
 <key>NSHealthShareUsageDescription</key>
 <string>App需要您的同意,才能访问健康分享</string>
 <!-- 蓝牙 -->
 <key>NSBluetoothPeripheralUsageDescription</key>
 <string>App需要您的同意,才能访问蓝牙</string>
 <!-- 媒体资料库 -->
 <key>NSAppleMusicUsageDescription</key>
 <string>App需要您的同意,才能访问媒体资料库</string>
 */

#if 0  
弹出键盘样式
UIKeyboardTypeDefault,                  // 默认, 能输入汉字
UIKeyboardTypeASCIICapable,             // 输入英文和数字 语音
UIKeyboardTypeNumbersAndPunctuation,    // 能输入汉字
UIKeyboardTypeURL,                      // 英文 和 表情
UIKeyboardTypeNumberPad,                // 数字
UIKeyboardTypePhonePad,                 // 数字 *;等符号
UIKeyboardTypeNamePhonePad,             // 英文 数字 表情
UIKeyboardTypeEmailAddress,             // 英文 数字 表情 符号
UIKeyboardTypeDecimalPad                // 数字 .
UIKeyboardTypeTwitter                   // 英文 数字 表情 符号 @ #
UIKeyboardTypeWebSearch                 // 英文 数字 符号
UIKeyboardTypeASCIICapableNumberPad     // 数字
UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable,
#endif

#endif /* MRCommonPackaging_h */
