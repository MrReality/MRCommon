//
//  NSString+MRString.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MRString)

/// 给当前文件追加文档路径 Additional document path to the current files
- (NSString *)appendDocumentDir;

/// 给当前文件追加缓存路径 Additional cache path to the current files
- (NSString *)appendCacheDir;

/// 给当前文件追加临时路径 Additional temporary path to the current files
- (NSString *)appendTempDir;

@end
