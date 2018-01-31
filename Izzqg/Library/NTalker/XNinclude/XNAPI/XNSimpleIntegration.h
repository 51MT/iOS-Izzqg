//
//  XNFastIntegration.h
//  NTalkerUIKitSDK
//
//  Created by 郭天航 on 16/9/28.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTalkerChatViewController.h"

@interface XNSimpleIntegration : NSObject

#pragma mark - 快速集成方法

- (NTalkerChatViewController *)startChatWithSiteid:(NSString *)siteid SDKKey:(NSString *)SDKKey userid:(NSString *)userid username:(NSString *)username userLevel:(NSString *)userLevel settingid:(NSString *)settingid;

@end
