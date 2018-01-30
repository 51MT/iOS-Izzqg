//
//  DateUtil.m
//  Ixyb
//
//  Created by wangjianimac on 15/12/17.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "DateTimeUtil.h"

#import "StrUtil.h"

@implementation DateTimeUtil

+ (NSString *)stringFromDate:(NSDate *)date { //NSDate转NSString 年月日
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)stringFromDate:(NSDate *)date fmt:(NSString *)fmt {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fmt];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)dateFromString:(NSString *)dateString { //NSString转NSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)dataStringFromString:(NSString *)dateStringOne { //NSString转NSString
    NSDate *date = [DateTimeUtil dateFromString:dateStringOne];
    NSString *dateStringTwo = [DateTimeUtil stringFromDate:date];
    return dateStringTwo;
}

+ (NSString *)stringLineFromDate:(NSDate *)date { //NSDate转NSString ---
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getCurrentTime {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a]; //转为字符型
    return timeString;
}

+ (BOOL)compareCurrentTime:(NSDate *)compareDate {
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    if ((temp = timeInterval / 60) < 1) {
        return NO;

    } else {
        return YES;
    }
}

+ (NSString *)formatDuring:(long long int)mss {

    long long int days = mss / (1000 * 60 * 60 * 24);
    long long int hours = (mss % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
    long long int minutes = (mss % (1000 * 60 * 60)) / (1000 * 60);
    long long int seconds = (mss % (1000 * 60)) / 1000;
    return [NSString stringWithFormat:XYBString(@"string_some_days", @"%lld天%lld:%lld:%lld"), days, hours, minutes, seconds];
}

+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1;
    } else if (result == NSOrderedAscending) {
        return -1;
    }
    return 0;
}

@end
