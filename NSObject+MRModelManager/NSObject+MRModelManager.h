//
//  NSObject+MRModelManager.h
//  Json 转 model
//
//  Created by Mac on 2017/7/18.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MRModelManager)

/// 根据 array 获取 modelArray
+ (NSMutableArray *)mr_modelWithArray:(NSMutableArray *)array;

/// 根据 dic 获取 model
+ (instancetype)mr_modelWithDictionary:(NSDictionary *)dic;

/// 根据 字典或者数组 获取 modelArray 或者 model
+ (id)mr_modelWithObject:(id)object;

/// model 转数组
- (NSMutableArray *)mr_arrayKeyValues;

/// model 转字典
- (NSMutableDictionary *)mr_dicKeyValues;

/// model 转 数组或者字典
- (id)mr_keyValues;



@end
