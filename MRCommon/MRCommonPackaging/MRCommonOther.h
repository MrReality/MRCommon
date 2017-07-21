//
//  MRCommonOther.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^OKBlock)();
typedef void(^CancleBlock)();
typedef void(^DelayBlock)();

// 1 判断是否有网的 enum  If there is a network of judgment
typedef NS_ENUM(NSInteger, CommonOtherNetWorkType){

    CommonOtherTypeNoNetwork    =  0,   // 没有网  No network
    CommonOtherType3G           =  1,   // 3G 网  The 3g network
    CommonOtherTypeWifi         =  2    // wifi   Wifi network
};

// 2 判断号码状态 enum Determine number state
typedef NS_ENUM(NSInteger, CommonOtherThingType) {

    CommonOtherTypeCallPhone    =  0,    // 打电话             Make a phone call
    CommonOtherTypeSendMessage  =  1,    // 发短信             texting
    CommonOtherTypeSendEmail    =  2,    // 发邮件             email
    CommonOtherTypeJumpAppStore =  3     // 跳转到 appStore    Jump to appStore
};

// 3 DoubleAlert 的 enum
typedef NS_ENUM(NSInteger, CommonOtherDoubleAlertType){

    CommonOtherCancelAndOK      = 1,     // 取消和确定 CancelAndOK
    CommonOtherCancelAndGo      = 2,     // 取消和前往 CancelAndGo
    CommonOtherCancelAndAdd     = 3      // 取消和添加 CancelAndAdd
};

typedef NS_ENUM(NSInteger, CommonOtherJumpType){

    CommonOtherJumpTypeWiFi      ,       // 跳转到 WIFI 界面       jump to  Wifi
    CommonOtherJumpTypeBluetooth ,       // 跳转到 蓝牙 界面       jump to  Bluetooth
    CommonOtherJumpType4G        ,       // 跳转到 蜂窝数据 界面       jump to  Cellular data
    CommonOtherJumpTypeCarrier   ,       // 跳转到 运营商 界面       jump to  Carrier
    CommonOtherJumpTypeNotifi    ,       // 跳转到 通知 界面       jump to  notice
    CommonOtherJumpTypeGeneral   ,       // 跳转到 通用 界面       jump to  General
    CommonOtherJumpTypeKeyboard  ,       // 跳转到 键盘 界面       jump to  Keyboard
    CommonOtherJumpTypeAccess    ,       // 跳转到 辅助功能 界面       jump to  auxiliary
    CommonOtherJumpTypeLanguage  ,       // 跳转到 语言与地区 界面       jump to  Language and region
    CommonOtherJumpTypeReset     ,       // 跳转到 还原 界面       jump to  Reset
    CommonOtherJumpTypeWallpaper ,       // 跳转到 墙纸 界面       jump to  Wallpaper
    CommonOtherJumpTypeSiri      ,       // 跳转到 Siri 界面       jump to  Siri
    CommonOtherJumpTypePrivacy   ,       // 跳转到 隐私 界面       jump to  Privacy
    CommonOtherJumpTypeLocation  ,       // 跳转到 定位 界面       jump to  Location
    CommonOtherJumpTypeSafari    ,       // 跳转到 Safari 界面       jump to  Safari
    CommonOtherJumpTypeMusic     ,       // 跳转到 Music 界面       jump to  Music
    CommonOtherJumpTypeEQ        ,       // 跳转到 均衡器 界面       jump to  Music-EQ
    CommonOtherJumpTypePhotos    ,       // 跳转到 照片 界面       jump to  Photos
    CommonOtherJumpTypeFaceTime  ,       // 跳转到 FaceTime 界面       jump to  FaceTime
};


/// MARK: 处理杂项的类
@interface MRCommonOther : NSObject

/**
 4 判断网络状态  To determine the network status
 TypeNoNetwork: 没有网   / Type3G: 3G    / TypeWifi Wifi
 */
+ (CommonOtherNetWorkType)checkNetwork;

/**
 5 判断号码状态 Determine number state
 TypeCallPhone: 打电话  TypeSendMessage: 发短信  TypeSendEmail: 发邮件  TypeJumpAppStore: 跳转到 AppStore
 */
+ (void)num:(NSString *)number andType:(CommonOtherThingType)type;

/**
 6 反序列化 deserialization
 */
+(NSDictionary *)jsonDictionarBystring:(NSString *)message;

/**
 7 获取 根控制器 To obtain the root controller
 */
+ (UIViewController *)getRootVC;

/**
 8 获取 view 所在的控制器 Get a view of the controller
 @param view 视图
 */
+ (UIViewController *)getViewControllerByView:(UIView *)view;

/**
 9 获取文件大小 Access to the file size
 */
+ (long long)fileSizeAtPath:(NSString *)filePath;

/**
 *  10 获取 path 路径文件夹的大小                Get the size of the folder path path
 *  @param path 要获取大小的文件夹全路径       The full path to get the size of the folder
 *  @return 返回 path 路径文件夹的大小        Return the size of the folder path path
 */
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;

/**
 *  11 清除 path 路径文件夹的缓存            To clear the path cache folder
 *  @param path  要清除缓存的文件夹全路径  The full path to clear the cache folder
 *  @return 是否清除成功                 Whether to clear success
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;

/**
 12 MD5 32 位加密 MD5 32-bit encryption
 */
+ (NSString *)md5With32:(NSString *)str;

/**
 13 32位 MD5 大写
 */
+ (NSString *)md5With32Big:(NSString *)str;

/**
 14 添加偏移量的加密 Add the offset of the encryption
 */
+ (NSString *)MD5WithPassWord:(NSString *)str;

/**
  15 创建一个 两选项的 alert, Create a two options alert
  CommonOtherCancelAndOK:  取消 确定
  CommonOtherCancelAndGo:  取消 前往
  CommonOtherCancelAndAdd: 取消 添加
 */
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message type:(CommonOtherDoubleAlertType)type viewController:(UIViewController *)viewController OKBlock:(OKBlock)okBlock CancelBlock:(CancleBlock)cancelBlock;

/**
16 创建一个 单选项的 alert, Create a one option alert
 */
+ (void)alertSingleWithTitle:(NSString *)title message:(NSString *)message buttonName:(NSString *)name viewController:(UIViewController *)viewController OKBlock:(OKBlock)okBlock;

/**
 17 延时调用 Delay call
 */
+ (void)delayWithTime:(NSTimeInterval)time delayBlock:(DelayBlock)block;

/// 18 跳转到 iphone 指定页面, 需要在 info 添加 URL types 字段, 并在 item0 里添加 URL Schemes 值为 prefs
+ (void)jumpWithType:(CommonOtherJumpType)type;

/// 19 根据路径创建一个文件夹
+ (BOOL)creatFolderWithFile:(NSString *)file;

/// 20 根据路径创建文件 第二个参数, 是否覆盖掉
+ (BOOL)creatFileWithPath:(NSString *)path isCover:(BOOL)isCover;

/// 21 求两线的交点坐标  ab 一条线, cd 一条线
+ (CGPoint)testWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC pointD:(CGPoint)pointD;

@end
