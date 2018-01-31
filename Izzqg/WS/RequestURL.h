//
//  RequestURL.h
//  IXsd
//
//  Created by wangjianimac on 16/6/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constant.h"
#import "RequestURLDefine.h"
#import "Utility.h"

@interface RequestURL : NSObject

/**
 *  @author wangjian, 16-12-12 15:12:38
 *
 *  @brief 获取接口服务器RequestURL
 *
 *  @param requestURL     接口服务器RequestURL
 *  @param inputParamsDic 入参集合
 *
 *  @return 返回整个接口服务器Http URL
 */
+ (NSString *)getRequestURL:(NSString *)requestURL param:(NSDictionary *)inputParamsDic;

/**
 *  @author wangjian, 16-12-12 15:12:44
 *
 *  @brief 获取UserAgent
 *
 *  @return 返回UserAgent
 */
+ (NSString *)getUserAgent;

/**
 *  @author wangjian, 16-12-12 14:12:59
 *
 *  @brief 获取NodeJs服务器的H5 URL
 *
 *  @param h5URL  NodeJs服务器的H5 URL
 *  @param isSign 是否带签名：未登录只带签名和已登录带签名和userId
 *
 *  @return 返回整个NodeJs服务器Http URL
 */
+ (NSString *)getNodeJsH5URL:(NSString *)h5URL withIsSign:(BOOL)isSign;

/**
 *  @author wangjian, 16-12-12 14:12:08
 *
 *  @brief 获取运营活动返回的H5 URL
 *
 *  @param h5LinkURL 运营活动H5 URL
 *
 *  @return 返回整个运营活动URL
 */
+ (NSString *)getH5LinkURL:(NSString *)h5LinkURL;

/**
 *  @author wangjian, 16-12-12 15:12:43
 *
 *  @brief 获取服务器的H5 URL
 *
 *  @param serverH5URL serverH5URL 服务器地址＋H5 URL
 *  @param isSign      是否带签名：未登录只带签名和已登录带签名和userId
 *
 *  @return @return 返回整个服务器URL
 */
+ (NSString *)getServerH5Url:(NSString *)serverH5URL withIsSign:(BOOL)isSign;

/**
 *  @author Dzg
 *
 *  @brief 获取信闪贷的URL
 *
 *  @param xsdURL 信闪贷服务器地址 + URL
 *
 *  @return 返回链接URL
 */
+ (NSString *)getXsdUrl:(NSString *)xsdURL;

@end
