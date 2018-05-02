//
//  NSObject+MRModelManager.m
//  Json 转 model
//
//  Created by Mac on 2017/7/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "NSObject+MRModelManager.h"
#import <YYKit/NSObject+YYModel.h>

@implementation NSObject (MRModelManager)

/// MARK: 根据 array 获取 modelArray
+ (NSMutableArray *)mr_modelWithArray:(NSArray *)array{

    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dic in array) {
       [result addObject: [self modelWithDictionary:dic]];
    }
    return result;
}

/// MARK: 根据 dic 获取 model
+ (instancetype)mr_modelWithDictionary:(NSDictionary *)dic{
    return [self modelWithDictionary:dic];;
}

/// MARK: 根据 字典或者数组 获取 modelArray 或者 model
+ (id)mr_modelWithObject:(id)object{

    /// 数组
    if([object isKindOfClass:[NSMutableArray class]] || [object isKindOfClass:[NSArray class]]){
        return [self mr_modelWithArray:object];
    }
    /// 字典
    if([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]){
        return [self mr_modelWithDictionary:object];
    }
    return nil;
}

/// MARK: model 转数组
- (NSMutableArray *)mr_arrayKeyValues{
    
    NSMutableArray *array = [NSMutableArray array];
    for (id objc in (NSMutableArray *)self) {
        [array addObject:[objc modelToJSONObject]];
    }
    return array;
}

/// MARK: model 转字典
- (NSMutableDictionary *)mr_dicKeyValues{
    return [self modelToJSONObject];
}

/// MARK: model 转 数组或者字典
- (id)mr_keyValues{
    
    /// 数组
    if([self isKindOfClass:[NSMutableArray class]] || [self isKindOfClass:[NSArray class]]){
        return [self mr_arrayKeyValues];
    }
    /// 字典
    if([self isKindOfClass:[NSMutableDictionary class]] || [self isKindOfClass:[NSDictionary class]]){
        return [self mr_dicKeyValues];
    }
    return self.modelToJSONObject;
}

@end
