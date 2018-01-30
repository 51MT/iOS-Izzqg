//
//  Constant.h
//  Ixyb
//
//  Created by wangjianimac on 14-4-15.
//  Copyright (c) 2014年 Ixyb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {

    developUrlType = 0, // 开发环境
    testUrlType = 1,    //测试环境
    productUrlType = 2  //生产环境

} UrlType;

@interface Constant : NSObject

//声明属性
@property (assign, nonatomic) UrlType urlType;

@property (strong, nonatomic) NSString *baseUrl;    //APP接口服务器URL地址
@property (strong, nonatomic) NSString *nodeJs_Url; //NodeJs服务器URL地址
@property (strong, nonatomic) NSString *d_Url;      //信闪贷接口

@property (assign, nonatomic) BOOL isEnvDevMode; //是否是白骑士、Face++、魔蝎开发测试环境

//单例模式实现方法，获取唯一的系统基本信息常量
+ (Constant *)sharedConstant;

@end
