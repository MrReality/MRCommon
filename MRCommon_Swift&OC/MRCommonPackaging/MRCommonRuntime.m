//
//  MRCommonRuntime.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRCommonRuntime.h"

@implementation MRCommonRuntime

/**
 获取类名
 @param class       相应类
 @return NSString： 类名
 */
+ (NSString *)getClassName:(Class)class{
    const char *className = class_getName(class);
    return [NSString stringWithUTF8String:className];
}

/**
 获取成员变量
 @param class   成员变量所在的类
 @return        返回成员变量字符串数组
 */
+ (NSArray *)getIvarList:(Class)class{
    
    unsigned int count = 0;
    
    // 获取所有成员变量名
    // 第一个参数 -> 相应类,  第二个参数是给一个 int 的地址
    Ivar *ivarList = class_copyIvarList(class, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++ ) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        // 获取成员变量名
        const char *ivarName = ivar_getName(ivarList[i]);
        // 变量类型
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        
        dic[@"type"] = [NSString stringWithUTF8String: ivarType];
        dic[@"ivarName"] = [NSString stringWithUTF8String: ivarName];
        
        [array addObject:dic];
    }
    // 需要释放, 因为是用 c 语言写的
    free(ivarList);
    return [NSArray arrayWithArray:array];
}

/**
 获取属性列表 (私有属性 + 在延展中定义的属性)
 @param class   相应类
 @return        属性列表数组
 */
+ (NSArray *)getPropertyList:(Class)class{
    
    // 和获取成员变量步骤一致
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(class, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++ ) {
        
        const char *propertyName = property_getName(propertyList[i]);
        [array addObject:[NSString stringWithUTF8String: propertyName]];
    }
    
    free(propertyList);
    return [NSArray arrayWithArray:array];
}

/**
 获取对象方法列表：getter, setter, 对象方法等。但不能获取类方法
 @param class   方法所在的类
 @return        该类的方法列表
 */
+ (NSArray *)getMethodList:(Class)class{

    unsigned int count = 0;
    Method *methodList = class_copyMethodList(class, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++ ) {
        
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        
        [array addObject:NSStringFromSelector(methodName)];
    }
    // 要 free
    free(methodList);
    return [NSArray arrayWithArray:array];
}

/**
 获取协议列表
 @param class   实现协议的类
 @return        返回该类实现的协议列表
 */
+ (NSArray *)getProtocolList:(Class)class{
    
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(class, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++ ) {
        
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        
        [array addObject:[NSString stringWithUTF8String: protocolName]];
    }
    
    free(protocolList);
    return [NSArray arrayWithArray:array];
    return nil;
}

/**
 添加新的方法
 @param class           被添加方法的类
 @param methodSel       SEL
 @param methodSelImp   提供 IMP 的 SEL
 */
+ (void)addMethodWithClass:(Class)class method:(SEL)methodSel method:(SEL)methodSelImp{
    
    Method method = class_getInstanceMethod(class, methodSelImp);
    
    IMP methodIMP = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod(class, methodSel, methodIMP, types);
}

/**
 方法交换
 @param class   交换方法所在的类
 @param method1 方法1
 @param method2 方法2
 */
+ (void)changeMethodWithClass:(Class)class firstMethod:(SEL)method1 secondMethod:(SEL)method2{
    
    Method firstMethod = class_getInstanceMethod(class, method1);
    Method secondMethod = class_getInstanceMethod(class, method2);
    method_exchangeImplementations(firstMethod, secondMethod);
}

@end
