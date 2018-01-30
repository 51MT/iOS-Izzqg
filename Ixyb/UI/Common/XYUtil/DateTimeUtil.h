//
//  DateUtil.h
//  Ixyb
//
//  Created by wangjianimac on 15/12/17.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeUtil : NSObject

+ (NSString *)stringFromDate:(NSDate *)date;                  //NSDate转NSString 年月日
+ (NSDate *)dateFromString:(NSString *)dateString;            //NSString转NSDate
+ (NSString *)dataStringFromString:(NSString *)dateStringOne; //NSString转NSString
+ (NSString *)stringLineFromDate:(NSDate *)date;              //NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date fmt:(NSString *)fmt;

/**
 *  @author wangjian, 16-11-23 11:11:36
 *
 *  @brief 获取当前时间戳
 *
 *  @return
 */
+ (NSString *)getCurrentTime;

/**
 *  @author wangjian, 16-11-23 11:11:26
 *
 *  @brief 计算指定时间与当前的时间差
 *
 *  @param compareDate 某一指定时间
 *
 *  @return
 */
+ (BOOL)compareCurrentTime:(NSDate *)compareDate;

/**
 *  @author wangjian, 16-11-23 11:11:15
 *
 *  @brief 毫秒数转换为*天*小时*分*秒
 *
 *  @param mss 毫秒数
 *
 *  @return 
 */
+ (NSString *)formatDuring:(long long int)mss;

/**
 *  @author wangjian, 16-11-23 11:11:52
 *
 *  @brief 比较日期
 *
 *  @param oneDay
 *  @param anotherDay
 *
 *  @return
 */
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

@end
