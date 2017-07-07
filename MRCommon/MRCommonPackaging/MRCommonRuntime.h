//
//  MRCommonRuntime.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface MRCommonRuntime : NSObject

/**
 1 获取类名                   Get the name of the class
 @param class       相应类  The corresponding class
 @return NSString： 类名    The name of the class
 */
+ (NSString *)getClassName:(Class)class;

/**
 2 获取成员变量                          Access to the member variable
 @param class   成员变量所在的类        Member variables in the class
 @return        返回成员变量字符串数组   Returns a string array member variables
 */
+ (NSArray *)getIvarList:(Class)class;

/**
 3 获取属性列表 (私有属性 + 在延展中定义的属性) Gets an attribute list (private + defined in extended attribute)
 @param class   相应类                  The corresponding class
 @return        属性列表数组              Property list array
 */
+ (NSArray *)getPropertyList:(Class)class;

/**
 4 获取对象方法列表：getter, setter, 对象方法等。但不能获取类方法  To obtain a list object method: getters, setters, object methods, etc.But it can't get class methods
 @param class   方法所在的类                               Methods in the class
 @return        该类的方法列表                             The list of the methods
 */
+ (NSArray *)getMethodList:(Class)class;

/**
 5 获取协议列表                             To obtain a list agreement
 @param class   实现协议的类              To implement the class of the agreement
 @return        返回该类实现的协议列表      Returns the class list of protocol implementation
 */
+ (NSArray *)getProtocolList:(Class)class;

/**
 6 添加新的方法                                  Add a new method in runtime
 @param class           被添加方法的类         By adding methods of classes
 @param methodSel       SEL
 @param methodSelImp    提供 IMP 的 SEL       Provide IMP SEL
 */
+ (void)addMethodWithClass:(Class)class method:(SEL)methodSel method:(SEL)methodSelImp;

/**
 7 方法交换                           Methods exchange
 @param class   交换方法所在的类      Exchange method in the class
 @param method1 方法1
 @param method2 方法2
 */
+ (void)changeMethodWithClass:(Class)class firstMethod:(SEL)method1 secondMethod:(SEL)method2;

@end
