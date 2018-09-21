//
//  UIViewController+MRUIVC.m
//  TestMethodSwizzling
//
//  Created by Mac on 2017/12/14.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "UIViewController+MRUIVC.h"
#import <objc/runtime.h>
#import "MRCommonOther.h"
#import "MRCommonTime.h"

#define kDocuments                    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
/// 数组文件的路径
#define kListPath                         [NSString stringWithFormat:@"%@/Listen/listArray.plist", kDocuments]

@implementation UIViewController (MRUIVC)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        /// 未改动的方法
        SEL oldViewWillAppearSEL = @selector(viewWillAppear:);
        /// 改动后的方法
        SEL newViewWillAppearSEL = @selector(mr_viewWillAppear:);
        /// 获取旧方法
        Method oldViewWillAppearMethod = class_getInstanceMethod(class, oldViewWillAppearSEL);
        /// 获取新方法
        Method newViewWillAppearMethod = class_getInstanceMethod(class, newViewWillAppearSEL);
        /// 检测是否已经添加该方法了
        BOOL didAddMethod = class_addMethod(class, oldViewWillAppearSEL, method_getImplementation(newViewWillAppearMethod), method_getTypeEncoding(newViewWillAppearMethod));
        if (didAddMethod)           /// 已经添加就替换方法
            class_replaceMethod(class, newViewWillAppearSEL, method_getImplementation(oldViewWillAppearMethod), method_getTypeEncoding(oldViewWillAppearMethod));
        else                                 /// 未添加就替换方法
            method_exchangeImplementations(oldViewWillAppearMethod, newViewWillAppearMethod);
        
        /// 替换 viewWillDisAppear
        SEL oldViewWillDisAppearSEL = @selector(viewWillDisappear:);
        SEL newViewWillDisAppearSEL = @selector(mr_viewWillDisappear:);
        Method oldViewWillDisAppearMethod = class_getInstanceMethod(class, oldViewWillDisAppearSEL);
        Method newViewWillDisAppearMethod = class_getInstanceMethod(class, newViewWillDisAppearSEL);
        BOOL didAddDisAppearMethod = class_addMethod(class, oldViewWillDisAppearSEL, method_getImplementation(newViewWillDisAppearMethod), method_getTypeEncoding(newViewWillDisAppearMethod));
        if(didAddDisAppearMethod)
            class_replaceMethod(class, newViewWillDisAppearSEL, method_getImplementation(oldViewWillDisAppearMethod), method_getTypeEncoding(oldViewWillDisAppearMethod));
        else
            method_exchangeImplementations(oldViewWillDisAppearMethod, newViewWillDisAppearMethod);
        
    });
}

/// MARK: Method Swizzling
- (void)mr_viewWillAppear:(BOOL)animated {
    [self mr_viewWillAppear:animated];
   
    NSString *time = [MRCommonTime currentDateWithFormat:@"yyyy:MM:dd HH:mm:ss"];
    NSString *string = [NSString stringWithFormat:@"[%@]: %@ appear 👻", time,  NSStringFromClass([self class])];
    [self wirteWithString:string];
}

- (void)mr_viewWillDisappear:(BOOL)animation{
    [self mr_viewWillDisappear:animation];
    
    NSString *time = [MRCommonTime currentDateWithFormat:@"yyyy:MM:dd HH:mm:ss"];
    NSString *string = [NSString stringWithFormat:@"[%@]: %@ disappear 🦋", time, NSStringFromClass([self class])];
    [self wirteWithString:string];
}

/// MARK: 写文件
- (void)wirteWithString:(NSString *)string{
    
    NSString *path = [NSString stringWithFormat:@"%@/Listen",  kDocuments];
    /// 先创建文件夹
    [MRCommonOther creatFolderWithFile:path];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:kListPath];
    if(!array){     /// 还没有创建操作记录
        array = [NSMutableArray array];
        NSString *newTxtPath = [path stringByAppendingPathComponent:@"1"];
        [array addObject:@"1"];
        newTxtPath = [newTxtPath stringByAppendingString:@".txt"];
        [MRCommonOther creatFileWithPath:newTxtPath isCover:NO];
    }
    
    /// 获取最后一个文件的大小
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.txt", path, array.lastObject];
    long long fileSize = [MRCommonOther fileSizeAtPath:filePath];
    if(fileSize > 5 * 1000 * 1000){     /// 重新创建一个
        NSString *newLastName = [NSString stringWithFormat:@"%ld", [array.lastObject integerValue] + 1];
        [array addObject:newLastName];
        NSString *newTxtPath = [path stringByAppendingPathComponent:newLastName];
        newTxtPath = [newTxtPath stringByAppendingString:@".txt"];
        [MRCommonOther creatFileWithPath:newTxtPath isCover:NO];
    }
    
    /// 获取最后一个文件
    path = [NSString stringWithFormat:@"%@/%@.txt", path, array.lastObject];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSMutableString *oldString = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *newString = [NSString stringWithFormat:@"%@\n", string];
    oldString = [oldString stringByAppendingString:newString].mutableCopy;
    [oldString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    [array writeToFile:kListPath atomically:YES];
}

@end
