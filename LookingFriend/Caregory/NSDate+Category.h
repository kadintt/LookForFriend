//
//  NSDate+ITTAdditions.h
//
//  Created by guo hua on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define ONE_MINUTE 60
#define ONE_HOUR  (60*ONE_MINUTE)
#define ONE_DAY   (24*ONE_HOUR)

@interface NSDate (Category)

+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;

+ (NSString *)timeStringWithInterval:(NSTimeInterval)time;

- (NSString *)stringWithSeperator:(NSString *)seperator;

- (NSString *)stringWithFormat:(NSString *)format;

- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear;

- (NSString *)weekday;

- (NSInteger)weekNum;

+ (NSTimeInterval)nowTimeInterval;

+ (NSTimeInterval)timeIntervalFromTimeStringFormat:(NSString *)format with:(NSString *)timeString;

/**
 *  是否为上午
 */
- (BOOL)isAM;

/**
 *  是否为今天
 */
- (BOOL)isToday;

/**
 *  是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

/**
 *  获得两个时间的差距
 */
+ (long)compareDate1:(NSDate *)date1 withDate2:(NSDate *)date2 type:(int)type;

/** 获取网络时间 */
+ (NSDate*)getInternetTime;

/** 时间字符串 ‘yyyyMMddHHmmss’ 转换为 NSDate */
+ (NSDate*)dateFromDateNumString:(NSString*)timeString;

/** 时间字符串 ‘yyyy-MM-dd HH:mm:ss’ 转换为 NSDate */
+ (NSDate*)dateFromDateTimeString:(NSString*)timeString;

/** 时间字符串 ‘yyyy年MM月dd日’ 转换为 NSDate */
+ (NSDate*)dateFromChineseString:(NSString*)dateString;

/** 日期字符串‘yyyy-MM-dd' 转换为 NSDate */
+ (NSDate *)dateFromDateString:(NSString *)dateStr;

/** 日期字符串‘yyyy-MM' 转换为 NSDate */
+ (NSDate*)dateFromChineseStringMonth:(NSString*)dateString;

/** 日期字符串‘formate' 转换为 NSDate */
+ (NSDate*)dateString:(NSString*)dateString formatString:(NSString*)formateString;


/** 修改日期，创建新时间*/
- (NSDate*)updateDateWithhour:(int)h minute:(int)m second:(int)sec;

/** 修改日期，创建新时间*/
- (NSDate*)updateDateWithDay:(int)day;

/** 修改月份，对当前月份增加或者减少*/
- (NSDate*)moveMonth:(int)value;

/** 修改年份，对当前年增加或者减少*/
- (NSDate*)moveYear:(int)value;

/** 当前NSDate转为GMT 时间的字符串 */
- (NSString*)gmtDateTimeString;

/** 当前NSDate转为GMT 日期的字符串 */
- (NSString*)gmtDateString;

/** 当前NSDate转为‘yyyy-MM-dd HH:mm:ss’ 时间的字符串 */
- (NSString*)dateTimeString;

/** 当前NSDate转为‘yyyy-MM-dd HH:mm’ 时间的字符串 */
- (NSString*)dateTimeSimpleString;

/** 当前NSDate转为‘HH:mm:ss’ 时间的字符串 */
- (NSString*)MMSTimeString;

/** 当前NSDate转为‘yyyy-MM-dd'字符串 */
- (NSString *)dateString;

/** 当前NSDate转为‘yyyy年MM月dd日'字符串*/
- (NSString *)chineseDateString;

/** 当前NSDate转为‘yyyy年MM月'字符串*/
- (NSString *)chineseYearMonthDateString;

/** 当前NSDate转为‘MM-dd'字符串 */
- (NSString*)monthDayString;

/** 当前NSDate转为‘yyyy-MM'字符串 */
- (NSString*)yearMonthString;

/** 当前NSDate转为‘hh-mm'字符串 */
- (NSString*)timeString;

/** 一年中的第几天 */
- (NSInteger)dayOfYear;

/** 一天从0点开始的时间，单位 秒 */
- (NSInteger)dayTime;

- (NSDateComponents*)components;

/** 比较两个时间之间差距的绝对值 */
- (NSTimeInterval)absIntervalSinceDate:(NSDate *)date;

/** 比较两个日期大小 */
+(int)compareOneDay:(NSString *)oneDay anotherDay:(NSString *)anotherDay formatter:(NSDateFormatter *)formatter;

/** 当前时间对象和现在时间差的绝对值 */
- (NSTimeInterval)absIntervalSinceNow;

/** 当前时间对象和现在时间差 */
- (NSTimeInterval)IntervalSinceDate:(NSDate *)date;

/** 根据时间戳计算天、小时、时、分 */
+ (NSString *)getTimeByInterval:(NSTimeInterval)intervals;

/** 获取当前时间戳*/
+ (NSString *)getTimeStamp;

//转化任意日期到当前时区
+(NSDate *)dateToLocalDateFromDate: (NSDate *)forDate;

+(NSString *)stringFromDateNumString:(NSDate *)timeDate;

+ (NSDate*)dateWithComponents:(NSDateComponents*)components;

+ (NSDate *)setYear:(NSInteger)year;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
- (NSInteger)howManyDaysWithMonth;

/// 获取对应日期格式化后的日期
+ (NSDate *)getCurrentDate:(NSDate *)date;

/// 获取对应日期的时间戳
+ (NSString *)getCurrentDateStr:(NSString *)dateStr;

/// 获取对应日期的时间
+ (NSDate *)getCurrentDateTime:(NSString *)date;

/// 秒转小时分
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;

/// 秒 转 时分秒
+ (NSString *)getMMSSFromSSS:(NSInteger )totalTime;


//获取当前时间戳字符串 10位
+ (NSString *)getTimestampSince1970;

+ (NSString *)getTimeStampWithDate:(NSDate *)date;

@end

