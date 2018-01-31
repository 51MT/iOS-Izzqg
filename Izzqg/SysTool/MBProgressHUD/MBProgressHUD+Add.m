//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 1.5f秒之后再消失
    [hud hide:YES afterDelay:1.5f];
}

+ (void)show:(NSString *)text icon:(NSString *)icon toYOffset:(float)yOffset view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.yOffset = yOffset;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5f];
}

+ (void)showMessag:(NSString *)message detailsMessage:(NSString *)detailsMessage View:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;

    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    hud.labelText = message;

    // 设置图片
    hud.detailsLabelText = detailsMessage;

    // 再设置模式
    hud.mode = MBProgressHUDModeDeterminate;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 1.5秒之后再消失
    [hud hide:YES afterDelay:1.5f];
}

+ (void)showTextMessag:(NSString *)message detailsMessage:(NSString *)detailsMessage View:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;

    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    hud.labelText = message;

    // 设置图片
    hud.detailsLabelText = detailsMessage;

    // 再设置模式
    hud.mode = MBProgressHUDModeText;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 1.5秒之后再消失
    [hud hide:YES afterDelay:1.5f];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;

    return hud;
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"mbprogresshud_error" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"mbprogresshud_success" view:view];
}

+ (void)showError:(NSString *)error toYOffset:(float)yOffset toView:(UIView *)view {
    [self show:error icon:@"mbprogresshud_error" toYOffset:yOffset view:view];
}

+ (void)showSuccess:(NSString *)success toYOffset:(float)yOffset toView:(UIView *)view {
    [self show:success icon:@"mbprogresshud_success" toYOffset:yOffset view:view];
}

@end
