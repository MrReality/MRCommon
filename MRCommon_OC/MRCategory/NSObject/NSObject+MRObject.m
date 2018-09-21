//
//  NSObject+MRObject.m
//  面向协议+MVVM+函数式编程
//
//  Created by Mac on 2017/12/7.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "NSObject+MRObject.h"

@implementation NSObject (MRObject)

/// 获取类名
+ (NSString *)name{
    return NSStringFromClass([self class]);
}
/// 获取类名
- (NSString *)name{
    return NSStringFromClass([self class]);
}

@end
