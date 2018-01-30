//
//  ToolUtil.h
//  Ixyb
//
//  Created by wangjianimac on 16/9/29.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Util 工具类：通用的、与业务无关的，可以独立出来，可供其他项目使用
 *
 */
@interface ToolUtil : NSObject

/**
 *  设备Device相关
 */
//获取UUID
+ (NSString *)getUUID;

//获取DeviceToken
+ (NSString *)getDeviceToken;

//获取APP版本号
+ (NSString *)getAppVersion;

/**
 *  ViewController UI相关
 */
//根据Label Str、字体大小、最大显示区域来计算Label的实现显示区域（宽、高）
+ (CGSize)getLabelSizeWithLabelStr:(NSString *)labelStr andLabelFont:(UIFont *)labelFont;
+ (CGSize)getLabelSizeWithLabelStr:(NSString *)labelStr andLabelFont:(UIFont *)labelFont andMaxSize:(CGSize)maxSize;

//URL含中文转码
+ (NSString *)urlEncodeString:(NSString *)urlStr;

//获取label的高度
+ (CGFloat)getLabelHightWithLabelStr:(NSString *)labelStr MaxSize:(CGSize)maxSize AndFont:(CGFloat)font LineSpace:(CGFloat)lineSpace;

//身份证识别:是否是身份证号
+ (BOOL)checkIdentityCardNo:(NSString *)cardNo;

@end
