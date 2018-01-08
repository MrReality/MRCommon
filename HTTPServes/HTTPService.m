//
//  MRHTTPService.m
//  MR_inke
//
//  Created by 刘入徵 on 2016/10/28.
//  Copyright © 2016年 Mix_Reality. All rights reserved.
//

#import "HTTPService.h"
#import "AFNetworking.h"
#import "Common.h"


@interface AFHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@implementation AFHttpClient

+ (instancetype)sharedClient {
    
    static AFHttpClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        client = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:API_BaseURL] sessionConfiguration:configuration];
        
        client.requestSerializer = [AFJSONRequestSerializer serializer];
        client.responseSerializer = [AFJSONResponseSerializer serializer];
        /// 接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        /// 添加 token
        [client.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        [client.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [client.requestSerializer setValue:@"webc" forHTTPHeaderField:@"Authtype"];
//        [client.requestSerializer setValue:@"b939feeee0e1305eea50d2e28a99eeb0" forHTTPHeaderField:@"Authorization"];
        /// 设置超时时间
        client.requestSerializer.timeoutInterval = 15;
        /// 安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    return client;
}

@end

@implementation HTTPService

+ (BOOL)testWithOSSURL:(NSString *)path{
    if([path rangeOfString:@"oss"].location != NSNotFound){
        return YES;
    }else{
        return NO;
    }
    return NO;
}

+ (BOOL)testWithWeiXinURL:(NSString *)path{
    if([path rangeOfString:@"yibai-web"].location != NSNotFound){
        return YES;
    }else{
        return NO;
    }
    return NO;
}

/// MARK: 配置 token
+ (void)setToken:(NSString *)token{
    [[AFHttpClient sharedClient].requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
}

/// MARK: GET
+ (void)getWithPath:(NSString *)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure {
    
    /// 获取完整的 url 路径
    NSString * url = [API_BaseURL stringByAppendingPathComponent:path];
    
//    /// 临时加的
//    BOOL is100Doc = [self testWithOSSURL:path];
//    if(is100Doc){           /// 是 100 doc 的接口
//        url = [API_OSSURL stringByAppendingString:path];
//    }
//    BOOL isWixin = [self testWithWeiXinURL:path];
//    if(isWixin){            /// 微信 url
//        url = [API_UserURL stringByAppendingString:path];
//    }

    AFHttpClient *client = [AFHttpClient sharedClient];

    [client GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
            success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
            failure(error);
    }];
}

/// MARK: Post
+ (void)postWithPath:(NSString *)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure {
    
    /// 获取完整的 url 路径
    NSString * url = [API_BaseURL stringByAppendingPathComponent:path];
    
    /// 临时加的
//    BOOL is100Doc = [self testWithOSSURL:path];
//    if(is100Doc){           /// 是 100 doc 的接口
//        url = [API_OSSURL stringByAppendingString:path];
//    }
//    BOOL isWixin = [self testWithWeiXinURL:path];
//    if(isWixin){            /// 微信 url
//        url = [API_UserURL stringByAppendingString:path];
//    }
    
    [[AFHttpClient sharedClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
            success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
            failure(error);
    }];
}

/// MARK: delete
+ (void)deleteWithPath:(NSString *)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    
    NSString *url = [API_BaseURL stringByAppendingPathComponent:path];

    /// 临时加的
//    BOOL is100Doc = [self testWithOSSURL:path];
//    if(is100Doc){           /// 是 100 doc 的接口
//        url = [API_OSSURL stringByAppendingString:path];
//    }
//    BOOL isWixin = [self testWithWeiXinURL:path];
//    if(isWixin){            /// 微信 url
//        url = [API_UserURL stringByAppendingString:path];
//    }
    
    [[AFHttpClient sharedClient] DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
            success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
            failure(error);
    }];
}

/// MARK: PUT
+ (void)putWithPath:(NSString *)path params:(id)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure{
    
    NSString *url = [API_BaseURL stringByAppendingPathComponent:path];
    [[AFHttpClient sharedClient] PUT:url parameters:path success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
            success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
            failure(error);
    }];
}

/// MARK: 下载
+ (void)downloadWithPath:(NSString *)path success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpDownloadProgressBlock)progress {
    
    /// 获取完整的 url 路径
    NSString * urlString = [API_BaseURL stringByAppendingPathComponent:path];
    
    // 下载
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [[AFHttpClient sharedClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progress)
            progress(downloadProgress.fractionCompleted);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //获取沙盒 cache 路径
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {                        /// 失败了
            failure(error);
        } else {                            /// 成功了
            success(filePath.path);
        }
    }];
    [downloadTask resume];
}

/// MARK: 上传
+ (void)uploadImageWithPath:(NSString *)path params:(NSDictionary *)params thumbName:(NSString *)imagekey image:(UIImage *)image success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpUploadProgressBlock)progress {
    
    /// 获取完整的 url 路径
    NSString * urlString = [API_BaseURL stringByAppendingPathComponent:path];
    
    NSData * data = UIImagePNGRepresentation(image);
    
    [[AFHttpClient sharedClient] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:imagekey fileName:@"01.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress)
            progress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
            success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
            failure(error);
    }];
}


@end
