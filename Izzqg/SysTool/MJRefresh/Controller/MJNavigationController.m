//
//  MJNavigationController.m
//  快速集成下拉刷新
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJNavigationController.h"
// 判断是否为iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@implementation MJNavigationController

#pragma mark 一个类只会调用一次
+ (void)initialize
{
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    if (iOS7)
    {
        // iOS7
        navBar.barTintColor = RGBCOLOR(251.0f,110.0f,83.0f,1.0f);
        navBar.tintColor = [UIColor whiteColor];
        navBar.backgroundColor = RGBCOLOR(251.0f,110.0f,83.0f,1.0f);
        
//        [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
//        navBar.barStyle = UIBarStyleBlackTranslucent;
    }
    else
    { // 非iOS7
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    // 3.标题
    [navBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor whiteColor]
                                     }];
}

#pragma mark 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end