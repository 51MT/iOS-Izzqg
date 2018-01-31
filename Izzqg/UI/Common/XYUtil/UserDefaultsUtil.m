//
//  UserDefaultsUtil.m
//  Ixyb
//
//  Created by wangjianimac on 16/10/14.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "UserDefaultsUtil.h"

#import "ToolUtil.h"

@implementation UserDefaultsUtil

//启动图片
+ (void)setStartUpImage:(NSString *)imageUrl {
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:imageUrl];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"imageUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getStartUpImage {
    return [NSKeyedUnarchiver
        unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                    objectForKey:@"imageUrl"]];
}

+ (void)clearStartUpImage {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imageUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户
+ (void)setUser:(User *)user {
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"temp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (User *)getUser {
    return [NSKeyedUnarchiver
        unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                    objectForKey:@"temp"]];
}

+ (void)clearUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"temp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//指纹
+ (void)setEncryptionDataKey:(NSString *)key value:(NSString *)defaultValue {
    [[NSUserDefaults standardUserDefaults]
        setObject:defaultValue
           forKey:[NSString stringWithFormat:@"secretKey%@", key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getEncryptionData:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults]
        objectForKey:[NSString stringWithFormat:@"secretKey%@", key]];
}

+ (void)clearEncryptionData:(NSString *)key {
    [[NSUserDefaults standardUserDefaults]
        removeObjectForKey:[NSString stringWithFormat:@"secretKey%@", key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//保存收货地址
+ (UserAddress *)getCurrentUserAddress {
    return [NSKeyedUnarchiver
        unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]
                                    objectForKey:@"userAddress"]];
}

+ (void)setUserAddress:(UserAddress *)userAddress {
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userAddress];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"userAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearTheUserAddress {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setIsAlreadyLogin {
    //用户已登录过
    [[NSUserDefaults standardUserDefaults] setObject:@"1"
                                              forKey:@"isAlreadyLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//判断是否登录
+ (NSString *)getIsAlreadyLogin {
    NSString *isAlreadyLogin = [[NSUserDefaults standardUserDefaults] stringForKey:@"isAlreadyLogin"];
    if (isAlreadyLogin == nil) {
        isAlreadyLogin = @"0";
    }
    return isAlreadyLogin;
}

//设置小红点状态
+ (void)setRedRotStats {
    [[NSUserDefaults standardUserDefaults] setObject:@"redRotStats"
                                              forKey:@"redRotStats"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getRedRotStats {
    NSString *new = [ [NSUserDefaults standardUserDefaults] stringForKey : @"redRotStats" ];
    return new;
}

//账户金额状态
+ (void)setNew {
    [[NSUserDefaults standardUserDefaults] setObject:@"****" forKey:@"new"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getNew {
    NSString *new = [ [NSUserDefaults standardUserDefaults] stringForKey : @"new" ];
    return new;
}

+ (BOOL)setStringToUserDefaultsWithKey:(NSString *)key andValue:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return true;
}

+ (void)clearNew {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"new"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//存储是否弹窗“新功能上线通知”
+ (void)setNewFunction {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"newFunction"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getNewFunction {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"newFunction"];
}

//存储手机UUID
+ (void)setUUID {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[ToolUtil getUUID] forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getUUID {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"UUID"];
}

//储存消息的NoticeId
+ (void)setMessageNoticeId:(NSDictionary *)messageDic {
    [[NSUserDefaults standardUserDefaults] setObject:messageDic forKey:@"Message"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getMessageNoticeId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Message"];
}

//储存公告消息、活动消息、出借消息、借款消息最后阅读时间
+ (void)setLastReadDateDic:(NSDictionary *)LastReadDateDic {
    NSUserDefaults *dateDefaults = [NSUserDefaults standardUserDefaults];
    [dateDefaults setObject:LastReadDateDic forKey:@"LastReadDateDic"];
    [dateDefaults synchronize];
}

+ (NSDictionary *)getLastReadDateDic {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"LastReadDateDic"];
}


/********************整理***********************/

//存储当前日期时间（设置手势密码间隔1分钟）
+ (void)writeCurrentDate {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSDate date] forKey:@"currentDate"];
    [userDefaults synchronize];
}

//读取当前日期时间（设置手势密码间隔1分钟）
+ (NSDate *)readCurrentDate {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"currentDate"];
}

//存储是否第一次运行APP
+ (void)writeFirstLaunchValue:(BOOL)isFirstLaunch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isFirstLaunch forKey:@"firstLaunch"];
    [userDefaults synchronize];
}

//读取是否第一次运行APP
+ (BOOL)readFirstLaunchValue {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
}

//存储当前版本是否第一次运行APP
+ (void)writeEveryLaunchWithKey:(NSString *)everyLaunchKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:everyLaunchKey];
    [userDefaults synchronize];
}

//读取当前版本是否第一次运行APP
+ (BOOL)readEveryLaunchValue:(NSString *)everyLaunchKey {
    return [[NSUserDefaults standardUserDefaults] boolForKey:everyLaunchKey];
}

//存储deviceToken
+ (void)writeDeviceTokenValue:(NSString *)deviceToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceToken forKey:@"deviceToken"];
    [userDefaults synchronize];
}

//读取deviceToken
+ (NSString *)readDeviceToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"deviceToken"];
}






// 存储UserDefaults单个存储数据对象Value
+ (void)writeUserDefaultsObject:(id)objectValue forKey:(NSString *)key {
    if (objectValue) {
        NSData *objectValueData = [NSKeyedArchiver archivedDataWithRootObject:objectValue];
        [[NSUserDefaults standardUserDefaults] setObject:objectValueData forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 存储UserDefaults单个存储数据Value
+ (void)writeUserDefaultsValue:(id)value forKey:(NSString *)key {
    if (value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 读取UserDefaults单个存储数据Value 没有此key对应的值，则返回nil
+ (id)readUserDefaultsValueWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

// 读取UserDefaults单个存储数据对象Value 没有此key对应的值，则返回nil
+ (id)readUserDefaultsObjectWithKey:(NSString *)key {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
}

// 删除UserDefaults单个存储数据
+ (void)removeUserDefaultsValueWithkey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 删除UserDefaults所有存储数据
+ (BOOL)clearAllUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefaults dictionaryRepresentation];
    for (NSString *key in [dictionary allKeys]) {
        [userDefaults removeObjectForKey:key];
        [userDefaults synchronize];
    }
    return true;
}

@end
