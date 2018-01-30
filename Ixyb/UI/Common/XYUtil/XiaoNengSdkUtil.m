//
//  XiaoNengSDKUtil.m
//  Ixsd
//
//  Created by wangjianimac on 2017/7/20.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "XiaoNengSdkUtil.h"

#import "XNSDKCore.h"

#import "Utility.h"

@implementation XiaoNengSdkUtil

#pragma mark - 初始化小能SDK

+ (void)initXN {

    /**
     SDK初始化
     siteid: 企业ID，即企业的唯一标识。格式示例：kf_9979 【必填】
     SDKKey: 企业通行密钥。(从小能技术支持人员那获得) 格式示例：12345678abcdefg【必填】
     */
    [[XNSDKCore sharedInstance] initSDKWithSiteid:@"kf_9482" andSDKKey:@"F5EDFFF0-14F6-4448-80BB-6D3B3586BD80"];

    /**（SDK2.1 版本新增加方法，SDK 2.0无此接口方法）
     是否开启链接名片功能（即客服发送文本信息中含有支持链接名片的单个链接时，在SDK端以名片形式展示URL）
     enable：YES :开启链接名片功能（内部默认YES） NO：不开启链接名片功能
     */
    [[XNSDKCore sharedInstance] setLinkCardEnable:YES];

    //应用登录成功后再次进入应用初始化小能用户
    [XiaoNengSdkUtil initXNUser];
}

+ (void)initXNUser {
    //应用每次启动必须初始化小能客服
    if ([Utility shareInstance].isLogin) {
        //登录成功初始化小能 用户
        [[XNSDKCore sharedInstance] loginWithUserid:[UserDefaultsUtil getUser].userId andUsername:[UserDefaultsUtil getUser].userId andUserLevel:@"0"];
    }
}

+ (void)xnLoginOut {
    [[XNSDKCore sharedInstance] logout];
}

@end
