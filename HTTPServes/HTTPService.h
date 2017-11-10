//
//  MRHTTPService.h
//  MR_inke
//
//  Created by 刘入徵 on 2016/10/28.
//  Copyright © 2016年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 请求成功
typedef void (^HttpSuccessBlock)(id json);
/// 请求失败
typedef void (^HttpFailureBlock)(NSError * error);
/// 下载进度
typedef void (^HttpDownloadProgressBlock)(CGFloat progress);
/// 上传进度
typedef void (^HttpUploadProgressBlock)(CGFloat progress);

@interface HTTPService : NSObject

/// 配置 token
+ (void)setToken:(NSString *)token;

/**
 *  @param path    url 地址
 *  @param params  url 参数  NSDictionary 类型
 *  @param success 请求成功 返回 NSDictionary 或 NSArray
 *  @param failure 请求失败 返回 NSError
 */
/// get 网络请求
+ (void)getWithPath:(NSString *)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

/**
 *  @param path    url 地址
 *  @param params  url 参数  NSDictionary 类型
 *  @param success 请求成功 返回 NSDictionary 或 NSArray
 *  @param failure 请求失败 返回 NSError
 */
/// post 网络请求
+ (void)postWithPath:(NSString *)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

/**
 Delete
 @param path              url 地址
 @param params         参数
 @param success        成功回调
 @param failure           失败回调
 */
+ (void)deleteWithPath:(NSString *)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;


/**
 Put
 @param path             url 地址
 @param params       参数
 @param success       成功回调
 @param failure          失败回调
 */
+ (void)putWithPath:(NSString *)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

/**
 *  @param path     url 路径
 *  @param success  下载成功
 *  @param failure  下载失败
 *  @param progress 下载进度
 */
/// 下载文件
+ (void)downloadWithPath:(NSString *)path success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpDownloadProgressBlock)progress;

/**
 *  @param path         url 地址
 *  @param image        UIImage 对象
 *  @param imagekey     imagekey
 *  @param params       上传参数
 *  @param success      上传成功
 *  @param failure      上传失败
 *  @param progress     上传进度
 */
/// 上传图片
+ (void)uploadImageWithPath:(NSString *)path params:(NSDictionary *)params thumbName:(NSString *)imagekey image:(UIImage *)image success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpUploadProgressBlock)progress;

@end
