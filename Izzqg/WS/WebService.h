//
//  WebService.h
//  IXsd
//
//  Created by wangjianimac on 16/6/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworkActivityIndicatorManager.h" //小菊花加载
#import "ModelNetworkClient.h"

#import "RequestURL.h"
#import "ResponseModel.h"

@interface WebService : NSObject

//接口封装 post方法
+ (void)postRequest:(NSString *)urlPath
              param:(NSDictionary *)params
     JSONModelClass:(Class)responseModelClass
            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail;

//接口封装 get方法
+ (void)getRequest:(NSString *)urlPath
             param:(NSDictionary *)params
    JSONModelClass:(Class)responseModelClass
           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail;

//图片上传接口
+ (void)postRequest:(NSString *)urlPath
              param:(NSDictionary *)params
        uploadImage:(UIImage *)image
            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail;
//第三方图片上传接口
+ (void)postThirdPartyRequest:(NSString *)urlPath
              param:(NSDictionary *)params
        uploadImage:(UIImage *)image
            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail;

//多张图片上传接口
+ (void)postRequest:(NSString *)urlPath
              param:(NSDictionary *)params
       uploadImages:(NSMutableArray *)imageArray
            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail;

/**
 *  @author Dzg
 *
 *  @brief 信闪贷Post请求
 *
 *  @param urlPath            requestURL
 *  @param params             参数
 *  @param responseModelClass 接收模型
 *  @param success            成功block
 *  @param fail               失败block
 */
+ (void)postXsdRequest:(NSString *)urlPath param:(NSDictionary *)params JSONModelClass:(Class)responseModelClass
               Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail;

/**
 *  @author Dzg
 *
 *  @brief 信闪贷单张图片上传接口
 *
 *  @param urlPath 上传路径
 *  @param params  参数
 *  @param image   上传的图片
 *  @param success 成功block
 *  @param fail    失败block
 */
+ (void)postXsdRequest:(NSString *)urlPath param:(NSDictionary *)params uploadImage:(UIImage *)image
            Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail;

/**
 *  @author Dzg
 *
 *  @brief 信闪贷多张图片上传接口
 *
 *  @param urlPath 上传路径
 *  @param params  参数
 *  @param image   上传的图片
 *  @param success 成功block
 *  @param fail    失败block
 */
+ (void)postXsdRequest:(NSString *)urlPath param:(NSDictionary *)params uploadImageArray:(NSArray *)imageArray
               Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  fail:(void (^)(AFHTTPRequestOperation *operation, NSString *errorMessage))fail;


@end
