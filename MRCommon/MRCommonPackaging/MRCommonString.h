//
//  MRCommonString.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// MARK: 处理字符串的类
@interface MRCommonString : NSObject

/**
 1 判断手机号是否正确              Judge a phone number is correct
 @param mobileNum 电话号字符串
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 2 验证邮箱是否正确               Verification email is correct
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 3 判断字符串是否为空              To determine whether a string is empty
 */
+(BOOL) isBlankString:(NSString *)string;

/**
 4 判断字符串是否有空格             To determine whether a string is whitespace
 */
+ (BOOL)isHaveSpaceInString:(NSString *)string;

/**
 5 判断字符串是否有中文             To determine whether a string is Chinese
 */
+ (BOOL)isHaveChineseInString:(NSString *)string;

/**
 6 判断字符串中是否含有某个字符串    Determine whether a string containing a string
 */
+ (BOOL)isHaveString:(NSString *)str1 inString:(NSString *)str2;

/**
 7 判断字符串是否为纯数字           To determine whether a string is pure Numbers
 */
+ (BOOL)isAllNumInString:(NSString *)str;

/**
 8 获取本地版本号                 Access to the local version number
 */
+ (NSString *) getLocalAppVersion;

/**
 9 获取 BundleID                Get BundleID
 */
+ (NSString *) getBundleID;

/**
 10 获取 app 的名字                Get the name of the app
 */
+ (NSString *) getAppName;

/**
 11 字典转 json                   Turn a json dictionary
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

/**
 12 生成 guid  现在苹果已经禁止访问 uuid   Generated guid
 */
+ (NSString *)getUniqueStrByUUID;

/**
 13 将字符串数组按照元素首字母顺序进行排序分组
 The string array sorted in alphabetical order according to the elements in the first group
 返回的字典 key 为 首字母   value 为字符串数组
 Return a dictionary key value as a string array as the first letter
 @param array 字符串数组 An array of strings
 */
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array;


/**
 14 获取字符串(或汉字)首字母  String (or characters) initials
 */
+ (NSString *)firstCharacterWithString:(NSString *)string;


/**
 15 获取字符串的 size    Get the size of the string
 @param text 文本
 @param size 例如 example CGSizeMake(320, 0)
 */
+ (CGSize)boundingRectWithText:(NSString *)text font:(NSInteger)font size:(CGSize)size;

/// MARK: ------ 正则 ------
/// 16 @用户
+ (NSRegularExpression *)regexAt;

/// 17 #话题#
+ (NSRegularExpression *)regexTopic;

/// 18 email
+ (NSRegularExpression *)regexEmail;

/// 19 url
+ (NSRegularExpression *)regexUrl;

/// 20 电话号
+ (NSRegularExpression *)regexPhone;

/// 获取字符串中 @用户 的 NSTextCheckingResult 数组, result.range 就是 @用户 的range
+ (NSMutableArray *)findAtRangeWithString:(NSString *)string;

/// 获取字符串中 topic 的 NSTextCheckingResult 数组, result.range 就是 topic 的range
+ (NSMutableArray *)findTopicRangeWithString:(NSString *)string;

/// 获取字符串中 url 的 NSTextCheckingResult 数组, result.range 就是 rul 的range
+ (NSMutableArray *)findURLRangeWithString:(NSString *)string;

/// 获取字符串中 email 的 NSTextCheckingResult 数组, result.range 就是 email 的range
+ (NSMutableArray *)findEmailRangeWithString:(NSString *)string;

/// 获取字符串中 phone 的 NSTextCheckingResult 数组, result.range 就是 phone 的range
+ (NSMutableArray *)findPhoneRangeWithString:(NSString *)string;

/// 21 过滤中文
+ (NSString *)filterChineseWithString:(NSString *)string;

/// 22 过滤特殊字符
+ (NSString *)filterCharacterWithString:(NSString *)string;

/// 23 过滤最右边的空格
+ (NSString *)filterRightSpaceWithString:(NSString *)string;

/// 24 过滤最右边的 0
+ (NSString *)filterRightZeroWithString:(NSString *)string;

/// 25 只能输入数字和小数点
+ (NSString *)filterOnlyCanInputNumWithString:(NSString *)string;

/// 26 清除多余的小数点, 和小数点后面的 0
+ (NSString *)cleanZeroWithString:(NSString *)string isCleanZero:(BOOL)isCleanZero;

/// 27 只能输入数字
+ (NSString *)onlyNumWithString:(NSString *)string;
@end
