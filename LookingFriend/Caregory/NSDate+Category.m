
//
//  NSDate+ITTAdditions.m
//
//  Created by guo hua on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

+ (NSString *)timeStringWithInterval:(NSTimeInterval)time {
    int distance = @([[NSDate date] timeIntervalSince1970] - time).intValue;
    NSString *string;
    if (distance < 60) {//avoid 0 seconds
        string = @"刚刚";
    }
//    else if (distance < 60) {
//        string = [NSString stringWithFormat:@"%d秒前", (distance)];
//    }
    else if (distance < 3600) {//60 * 60
        distance = distance / 60;
        string = [NSString stringWithFormat:@"%d分钟前", (distance)];
    } else if (distance < 86400) {//60 * 60 * 24
        distance = distance / 3600;
        string = [NSString stringWithFormat:@"%d小时前", (distance)];
    } else if (distance < 604800) {//60 * 60 * 24 * 7
        distance = distance / 86400;
        string = [NSString stringWithFormat:@"%d天前", (distance)];
    } else if (distance < 2419200) {//60 * 60 * 24 * 7 * 4
        distance = distance / 604800;
        string = [NSString stringWithFormat:@"%d周前", (distance)];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    }
    return string;
}

- (NSString *)stringWithSeperator:(NSString *)seperator {
    return [self stringWithSeperator:seperator includeYear:YES];
}

// Return the formated string by a given date and seperator.
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:str];
    return date;
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *string = [formatter stringFromDate:self];
    return string;
}

// Return the formated string by a given date and seperator, and specify whether want to include year.
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear {
    if (seperator == nil) {
        seperator = @"-";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (includeYear) {
        [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd", seperator, seperator]];
    } else {
        [formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd", seperator]];
    }
    NSString *dateStr = [formatter stringFromDate:self];

    return dateStr;
}

- (NSString *)weekday {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *weekdayStr = nil;
    [formatter setDateFormat:@"c"];
    NSInteger weekday = [[formatter stringFromDate:self] integerValue];
    if (weekday == 1) {
        weekdayStr = @"周日";
    } else if (weekday == 2) {
        weekdayStr = @"周一";
    } else if (weekday == 3) {
        weekdayStr = @"周二";
    } else if (weekday == 4) {
        weekdayStr = @"周三";
    } else if (weekday == 5) {
        weekdayStr = @"周四";
    } else if (weekday == 6) {
        weekdayStr = @"周五";
    } else if (weekday == 7) {
        weekdayStr = @"周六";
    }
    return weekdayStr;
}

- (NSInteger)weekNum {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"c"];
    NSInteger weekday = [[formatter stringFromDate:self] integerValue];
    return weekday == 0 ? 7 : weekday - 1;
}

+ (NSTimeInterval)nowTimeInterval {
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeInterval = [self getDateTimeTOMilliSeconds:nowDate];

    return timeInterval;
}

+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime {
    NSTimeInterval interval = [datetime timeIntervalSince1970];
//    IKLog(@"interval=%f",interval);
    long long totalMilliseconds = interval * 1000;
//    IKLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}

+ (NSTimeInterval)timeIntervalFromTimeStringFormat:(NSString *)format with:(NSString *)timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSDate *date = [dateFormatter dateFromString:timeString];
    NSTimeInterval time = [date timeIntervalSince1970];
    return time;
}

/**
 *  是否为上午
 */
- (BOOL)isAM {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour;
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return selfCmps.hour <= 12;
}

/**
 *  是否为今天
 */
- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;

    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];

    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
        (selfCmps.year == nowCmps.year) &&
        (selfCmps.month == nowCmps.month) &&
        (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday {
    NSDate *nowDate = [[NSDate date] dateWithYMD];

    NSDate *selfDate = [self dateWithYMD];

    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;

    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];

    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];

    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

+ (long)compareDate1:(NSDate *)date1 withDate2:(NSDate *)date2 type:(int)type {
    NSTimeInterval timeInterval = [date1 timeIntervalSinceDate:date2];
    timeInterval = -timeInterval;
    long result;
    switch (type) {
        case 1:
            result = (long)timeInterval;     //秒
            break;
        case 2:
            result = (long)timeInterval / 60;     //分
            break;
        case 3:
            result = (long)timeInterval / 60 / 60;     //时
            break;
        case 4:
            result = (long)timeInterval / 60 / 60 / 24;     //天
            break;
        case 5:
            result = (long)timeInterval / 60 / 60 / 24 / 30;     //月
            break;
        case 6:
            result = (long)timeInterval / 60 / 60 / 24 / 365;     //年
            break;
        default:
            result = 0;
            break;
    }
    return result;
}

/**

 *  获取网络当前时间

 */
+ (NSDate *)getInternetTime {
    NSString *urlString = @"http://m.baidu.com";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:urlString] invertedSet];//非URLstr字符集
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];   //对非URLstr字符集编码
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // 实例化NSMutableURLRequest，并进行参数配置
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSError *error = nil;
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // 处理返回的数据
    //    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if (error) {
        return [NSDate date];
    }
    NSLog(@"response is %@", response);
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length] - 4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60 * 60 * 8];
    return netDate;
}

/* 比较两个时间之间差距的绝对值 */
- (NSTimeInterval)absIntervalSinceDate:(NSDate *)date {
    return fabs([self timeIntervalSinceDate:date]);
}

/* 比较两个时间之间差距 */
- (NSTimeInterval)IntervalSinceDate:(NSDate *)date {
    return [self timeIntervalSinceDate:date];
}

+ (int)compareOneDay:(NSString *)oneDay anotherDay:(NSString *)anotherDay formatter:(NSDateFormatter *)formatter {
    NSDate *dateA = [formatter dateFromString:oneDay];

    NSDate *dateB = [formatter dateFromString:anotherDay];

    NSComparisonResult result = [dateA compare:dateB];

    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间晚");
        return 1;
    } else if (result == NSOrderedAscending) {
        //NSLog(@"oneDay比 anotherDay时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
}

/* 当前时间对象和现在时间差的绝对值 */
- (NSTimeInterval)absIntervalSinceNow {
    return fabs([self timeIntervalSinceNow]);
}

/* 根据时间戳计算天、小时、时、分 */
+ (NSString *)getTimeByInterval:(NSTimeInterval)intervals {
    NSString *timeDes = @"";
    int day = intervals / ONE_DAY;

    int offset = (int)intervals % ONE_DAY;
    int hour = offset / ONE_HOUR;

    offset = offset % ONE_HOUR;
    int minute = offset / ONE_MINUTE;
    int sec = offset % ONE_MINUTE;

    if (day > 0) {
        return [NSString stringWithFormat:@"%d天%d小时%d分%d秒", day, hour, minute, sec];
    }

    if (hour > 0) {
        return [NSString stringWithFormat:@"%d小时%d分%d秒", hour, minute, sec];
    }

    if (minute > 0) {
        return [NSString stringWithFormat:@"%d分%d秒", minute, sec];
    }

    if (sec > 0) {
        return [NSString stringWithFormat:@"%d秒", sec];
    }
    return timeDes;
}

- (NSDate *)updateDateWithhour:(int)h minute:(int)m second:(int)sec {
    // Get the year, month, day from the date
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];

    // Set the hour, minute, second to be zero
    components.hour = h;
    components.minute = m;
    components.second = sec;

    // Create the date
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)updateDateWithDay:(int)day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];

    // Set the hour, minute, second to be zero
    components.day = day;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    // Create the date

    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/*修改月份，对当前月份增加或者减少*/
- (NSDate *)moveMonth:(int)value {
    NSDateComponents *components = [self components];
    NSInteger month = components.month + value;
    if (month > 12) {
        month = 1;
        components.year += 1;
    } else if (month < 1) {
        month = 12;
        components.year -= 1;
    }
    components.month = month;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/*修改年份，对当前年增加或者减少*/
- (NSDate *)moveYear:(int)value {
    NSDateComponents *components = [self components];
    components.year += value;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSString *)gmtDateTimeString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [format stringFromDate:self];
}

- (NSString *)dateTimeString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [format stringFromDate:self];
}

- (NSString *)dateTimeSimpleString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [format stringFromDate:self];
}

- (NSString *)MMSTimeString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm:ss"];
    return [format stringFromDate:self];
}

- (NSString *)dateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:self];
}

- (NSString *)chineseDateString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    return [format stringFromDate:self];
}

- (NSString *)chineseYearMonthDateString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月"];
    return [format stringFromDate:self];
}

- (NSString *)gmtDateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:self];
}

- (NSString *)timeString {
    NSDateComponents *components = [self components];
    int hour = (int)[components hour];
    int minute = (int)[components minute];
    return [NSString stringWithFormat:@"%02d:%02d", hour, minute];
}

- (NSString *)monthDayString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM-dd"];
    return [format stringFromDate:self];
}

- (NSString *)yearMonthString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    return [format stringFromDate:self];
}

- (NSInteger)dayOfYear {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"D"];
    return [[format stringFromDate:self] integerValue];
}

- (NSInteger)dayTime {
    NSDateComponents *comp = [self components];
    return comp.hour * 3600 + comp.minute * 60 + comp.second;
}

- (NSDateComponents *)components {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
}

+ (NSDate *)dateFromDateNumString:(NSString *)timeString {
    return [self dateString:timeString formatString:@"yyyyMMddHHmmss"];
}

+ (NSString *)stringFromDateNumString:(NSDate *)timeDate {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformatter stringFromDate:timeDate];
}

+ (NSDate *)dateFromDateTimeString:(NSString *)timeString
{
    return [self dateString:timeString formatString:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)dateFromChineseString:(NSString *)dateString
{
    return [self dateString:dateString formatString:@"yyyy年MM月dd日"];
}

+ (NSDate *)dateFromChineseStringMonth:(NSString *)dateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月"];

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[format dateFromString:dateString]];
    NSDate *localeDate = [[format dateFromString:dateString] dateByAddingTimeInterval:interval];

    return localeDate;
}

/**
 *  日期字符串转换为 NSDate
 *
 *     输入的日期字符串形如：@"2010-05-21"
 */
+ (NSDate *)dateFromDateString:(NSString *)dateStr {
    return [self dateString:dateStr formatString:@"yyyy-MM-dd"];
}

/** 日期字符串‘formate' 转换为 NSDate */
+ (NSDate *)dateString:(NSString *)dateString formatString:(NSString *)formateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formateString];
    NSDate *retDate = [formatter dateFromString:dateString];

    return retDate;
}

+ (NSDate *)secondToDay:(unsigned int)second {
    return [[NSDate alloc] initWithTimeIntervalSince1970:second];
}

+ (NSString *)getTimeStamp {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)[dat timeIntervalSince1970]];

    return timeString;
}

//转化为本地时区日期
+ (NSDate *)dateToLocalDateFromDate:(NSDate *)fromDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:fromDate];
    NSDate *localeDate = [fromDate dateByAddingTimeInterval:interval];
    return localeDate;
}

+ (NSDate *)dateWithComponents:(NSDateComponents *)components {
    NSDate *date = nil;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    date = [gregorian dateFromComponents:components];
    return date;
}

static const NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;

+ (NSDate *)setYear:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    [components setYear:year];
    [components setMonth:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    [components setYear:year];
    [components setMonth:month];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

+ (NSDate *)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

+ (NSDate *)setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

+ (NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    [components setHour:hour];
    [components setMinute:minute];
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

+ (NSDate *)setHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

- (NSInteger)howManyDaysWithMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSInteger day = range.length;
    return day;
}

+ (NSDate *)getCurrentDate:(NSDate *)date {
    //设置时间输出格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    return [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
}

+ (NSString *)getCurrentDateStr:(NSString *)dateStr {
    //设置时间输出格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [dateFormatter dateFromString:dateStr];

    return [[NSString alloc] initWithFormat:@"%.0f", [date timeIntervalSince1970]];
}

+ (NSDate *)getCurrentDateTime:(NSString *)date {
    //设置时间输出格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    return [dateFormatter dateFromString:date];
}

//秒转小时分
+ (NSString *)getMMSSFromSS:(NSString *)totalTime {
    NSInteger seconds = [totalTime integerValue];

    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", seconds / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (seconds % 3600) / 60];
    //format of second
    //NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time;
    if ([str_hour isEqualToString:@"00"]) {
        if ([str_minute isEqualToString:@"00"]) {
            format_time = [NSString stringWithFormat:@"剩余0分钟"];
        } else {
            format_time = [NSString stringWithFormat:@"剩余%@分钟", str_minute];
        }
    } else {
        format_time = [NSString stringWithFormat:@"剩余%@小时%@分钟", str_hour, str_minute];
    }
    return format_time;
}

//秒转小时分
+ (NSString *)getMMSSFromSSS:(NSInteger)totalTime {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", totalTime / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (totalTime % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", totalTime % 60];

    return [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
}

//获取当前时间戳字符串 10位
+ (NSString *)getTimestampSince1970
{
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeInterval interval = [datenow timeIntervalSince1970];//13位的*1000
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", interval];
    return timeSp;
}

+ (NSString *)getTimeStampWithDate:(NSDate *)date {

    NSTimeInterval interval = [date timeIntervalSince1970];
    //将时间转换为字符串
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", interval];

    return timeSp;
}

@end
