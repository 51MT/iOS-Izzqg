//
//  XNBaseInstance.h
//  NTalkerUIKitSDK
//
//  Created by 郭天航 on 16/9/28.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTalkerChatViewController.h"

@interface XNBaseInstance : NSObject

/**
 *  程序开启,注册连接
 *
 *  @param siteid 企业ID
 *  @param SDKKey 唯一标示符
 *
 *  @return 参数判断的返回值,0为参数正确
 */
- (NSInteger)initSDKWithSiteid:(NSString *)siteid andSDKKey:(NSString *)SDKKey;
/**
 *  程序开启,注册连接(与上面的初始化方式二选一，需要传入自己APP的设备ID的才调用该种初始化方式)【可选】
 *
 *  @param siteid 企业ID
 *  @param SDKKey 唯一标示符
 *  @param PCid 传入的PCid
 *  @return 参数判断的返回值,0为参数正确
 */
- (NSInteger)initSDKWithSiteid:(NSString *)siteid andSDKKey:(NSString *)SDKKey andPCid:(NSString*)pcid;

/**
 *  开始聊天，返回聊窗controller
 *
 *  @param settingid 接待组id
 *
 *  @return 聊天窗口controller
 */
- (NTalkerChatViewController *)startChatWithSettingId:(NSString *)settingid;

/**
 *  程序关闭,断开连接
 */
- (void)destroy;

/**
 *  用户登录时调用此方法
 *
 *  @param userid    用户ID,字母,数字,下划线或@符号
 *  @param username  字母,数字,下划线,汉字或@符号
 *  @param userLevel 1到5
 *
 *  @return 参数判断的返回值,0为参数正确
 */
- (NSInteger)loginWithUserid:(NSString *)userid
                 andUsername:(NSString *)username
                andUserLevel:(NSString *)userLevel;


/**
 *  用户登录时调用此方法
 *
 *  @param userid    用户ID,字母,数字,下划线或@符号
 *  @param username  字母,数字,下划线,汉字或@符号
 *
 *  @return 参数判断的返回值,0为参数正确
 */
//- (NSInteger)loginWithUserid:(NSString *)userid
//                 andUsername:(NSString *)username;

/**
 *  用户注销是调用
 */
- (void)logout;

/**
 *  轨迹调用
 *
 *  @param title        页面标题,必填
 *  @param sellerid     商户ID,针对平台版
 *  @param orderid      订单ID
 *  @param orderprice   订单价格
 *  @param ref
 *  @param ntalkerparam 特定参数
 *  @param isVip        用户等级
 *  @param URLString    链接
 *
 *  @return 参数判断的返回值,0为参数正确
 */
- (NSInteger)startActionWithTitle:(NSString *)title
                      andSellerId:(NSString *)sellerid
                       andOrderid:(NSString *)orderid
                    andOrderprice:(NSString *)orderprice
                           andRef:(NSString *)ref
                  andNtalkerparam:(NSString *)ntalkerparam
                         andIsVip:(NSString *)isVip
                     andURLString:(NSString *)URLString;


- (NSInteger)startHomeAction;

- (NSInteger)startHomeActionWithTitle:(NSString *)title
                         andURLString:(NSString *)URLString;

- (NSInteger)startGoodsListAction;

- (NSInteger)startGoodsListActionWithTitle:(NSString *)title
                              andURLString:(NSString *)URLString
                                    andRef:(NSString *)ref;

- (NSInteger)startGoodsDetailAction;

- (NSInteger)startGoodsDetailActionWithTitle:(NSString *)title
                                andURLString:(NSString *)URLString
                                      andRef:(NSString *)ref;

- (NSInteger)startShoppingCartAction;

- (NSInteger)startShoppingCartActionWithTitle:(NSString *)title
                                 andURLString:(NSString *)URLString
                                       andRef:(NSString *)ref;


- (NSInteger)startOrderActionWithOrderid:(NSString *)orderid
                           andOrderprice:(NSString *)orderprice;

- (NSInteger)startOrderActionWithTitle:(NSString *)title
                          andURLString:(NSString *)URLString
                                andRef:(NSString *)ref
                            andOrderid:(NSString *)orderid
                         andOrderprice:(NSString *)orderprice;

- (NSInteger)startPayActionWithOrderid:(NSString *)orderid
                         andOrderprice:(NSString *)orderprice;

- (NSInteger)startPayActionWithTitle:(NSString *)title
                        andURLString:(NSString *)URLString
                              andRef:(NSString *)ref
                          andOrderid:(NSString *)orderid
                       andOrderprice:(NSString *)orderprice;

- (NSInteger)startPaySuccessActionWithOrderid:(NSString *)orderid
                                andOrderprice:(NSString *)orderprice;

- (NSInteger)startPaySuccessActionWithTitle:(NSString *)title
                               andURLString:(NSString *)URLString
                                     andRef:(NSString *)ref
                                 andOrderid:(NSString *)orderid
                              andOrderprice:(NSString *)orderprice;

@end
