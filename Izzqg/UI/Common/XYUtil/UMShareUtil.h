//
//  UMShareUtil.h
//  Ixyb
//
//  Created by wang on 16/10/20.
//  Copyright © 2016年 xyb. All rights reserved.
//

//#import "UMSocial.h"
#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>

@interface UMShareUtil : NSObject

// 设置友盟分享的appKey
+ (void)setUmSocialAppkey:(NSString *)appKey;

// 分享调用
+ (void)shareUrl:(NSString *)url title:(NSString *)title content:(NSString *)content image:(UIImage *)image controller:(UIViewController *)controller;

@end
