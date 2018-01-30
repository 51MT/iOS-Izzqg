//
//  UserDefaultsUtil.h
//  Ixyb
//
//  Created by wangjianimac on 16/10/14.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "User.h"
#import "UserAddress.h"
#import <Foundation/Foundation.h>

/**
 * NSUserDefaults支持的数据类型有：NSNumber（NSInteger、float、double），NSString，NSDate，NSArray，NSDictionary，BOOL.
 * 支持自定义类型对象NSObject转换为NSData类型进行存储
 */

// UserDefaultsUtil：用户首选项归档 工具类
@interface UserDefaultsUtil : NSObject

//- (void)setObject:(nullable id)value forKey:(NSString *)defaultName;
//- (nullable id)objectForKey:(NSString *)defaultName;
//- (void)removeObjectForKey:(NSString *)defaultName;
//启动图片
+ (void)setStartUpImage:(NSString *)imageUrl;
+ (NSString *)getStartUpImage;
+ (void)clearStartUpImage;

//用户
+ (void)setUser:(User *)user;
+ (User *)getUser;
+ (void)clearUser;

//指纹
+ (void)setEncryptionDataKey:(NSString *)key value:(NSString *)defaultValue;
+ (NSString *)getEncryptionData:(NSString *)key;
+ (void)clearEncryptionData:(NSString *)key;

//收货地址
+ (void)setUserAddress:(UserAddress *)userAddress;
+ (UserAddress *)getCurrentUserAddress;
+ (void)clearTheUserAddress;

//判断是否登录
+ (void)setIsAlreadyLogin;
+ (NSString *)getIsAlreadyLogin;

//设置指纹小红点状态
+ (void)setRedRotStats;
+ (NSString *)getRedRotStats;

//账户页面状态
+ (void)setNew;
+ (NSString *)getNew;
+ (void)clearNew;

+ (BOOL)setStringToUserDefaultsWithKey:(NSString *)key
                              andValue:(NSString *)value;


//存储是否弹窗“新功能上线通知”
+ (void)setNewFunction;
+ (BOOL)getNewFunction;

//存储手机UUID
+ (void)setUUID;
+ (NSString *)getUUID;

//储存消息的NoticeId
+ (void)setMessageNoticeId:(NSDictionary *)messageDic;
+ (NSDictionary *)getMessageNoticeId;

//储存公告消息、活动消息、出借消息、借款消息最后阅读时间
+ (void)setLastReadDateDic:(NSDictionary *)LastReadDateDic;
+ (NSDictionary *)getLastReadDateDic;


/********************整理***********************/

//存储当前日期时间（手势密码间隔1分钟）
+ (void)writeCurrentDate;
//读取当前日期时间（手势密码间隔1分钟）
+ (NSDate *)readCurrentDate;

//存储是否第一次运行APP
+ (void)writeFirstLaunchValue:(BOOL)isFirstLaunch;
//读取是否第一次运行APP
+ (BOOL)readFirstLaunchValue;

//存储当前版本是否第一次运行APP
+ (void)writeEveryLaunchWithKey:(NSString *)everyLaunchKey;
//读取当前版本是否第一次运行APP
+ (BOOL)readEveryLaunchValue:(NSString *)everyLaunchKey;

//存储deviceToken
+ (void)writeDeviceTokenValue:(NSString *)deviceToken;
//读取deviceToken
+ (NSString *)readDeviceToken;



// 存储UserDefaults单个存储数据对象Value
+ (void)writeUserDefaultsObject:(id)objectValue forKey:(NSString *)key;

// 存储UserDefaults单个存储数据Value
+ (void)writeUserDefaultsValue:(id)value forKey:(NSString *)key;

// 读取UserDefaults单个存储数据Value 没有此key对应的值，则返回nil
+ (id)readUserDefaultsValueWithKey:(NSString *)key;

// 读取UserDefaults单个存储数据对象Value 没有此key对应的值，则返回nil
+ (id)readUserDefaultsObjectWithKey:(NSString *)key;

// 删除UserDefaults单个存储数据
+ (void)removeUserDefaultsValueWithkey:(NSString *)key;

// 删除UserDefaults所有存储数据
+ (BOOL)clearAllUserDefaults;

@end
