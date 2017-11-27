//
//  MRCommonTime.m
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import "MRCommonTime.h"

@implementation MRCommonTime

//获取当前时间
//format: @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
+ (NSString *)currentDateWithFormat:(NSString *)format{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:format];

    return [dateFormatter stringFromDate:[NSDate date]];
}

/**
 获取格式化之后的时间
 @param format @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
 */
+ (NSString *)formatWith:(NSDate *)date andFormat:(NSString *)format{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];

    return [dateFormatter stringFromDate:date];
}

/**
 *  计算上次日期距离现在多久
 *  @param lastTime   上次日期(需要和格式对应)
 *  @param format1   上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2   最近日期格式
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime

                        lastTimeFormat:(NSString *)format1

                         ToCurrentTime:(NSString *)currentTime

                     currentTimeFormat:(NSString *)format2{

    //上次时间
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];

    dateFormatter1.dateFormat = format1;

    NSDate *lastDate = [dateFormatter1 dateFromString:lastTime];

    //当前时间
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];

    dateFormatter2.dateFormat = format2;

    NSDate *currentDate = [dateFormatter2 dateFromString:currentTime];

    return [MRCommonTime timeIntervalFromLastTime:lastDate ToCurrentTime:currentDate];
}

/**
 计算两段时间间隔多久
 返回 多少多少 分钟
 */
+ (NSInteger) calculateTimeFromLastTime:(NSString *)lastTime
                          lasTimeFormat:(NSString *)format1
                          toCurrentTime:(NSString *)currentTime
                      currentTimeFormat:(NSString *)format2{

    //上次时间
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];

    dateFormatter1.dateFormat = format1;

    NSDate *last = [dateFormatter1 dateFromString:lastTime];

    //当前时间
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];

    dateFormatter2.dateFormat = format2;

    NSDate *current = [dateFormatter2 dateFromString:currentTime];

    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];

    //上次时间
    NSDate *lastDate = [last dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:last]];

    //当前时间
    NSDate *currentDate = [current dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:current]];

    //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];

    return intevalTime;
}

+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime ToCurrentTime:(NSDate *)currentTime{

    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];

    //上次时间
    NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];

    //当前时间
    NSDate *currentDate = [currentTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:currentTime]];

    //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];

    //秒、分、小时、天、月、年
    NSInteger second = intevalTime;

    NSInteger minutes = intevalTime / 60;

    NSInteger hours = intevalTime / 60 / 60;

    NSInteger day = intevalTime / 60 / 60 / 24;

    NSInteger month = intevalTime / 60 / 60 / 24 / 30;

    NSInteger yers = intevalTime / 60 / 60 / 24 / 365;

    if(second < 60){
        return [NSString stringWithFormat:@"%ld秒前", (long)second];
    }

    if (minutes <= 10) {

//        return @"刚刚";
        return [NSString stringWithFormat: @"%ld分钟前",(long)minutes];

    }else if (minutes < 60){

        return [NSString stringWithFormat: @"%ld分钟前",(long)minutes];

    }else if (hours < 24){

        return [NSString stringWithFormat: @"%ld小时前",(long)hours];

    }else if (day < 30){

        return [NSString stringWithFormat: @"%ld天前",(long)day];

    }else if (month < 12){

        NSDateFormatter * df =[[NSDateFormatter alloc]init];

        df.dateFormat = @"M月d日";

        NSString * time = [df stringFromDate:lastDate];

        return time;

    }else if (yers >= 1){

        NSDateFormatter * df =[[NSDateFormatter alloc]init];

        df.dateFormat = @"yyyy年M月d日";

        NSString * time = [df stringFromDate:lastDate];

        return time;
    }
    return @"";
}

//根据日期算出周几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate{

    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:        NSCalendarIdentifierGregorian];

    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];

    [calendar setTimeZone: timeZone];

    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;

    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];

    return [weekdays objectAtIndex:theComponents.weekday];
}

+(NSString*)getChineseCalendarWithDate:(NSDate *)date{

    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅",	@"丁卯",	@"戊辰",	@"己巳",	@"庚午",	@"辛未",	@"壬申",	@"癸酉",
                             @"甲戌",	@"乙亥",	@"丙子",	@"丁丑", @"戊寅",	@"己卯",	@"庚辰",	@"辛己",	@"壬午",	@"癸未",
                             @"甲申",	@"乙酉",	@"丙戌",	@"丁亥",	@"戊子",	@"己丑",	@"庚寅",	@"辛卯",	@"壬辰",	@"癸巳",
                             @"甲午",	@"乙未",	@"丙申",	@"丁酉",	@"戊戌",	@"己亥",	@"庚子",	@"辛丑",	@"壬寅",	@"癸丑",
                             @"甲辰",	@"乙巳",	@"丙午",	@"丁未",	@"戊申",	@"己酉",	@"庚戌",	@"辛亥",	@"壬子",	@"癸丑",
                             @"甲寅",	@"乙卯",	@"丙辰",	@"丁巳",	@"戊午",	@"己未",	@"庚申",	@"辛酉",	@"壬戌",	@"癸亥", nil];

    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];


    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];


    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;

    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];

    //    NSLog(@"%ld你那%ld月%ld  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    if(date){

        NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
        NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
        NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];

        NSString *chineseCal_str =[NSString stringWithFormat: @"%@年%@月%@",y_str,m_str,d_str];
        return chineseCal_str;
    }
    return @"请重选一次";
}

/**
 7 根据时间戳获取时间
 @param timestamp 距 1970 年的时间戳
 @param type           format 格式
 */
+ (NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp andTimeType:(MRCommonTimeType)type{
    NSInteger second = timestamp.integerValue / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSString *format = nil;
    if(type == TimeTypeYearMonthDay)
        format = @"yyyy年MM月dd日 HH:mm";
    if(type == TimeTypeOnlyMonthDay)
        format = @"MM月dd日 HH:mm";
    if(type == TimeTypeOnlyDay)
        format = @"dd日 HH:mm";
    return [MRCommonTime formatWith:date andFormat:format];
}



@end
