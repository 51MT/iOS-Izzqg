//
//  UMengAnalyticsUtil.m
//  Ixsd
//
//  Created by wangjianimac on 2017/5/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "UMMobClick/MobClick.h"

#import "UMengAnalyticsUtil.h"

#ifdef DEBUG
#define XYB_ANALYTICS_LOGENABLE 0
#endif

@implementation UMengAnalyticsUtil

+ (void)beginLogPageView:(NSString *)pageName {
#if XYB_ANALYTICS_LOGENABLE
    NSLog(@"[analytics] beginLogPageView = %@", pageName);
#endif
    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName {
#if XYB_ANALYTICS_LOGENABLE
    NSLog(@"[analytics] endLogPageView = %@", pageName);
#endif
    [MobClick endLogPageView:pageName];
}

+ (void)event:(NSString *)eventId {
#if XYB_ANALYTICS_LOGENABLE
    NSLog(@"[analytics] event = %@", eventId);
#endif
    [MobClick event:eventId];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
#if XYB_ANALYTICS_LOGENABLE
    NSLog(@"[analytics] event = %@ attr = %@", eventId, attributes);
#endif
    [MobClick event:eventId attributes:attributes];
}


+ (void)startWithAppkey:(NSString *)appKey {
    
    UMConfigInstance.appKey = appKey;               //AppKey
    UMConfigInstance.channelId = @"App Store";      //渠道
    UMConfigInstance.bCrashReportEnabled = YES;     //crash bug 报告
    UMConfigInstance.ePolicy = BATCH;               //启动发送
    //UMConfigInstance.eSType = E_UM_GAME;          //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance]; //配置以上参数后调用此方法初始化SDK！
    [MobClick setAppVersion:XcodeAppVersion];       //版本号
}

@end
