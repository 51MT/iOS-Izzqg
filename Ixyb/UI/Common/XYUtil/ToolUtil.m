//
//  ToolUtil.m
//  Ixyb
//
//  Created by wangjianimac on 16/9/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "ToolUtil.h"

@implementation ToolUtil

+ (NSString *)getUUID {

    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *) CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);

    return result;
}

+ (NSString *)getDeviceToken {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [NSString stringWithFormat:@""];
    if ([userDefaults objectForKey:@"deviceToken"]) {
        deviceToken = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"deviceToken"]];
    }
    return deviceToken;
}

//获取APP版本号
+ (NSString *)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; //appVersion
}

+ (CGSize)getLabelSizeWithLabelStr:(NSString *)labelStr andLabelFont:(UIFont *)labelFont {

    //高度估计文本大概要显示几行，宽度根据需求自己定义。 label可设置的最大高度和宽度 MAXFLOAT 可以算出具体要多高
    CGSize size = CGSizeMake(MainScreenWidth - 2 * Margin_Length, MAXFLOAT);

    //获取当前文本的属性
    NSDictionary *labelAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:labelFont, NSFontAttributeName, nil];

    //ios7方法，获取文本需要的size，限制宽度
    CGSize labelSize = [labelStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:labelAttributeDic context:nil].size;

    // ios7之前使用方法获取文本需要的size，7.0已弃用下面的方法。此方法要求font，与breakmode与之前设置的完全一致
    // CGSize labelSize = [labelStr sizeWithFont:labelFont constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return labelSize;
}

+ (CGSize)getLabelSizeWithLabelStr:(NSString *)labelStr andLabelFont:(UIFont *)labelFont andMaxSize:(CGSize)maxSize {

    //高度估计文本大概要显示几行，宽度根据需求自己定义。 label可设置的最大高度和宽度 MAXFLOAT 可以算出具体要多高
    CGSize size = maxSize;

    //获取当前文本的属性
    NSDictionary *labelAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:labelFont, NSFontAttributeName, nil];

    //ios7方法，获取文本需要的size，限制宽度
    CGSize labelSize = [labelStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:labelAttributeDic context:nil].size;

    // ios7之前使用方法获取文本需要的size，7.0已弃用下面的方法。此方法要求font，与breakmode与之前设置的完全一致
    // CGSize labelSize = [labelStr sizeWithFont:labelFont constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return labelSize;
}

+ (NSInteger)getLabelLineNumberWithLabelStr:(NSString *)labelStr andLabelFont:(UIFont *)labelFont andMaxSize:(CGSize)maxSize {
    CGFloat labelWith = [ToolUtil getLabelSizeWithLabelStr:labelStr andLabelFont:labelFont andMaxSize:maxSize].width;
    if (fmodf(labelWith, maxSize.width) > 0.0f) {
        return (NSInteger)(labelWith / maxSize.width) + 1;
    } else {
        return (NSInteger)(labelWith / maxSize.width);
    }
}

//URL含中文转码
+ (NSString *)urlEncodeString:(NSString *)urlStr {
    //    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    //    NSString *encodedString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    //    return encodedString;

    return [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (CGFloat)getLabelHightWithLabelStr:(NSString *)labelStr MaxSize:(CGSize)maxSize AndFont:(CGFloat)font LineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 字体的行间距
    
    CGSize labelSize = [labelStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    
    if (labelSize.height > font + lineSpace) {
        return labelSize.height;
    }
    
    if (labelSize.height <= font + lineSpace) {
        return font + 2;
    }
    
    return 0;
}

//身份证识别:是否是身份证号
+ (BOOL)checkIdentityCardNo:(NSString *)cardNo {
    if (cardNo.length != 18) {
        return NO;
    }
    
    NSArray *codeArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSDictionary *checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil] forKeys:[NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil]];
    
    NSScanner *scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i = 0; i < 17; i++) {
        sumValue += [[cardNo substringWithRange:NSMakeRange(i, 1)] intValue] * [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString *strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d", sumValue % 11]];
    
    if ([strlast isEqualToString:[[cardNo substringWithRange:NSMakeRange(17, 1)] uppercaseString]]) {
        return YES;
    }
    return NO;
}

@end
