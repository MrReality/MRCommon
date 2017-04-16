//
//  MRCommonString.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MRCommonString : NSObject

/**
 判断手机号是否正确              Judge a phone number is correct
 @param mobileNum 电话号字符串
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 验证邮箱是否正确               Verification email is correct
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 判断字符串是否为空              To determine whether a string is empty
 */
+(BOOL) isBlankString:(NSString *)string;

/**
 判断字符串是否有空格             To determine whether a string is whitespace
 */
+ (BOOL)isHaveSpaceInString:(NSString *)string;

/**
 判断字符串是否有中文             To determine whether a string is Chinese
 */
+ (BOOL)isHaveChineseInString:(NSString *)string;

/**
 判断字符串中是否含有某个字符串    Determine whether a string containing a string
 */
+ (BOOL)isHaveString:(NSString *)str1 inString:(NSString *)str2;

/**
 判断字符串是否为纯数字           To determine whether a string is pure Numbers
 */
+ (BOOL)isAllNumInString:(NSString *)str;

/**
 获取本地版本号                 Access to the local version number
 */
+ (NSString *) getLocalAppVersion;

/**
 获取 BundleID                Get BundleID
 */
+ (NSString *) getBundleID;

/**
 获取 app 的名字                Get the name of the app
 */
+ (NSString *) getAppName;

/**
 字典转 json                   Turn a json dictionary
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

/**
 生成 guid  现在苹果已经禁止访问 uuid   Generated guid
 */
+ (NSString *)getUniqueStrByUUID;

/**
 将字符串数组按照元素首字母顺序进行排序分组          
 The string array sorted in alphabetical order according to the elements in the first group
 返回的字典 key 为 首字母   value 为字符串数组
 Return a dictionary key value as a string array as the first letter
 @param array 字符串数组 An array of strings
 */
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array;


/**
 获取字符串(或汉字)首字母  String (or characters) initials
 */
+ (NSString *)firstCharacterWithString:(NSString *)string;


/**
 获取字符串的 size    Get the size of the string
 @param text 文本
 @param size 例如 example CGSizeMake(320, 0)
 */
+ (CGSize)boundingRectWithText:(NSString *)text font:(NSInteger)font size:(CGSize)size;


@end
