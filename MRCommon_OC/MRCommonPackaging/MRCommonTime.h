//
//  MRCommonTime.h
//  test
//
//  Created by 刘入徵 on 2017/4/15.
//  Copyright © 2017年 Mix_Reality. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MRCommonTimeType) {
    TimeTypeYearMonthDay = 0,        /// 年月日
    TimeTypeOnlyMonthDay,              /// 年月
    TimeTypeOnlyDay                        /// 日
};

/// MARK: 处理时间相关的类
@interface MRCommonTime : NSObject


/**
 1 获取当前时间 Gets the current time
 @param format @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
 */
+ (NSString *)currentDateWithFormat:(NSString *)format;

/**
 2 获取格式化之后的时间 For the time after the formatting
 @param format @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
 */
+ (NSString *)formatWith:(NSDate *)date andFormat:(NSString *)format;

/**
 3 计算上次日期距离现在多久   How long distance now calculate last date
 返回的是 多少多少分钟以前
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     currentTimeFormat:(NSString *)format2;

/**
 4 计算两段时间间隔多久 How long is the interval computation time
 返回 多少多少 秒
 */
+ (NSInteger)calculateTimeFromLastTime:(NSString *)lastTime
                          lasTimeFormat:(NSString *)format1
                          toCurrentTime:(NSString *)currentTime
                      currentTimeFormat:(NSString *)format2;

/**
 5 根据日期算出周几   According to the date to calculate several weeks
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

/**
 6 根据 date 获取 农历      According to the date for the lunar calendar
 */
+(NSString*)getChineseCalendarWithDate:(NSDate *)date;


/**
 7 根据时间戳获取时间
 @param timestamp 距 1970 年的时间戳
 @param type           format 格式
 */
+ (NSString *)getTimeToShowWithTimestamp:(NSString *)timestamp andTimeType:(MRCommonTimeType)type;
@end
