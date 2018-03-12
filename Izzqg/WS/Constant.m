//
//  Constant.m
//  Ixyb
//
//  Created by wangjianimac on 16-4-15.
//  Copyright (c) 2014年 Ixyb. All rights reserved.
//

#import "Constant.h"

@implementation Constant

static Constant *sharedConstant = nil;

//构造函数，此类中主要用于只读属性的初始化
- (id)init {

    self = [super init];

    if (self) {

#if URLTYPE == 0
        self.urlType = developUrlType;
#elif URLTYPE == 1
        self.urlType = testUrlType;
#elif URLTYPE == 2
        self.urlType = productUrlType;
#endif
        
//        self.urlType = productUrlType;
        
        if (self.urlType == developUrlType) {

            self.baseUrl = @"http://192.168.1.91:3000/app";
//            self.nodeJs_Url = @"http://192.168.1.189:3000";         //zhaohua pc本地ip地址和端口
//            self.d_Url = @"http://192.168.1.190:8080/xyb-xsd-web"; //http://192.168.1.76:8080/xyb-xsd-web/app-loan
            self.isEnvDevMode = YES;

        } else if (self.urlType == testUrlType) {

            self.baseUrl = @"https://apptest.xyb100.com";
            self.nodeJs_Url = @"https://apptest2.xyb100.com";
            self.d_Url = @"https://xsdtest.xyb100.com";
            self.isEnvDevMode = YES;

        } else if (self.urlType == productUrlType) {

            self.baseUrl = @"https://app.xyb100.com";
            self.nodeJs_Url = @"https://appno.xyb100.com";
            self.d_Url = @"https://d.xyb100.com";
            self.isEnvDevMode = NO;
        }
    }
    return self;
}

//单例模式实现方法
+ (Constant *)sharedConstant {
    @synchronized(self) {
        if (sharedConstant == nil) {
            sharedConstant = [[Constant alloc] init]; //写法意义相同:sharedConstant = [[self alloc] init];
        }
        return sharedConstant;
    }
}

@end
