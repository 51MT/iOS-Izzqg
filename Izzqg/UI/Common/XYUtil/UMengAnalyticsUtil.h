//
//  UMengAnalyticsUtil.h
//  Ixsd
//
//  Created by wangjianimac on 2017/5/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMengAnalyticsUtil : NSObject

+ (void)startWithAppkey:(NSString *)appKey;

+ (void)beginLogPageView:(NSString *)pageName;
+ (void)endLogPageView:(NSString *)pageName;

+ (void)event:(NSString *)eventId;
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

@end
