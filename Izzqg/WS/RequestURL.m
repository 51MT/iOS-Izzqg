//
//  RequestURL.m
//  IXsd
//
//  Created by wangjianimac on 16/6/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "RequestURL.h"

@implementation RequestURL

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
+ (NSString *)getRequestURL:(NSString *)requestURL param:(NSDictionary *)paramsDic {

    //登录后，每条URL后面添加userId
    if ([Utility shareInstance].isLogin) {

        NSString *userIdStr = [NSString stringWithFormat:@"&userId=%@", [UserDefaultsUtil getUser].userId];
        return [NSString stringWithFormat:@"%@%@%@%@", [Constant sharedConstant].baseUrl, requestURL, [Utility withThesha:paramsDic], userIdStr];

    } else {

        return [NSString stringWithFormat:@"%@%@%@", [Constant sharedConstant].baseUrl, requestURL, [Utility withThesha:paramsDic]];
    }
}

/**
 *  @author wangjian, 16-12-12 15:12:44
 *
 *  @brief 获取UserAgent
 *
 *  @return 返回UserAgent
 */
+ (NSString *)getUserAgent {

    UIDevice *device = [[UIDevice alloc] init];
    NSString *userAgent = [NSString stringWithFormat:@"XYB/%@/IOS/%@/%@/%@", [ToolUtil getAppVersion], device.systemVersion, device.model, device.identifierForVendor.UUIDString];
    return userAgent;
}


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
+ (NSString *)getNodeJsH5URL:(NSString *)h5URL withIsSign:(BOOL)isSign {

    NSString *serverH5Url = [NSString stringWithFormat:@"%@%@", [Constant sharedConstant].nodeJs_Url, h5URL];

    return [self getServerH5Url:serverH5Url withIsSign:isSign];
}

/**
 *  @author wangjian, 16-12-12 14:12:08
 *
 *  @brief 获取运营活动返回的H5 URL
 *
 *  @param h5LinkURL 运营活动H5 URL
 *
 *  @return 返回整个运营活动URL
 */
+ (NSString *)getH5LinkURL:(NSString *)h5LinkURL {

    return [self getServerH5Url:h5LinkURL withIsSign:YES];
}

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
+ (NSString *)getServerH5Url:(NSString *)serverH5URL withIsSign:(BOOL)isSign {

    //H5 URL
    if (!isSign) {
        return serverH5URL;
    }

    //serverH5URL是否含有？
    BOOL isRange;
    if([serverH5URL rangeOfString:@"?"].location != NSNotFound) {
        isRange = YES;
    } else {
        isRange = NO;
    }
    
    //已登录 带签名sign和userId
    if ([Utility shareInstance].isLogin) {

        NSMutableDictionary *inputParamsDic = [[NSMutableDictionary alloc] init];
        [inputParamsDic setObject:[UserDefaultsUtil getUser].userId forKey:@"userId"];
        NSString *signStr = [NSString stringWithFormat:@"%@%@",isRange?@"&sign=":@"?sign=",[Utility withThesha:inputParamsDic]];
        NSString *userIdStr = [NSString stringWithFormat:@"&userId=%@", [UserDefaultsUtil getUser].userId];
        return [NSString stringWithFormat:@"%@%@%@", serverH5URL, signStr, userIdStr];

    } else { //未登录 只带签名sign

        NSString *signStr = [NSString stringWithFormat:@"%@%@",isRange?@"&sign=":@"?sign=",[Utility withThesha:nil]];
        return [NSString stringWithFormat:@"%@%@", serverH5URL, signStr];
    }
}

+ (NSString *)getZzqg_BaseUrl:(NSString *)Url {
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@", [Constant sharedConstant].baseUrl, Url];

    return baseUrl;
}

@end
