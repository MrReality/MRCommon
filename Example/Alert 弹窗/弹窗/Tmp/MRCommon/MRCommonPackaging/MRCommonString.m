//
//  MRCommonString.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRCommonString.h"
#import <UIKit/UIKit.h>

@implementation MRCommonString

/**
 判断手机号是否正确
 @param mobileNum 电话号字符串
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    
    if (mobileNum.length != 11){
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";


    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 验证邮箱是否正确
+ (BOOL)isEmail:(NSString *)email{

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断字符串是否为空
+ (BOOL) isBlankString:(NSString *)string {

    if (string == nil || string == NULL) {

        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {

        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {

        return YES;
    }
    return NO;
}

//判断是否有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string{

    NSRange _range = [string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

//判断是否有中文
+ (BOOL)isHaveChineseInString:(NSString *)string{

    for(NSInteger i = 0; i < [string length]; i++){

        int a = [string characterAtIndex:i];

        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

// 判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)str1 inString:(NSString *)str2{

    NSRange range = [str2 rangeOfString:str1];
    if(range.location != NSNotFound){
        return YES;
    }
    return NO;
}

// 判断字符串是否为纯数字
+ (BOOL)isAllNumInString:(NSString *)str{

    for (NSInteger i = 0; i < str.length; i++) {
        if(!isdigit([str characterAtIndex:i])){
            return NO;
        }
    }
    return YES;
}

//获取本地版本号
+ (NSString *)getLocalAppVersion{

    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//获取BundleID
+ (NSString *)getBundleID{

    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

//获取app的名字
+ (NSString *)getAppName{

    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

//字典转json
+ (NSString *)dictionaryToJson:(NSDictionary *)dic{

    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// 生成 uuid
+ (NSString *)getUniqueStrByUUID{

    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID

    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);

    CFRelease(uuidObj);

    return uuidString;
}

//将字符串数组按照元素首字母顺序进行排序分组
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array{
    if (array.count == 0) {
        return nil;
    }
    for (id obj in array) {
        if (![obj isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:indexedCollation.sectionTitles.count];
    //创建27个分组数组
    for (int i = 0; i < indexedCollation.sectionTitles.count; i++) {
        NSMutableArray *obj = [NSMutableArray array];
        [objects addObject:obj];
    }
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:objects.count];
    //按字母顺序进行分组
    NSInteger lastIndex = -1;
    for (int i = 0; i < array.count; i++) {
        NSInteger index = [indexedCollation sectionForObject:array[i] collationStringSelector:@selector(uppercaseString)];
        [[objects objectAtIndex:index] addObject:array[i]];
        lastIndex = index;
    }
    //去掉空数组
    for (int i = 0; i < objects.count; i++) {
        NSMutableArray *obj = objects[i];
        if (obj.count == 0) {
            [objects removeObject:obj];
        }
    }
    //获取索引字母
    for (NSMutableArray *obj in objects) {
        NSString *str = obj[0];
        NSString *key = [self firstCharacterWithString:str];
        [keys addObject:key];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:objects forKey:keys];
    return dic;
}

//获取字符串(或汉字)首字母
+ (NSString *)firstCharacterWithString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    return [pingyin substringToIndex:1];
}

+ (CGSize)boundingRectWithText:(NSString *)text font:(NSInteger)font size:(CGSize)size{

    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};

    CGSize retSize = [text boundingRectWithSize:size
                                             options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil
                      ].size;

//    CGRect textRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    return retSize;
}

+ (NSRegularExpression *)regexAt{
    
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexTopic{
    
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexEmail{
    
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:
                 @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexUrl{
    
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSRegularExpression *)regexPhone{
    
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^[1-9][0-9]{4,11}$" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSMutableArray *)findAtRangeWithString:(NSString *)string{

    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *email = [[MRCommonString regexAt] matchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *result in email) {
        
        if (!(result.range.location == NSNotFound && result.range.length <= 1)){
            
            [array addObject:result];
        }
    }
    return array;
}

+ (NSMutableArray *)findTopicRangeWithString:(NSString *)string{

    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *email = [[MRCommonString regexTopic] matchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *result in email) {
        
        if (!(result.range.location == NSNotFound && result.range.length <= 1)){
            
            [array addObject:result];
        }
    }
    return array;
}

+ (NSMutableArray *)findURLRangeWithString:(NSString *)string{

    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *email = [[MRCommonString regexUrl] matchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *result in email) {
        
        if (!(result.range.location == NSNotFound && result.range.length <= 1)){
            
            [array addObject:result];
        }
    }
    return array;
}

+ (NSMutableArray *)findEmailRangeWithString:(NSString *)string{

    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *email = [[MRCommonString regexEmail] matchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *result in email) {
        
        if (!(result.range.location == NSNotFound && result.range.length <= 1)){
            
            [array addObject:result];
        }
    }
    return array;
}

+ (NSMutableArray *)findPhoneRangeWithString:(NSString *)string{

    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *email = [[MRCommonString regexPhone] matchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *result in email) {
        
        if (!(result.range.location == NSNotFound && result.range.length <= 1)){
            
            [array addObject:result];
        }
    }
    return array;
}


@end
