//
//  StrUtil.h
//  Ixyb
//
//  Created by wangjianimac on 16/9/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XYBString(key, comment) [StrUtil localizedStringWithKey:key andComment:comment]

@interface StrUtil : NSObject

/**
 *  @brief 根据key读取本地化NSLocalizedString（Localizable.strings）的字符串
 *
 *  @param key     key description
 *  @param comment key的注释
 *
 *  @return 字符串
 */
+ (NSString *)localizedStringWithKey:(NSString *)key andComment:(NSString *)comment;

/**
 *  @brief 是否空白字符串
 *
 *  @param str 字符串
 *
 *  @return 是否为空
 */
+ (BOOL)isEmptyString:(NSString *)str;

/**
 *  @brief 判断是否为整形
 *
 *  @param str 字符串
 *
 *  @return 是否为整形
 */
+ (BOOL)isPureInt:(NSString *)str;


/**
 *  @brief 去掉字符串中 "<"、">"、" "
 *
 *  @param str 字符串
 *
 *  @return 新字符串
 */
+ (NSString *)stringByReplacingOccurrencesOfString:(NSString *)str;

@end
