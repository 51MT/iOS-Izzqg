//
//  ColorUtil.h
//  Ixyb
//
//  Created by wangjianimac on 16/8/24.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorUtil : NSObject

/**
 *  @brief 将16进制颜色转换成UIColor
 *
 *  @param color 16进制颜色
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  @brief 颜色转换为背景图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
