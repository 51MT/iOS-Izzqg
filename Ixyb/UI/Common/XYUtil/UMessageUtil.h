//
//  UMessageUtil.h
//  Ixyb
//
//  Created by wangjianimac on 2017/5/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "UMessage.h"

@interface UMessageUtil : NSObject

// 友盟消息推送 注册
+ (void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions httpsenable:(BOOL)value;

// 接收消息
+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo appDelegate:(AppDelegate *)delegate;

// iOS10新增：处理前台收到通知的代理方法
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler appDelegate:(AppDelegate *)delegate;

// iOS10新增：处理后台点击通知的代理方法
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler appDelegate:(AppDelegate *)delegate;

@end
