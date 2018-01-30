//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+ (void)showMessag:(NSString *)message detailsMessage:(NSString *)detailsMessage View:(UIView *)view;

+ (void)showTextMessag:(NSString *)message detailsMessage:(NSString *)detailsMessage View:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error toYOffset:(float)yOffset toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toYOffset:(float)yOffset toView:(UIView *)view;

@end
