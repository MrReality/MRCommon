//
//  MRCommonOther.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRCommonOther.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import <netdb.h>
#import <arpa/inet.h>


#define kFileManager [NSFileManager defaultManager]

@interface MRCommonOther ()

@property (nonatomic, copy) DelayBlock block;

@property (nonatomic, copy) CommonNetWorkBlock netBlock;

@property (nonatomic, strong) Reachability *reachability;

@end

@implementation MRCommonOther

// 单例
+ (instancetype)shared{

    static MRCommonOther *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MRCommonOther alloc] init];
    });
    return instance;
}

/**
 判断网络状态
 */
+ (CommonOtherNetWorkType)checkNetwork{

    NSInteger result;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];

    switch ([r currentReachabilityStatus]) {
        case NotReachable:      // 没有网络连接
            result = CommonOtherTypeNoNetwork;
            break;
        case ReachableViaWWAN:  // 使用3G网络
            result = CommonOtherType3G;
            break;
        case ReachableViaWiFi:  // 使用WiFi网络
            result = CommonOtherTypeWifi;
            break;
    }
    return result;
}

// MARK:  TypeCallPhone: 打电话  TypeSendMessage: 发短信  TypeSendEmail: 发邮件  TypeJumpAppStore: 跳转到AppStore
+ (void)num:(NSString *)number andType:(CommonOtherThingType)type{

    NSString *num;
    if(type == CommonOtherTypeCallPhone){                // 打电话
        num = [NSString stringWithFormat:@"tel://%@", number];
    }else if(type == CommonOtherTypeSendMessage){        // 发短信
        num = [NSString stringWithFormat:@"sms://%@", number];
    }else if(type == CommonOtherTypeSendEmail){          // 发邮件
        num = [NSString stringWithFormat:@"mailto://%@", number];
    }else if(type == CommonOtherTypeJumpAppStore){       // 应用评分
        num = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", number];
    }else{
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}

//反序列化
+(NSDictionary *)jsonDictionarBystring:(NSString *)message{

    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];

    NSError *err;

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData

                                                        options:NSJSONReadingMutableContainers

                                                          error:&err];;
    return dic;
}


//md5 32位 加密 （小写）
+ (NSString *)md5With32:(NSString *)str {

    const char *cStr = [str UTF8String];
    unsigned char result[16];

    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );

    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString *)md5With32Big:(NSString *)str{

    const char *cStr = [str UTF8String];
    unsigned char result[16];

    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );

    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

/**
 获取 根控制器
 */
+ (UIViewController *)getRootVC{

    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

// 获取 view 所在的控制器
+ (UIViewController *)getViewControllerByView:(UIView *)view{

    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

//获取文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath{

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:filePath]) return 0;

    return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
}

// 获取 path 路径下文件夹大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path{
    // 调试
#ifdef DEBUG
    // 如果文件夹不存在或者不是一个文件夹那么就抛出一个异常
    // 抛出异常会导致程序闪退，所以只在调试阶段抛出，发布阶段不要再抛了,不然极度影响用户体验
    BOOL isDirectory = NO;
    BOOL isExist = [kFileManager fileExistsAtPath:path isDirectory:&isDirectory];

    if (!isExist || !isDirectory){

        NSException *exception = [NSException exceptionWithName:@"fileError" reason:@"please check your filePath!" userInfo:nil];
        [exception raise];
    }
//    NSLog(@"debug");
    //发布
#else
//    NSLog(@"post");
#endif

    // 获取 “path” 文件夹下面的所有文件
    NSArray *subpathArray= [kFileManager subpathsAtPath:path];
    NSString *filePath = nil;
    NSInteger totleSize=0;

    for (NSString *subpath in subpathArray){

        // 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subpath];

        // isDirectory，是否是文件夹，默认不是
        BOOL isDirectory = NO;

        // isExist，判断文件是否存在
        BOOL isExist = [kFileManager fileExistsAtPath:filePath isDirectory:&isDirectory];

        // 判断文件是否存在，不存在的话过滤
        // 如果存在的话，那么是否是文件夹，是的话也过滤
        // 如果文件既存在又不是文件夹，那么判断它是不是隐藏文件，是的话也过滤
        // 过滤以上三个情况后，就是一个文件夹里面真实的文件的总大小
        // 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]) continue;
        // NSLog(@"%@",filePath);
        // 指定路径，获取这个路径的属性
        // attributesOfItemAtPath:需要传文件夹路径
        // 但是attributesOfItemAtPath 只可以获得文件属性，不可以获得文件夹属性，这个也就是需要for-in遍历文件夹里面每一个文件的原因
        NSDictionary *dict=   [kFileManager attributesOfItemAtPath:filePath error:nil];

        NSInteger size=[dict[@"NSFileSize"] integerValue];
        totleSize+=size;
    }

    // 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;

    if (totleSize > 1000 * 1000){

        totleStr = [NSString stringWithFormat:@"%.1fM",totleSize / 1000.0f /1000.0f];
    }else if (totleSize > 1000){

        totleStr = [NSString stringWithFormat:@"%.1fKB",totleSize / 1000.0f ];

    }else{

        totleStr = [NSString stringWithFormat:@"%.1fB",totleSize / 1.0f];
    }
    return totleStr;
}

// 清除 path 文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path{

    // 拿到 path 路径的下一级目录的子文件夹
    NSArray *subpathArray = [kFileManager contentsOfDirectoryAtPath:path error:nil];

    NSString *message = nil;
    NSError *error = nil;
    NSString *filePath = nil;

    for (NSString *subpath in subpathArray){

        filePath =[path stringByAppendingPathComponent:subpath];
        // 删除子文件夹
        [kFileManager removeItemAtPath:filePath error:&error];
        if (error) {
            message = [NSString stringWithFormat:@"%@这个路径的文件夹删除失败了，请检查后重新再试",filePath];
            continue;
        }else {
            message = @"成功了";
        }
    }
    //    NSLog(@"%@",message);
    return YES;
}

+ (NSString *)MD5WithPassWord:(NSString *)str{

    NSString *pass = [NSString stringWithFormat:@"%@", str];

    return [self md5With32:pass];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message type:(CommonOtherDoubleAlertType)type viewController:(UIViewController *)viewController OKBlock:(OKBlock)okBlock CancelBlock:(CancleBlock)cancelBlock{

    NSString *cancel;
    NSString *ok;
    if(type == CommonOtherCancelAndOK){           // 取消 确定
        cancel = @"取消";
        ok = @"确定";
    }else if(type == CommonOtherCancelAndGo){     // 取消 前往
        cancel = @"取消";
        ok = @"前往";
    }else if(type == CommonOtherCancelAndAdd){    // 取消 添加
        cancel = @"取消";
        ok = @"添加";
    }else{
        cancel = @"取消";
        ok = @"确定";
    }

    UIAlertController *alterCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    //添加确定和取消的按钮
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if(!cancelBlock){
            return;
        }
        cancelBlock();
    }];
    //最后一个参数是一个 block 块,当确定/取消按钮被点击的时候,会回调
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(!okBlock){
            return;
        }
        okBlock();
    }];

    //将UIAlertAction 对象和UIAlertController 对象关联
    [alterCtrl addAction:action1];
    [alterCtrl addAction:action2];
    // 需要异步弹出, 不然会阻塞线程, 造成卡顿
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alterCtrl animated:YES completion:nil];
    });
//    [viewController presentViewController:alterCtrl animated:YES completion:nil];
}

// 创建一个 单选项的 alert
+ (void)alertSingleWithTitle:(NSString *)title message:(NSString *)message buttonName:(NSString *)name viewController:(UIViewController *)viewController OKBlock:(OKBlock)okBlock{

    UIAlertController *alterCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(!okBlock){
            return;
        }
        okBlock();
    }];
    //将UIAlertAction 对象和UIAlertController 对象关联
    [alterCtrl addAction:action1];
    // 需要异步弹出, 不然会阻塞线程, 造成卡顿
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alterCtrl animated:YES completion:nil];
    });
//    [viewController presentViewController:alterCtrl animated:YES completion:nil];
}

// 延时调用
+ (void)delayWithTime:(NSTimeInterval)time delayBlock:(DelayBlock)block{

    MRCommonOther *other = [MRCommonOther shared];
    [other performSelector:@selector(delayAction) withObject:nil afterDelay:time];
    other.block = block;
}

- (void)delayAction{

    DelayBlock block = [MRCommonOther shared].block;
    block();
}

/// 19 根据路径创建一个文件夹
+ (BOOL)creatFolderWithFile:(NSString *)file{
    
    BOOL isSuccess = NO;
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:file isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ){
        
       isSuccess = [fileManager createDirectoryAtPath:file withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return isSuccess;
}

/// 20 根据路径创建文件 第二个参数, 是否覆盖掉
+ (BOOL)creatFileWithPath:(NSString *)path isCover:(BOOL)isCover{

    BOOL isSuccess = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {         // 没有该文件
        
       isSuccess = [fileManager createFileAtPath:path contents:nil attributes:nil];
    }else{                                              // 有该文件
        if(isCover){
            isSuccess = [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
    }
    return isSuccess;
}


/// 21 求两线的交点坐标
+ (CGPoint)testWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC pointD:(CGPoint)pointD{

    // 三角形 abc 面积的 2 倍
    CGFloat area_abc = (pointA.x - pointC.x) * (pointB.y - pointC.y) - (pointA.y - pointC.y) * (pointB.x - pointC.x);
    
    // 三角形 abd 面积的 2 倍
    CGFloat area_abd = (pointA.x - pointD.x) * (pointB.y - pointD.y) - (pointA.y - pointD.y) * (pointB.x - pointD.x);

    // 面积符号相同则两点在线段同侧,不相交 (对点在线段上的情况,本例当作不相交处理);
    if ( area_abc*area_abd >= 0 ) {
        NSLog(@"两线不相交");
        return CGPointZero;
    }
    // 三角形 cda 面积的2倍
    CGFloat area_cda = (pointC.x - pointA.x) * (pointD.y - pointA.y) - (pointC.y - pointA.y) * (pointD.x - pointA.x);
    // 三角形 cdb 面积的2倍
    // 注意: 这里有一个小优化.不需要再用公式计算面积,而是通过已知的三个面积加减得出.
    CGFloat area_cdb = area_cda + area_abc - area_abd ;
    if(area_cda * area_cdb >= 0){
        return CGPointZero;
    }
    
    // 计算交点坐标
    CGFloat t  = area_cda /(area_abd - area_abc);
    CGFloat dx = t * (pointB.x - pointA.x);
    CGFloat dy = t * (pointB.y - pointA.y);
    return CGPointMake(pointA.x + dx, pointA.y + dy);
}

// 实时监听网络状态
+ (void)startMonitorWithType:(CommonNetWorkBlock)block{
    [MRCommonOther shared].netBlock = block;
    [[MRCommonOther shared] checkReachability];
}

/// 监听网络状态
- (void)checkReachability{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    [self updateInterfaceWithReachability:self.reachability];
}

- (void) reachabilityChanged:(NSNotification *)note{
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability{
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == ReachableViaWiFi){                 /// wifi
        self.netBlock(CommonOtherTypeWifi);
    }else if(status == NotReachable){               /// 没网
        self.netBlock(CommonOtherTypeNoNetwork);
    }else if(status == ReachableViaWWAN){   /// 3G
        self.netBlock(CommonOtherType3G);
    }
}

/// 取消监听
+ (void)endMonitor{
    [[NSNotificationCenter defaultCenter] removeObserver:[MRCommonOther shared] name:kReachabilityChangedNotification object:nil];
    [[MRCommonOther shared].reachability stopNotifier];
}

@end
