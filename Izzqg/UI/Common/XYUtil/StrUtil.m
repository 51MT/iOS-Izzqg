//
//  StrUtil.m
//  Ixyb
//
//  Created by wangjianimac on 16/9/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "StrUtil.h"

@implementation StrUtil

+ (NSString *)localizedStringWithKey:(NSString *)key andComment:(NSString *)comment {

    // TODO: debug
    //return comment;

    NSString *localizedStr = NSLocalizedString(key, comment); //获取iOS操作系统本地String

    if ([localizedStr isEqualToString:key]) {
        localizedStr = comment;
    }

    if (localizedStr == nil) {
        localizedStr = @"";
    }

    return localizedStr;
}

+ (BOOL)isEmptyString:(NSString *)str {
    if (str == nil || str.length <= 0 || [str isEqualToString:@"null"] || [str isEqual:[NSNull null]] || [str isEqualToString:@"(null)"]) {
        return YES;
    }
    NSString *phoneRegex = @"[\\s]+";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:str];
}

+ (BOOL)isPureInt:(NSString *)str {
    NSScanner *scan = [NSScanner scannerWithString:str];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//去掉字符串中 "<"、">"、" "
+ (NSString *)stringByReplacingOccurrencesOfString:(NSString *)str {

    return [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
        stringByReplacingOccurrencesOfString:@">"
                                  withString:@""]
        stringByReplacingOccurrencesOfString:@" "
                                  withString:@""];
}




@end
