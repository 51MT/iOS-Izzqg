//
//  AppDelegate.h
//  Ixyb
//
//  Created by wangjianimac on 15/4/7.
//  Copyright (c) 2015年 xyb. All rights reserved.

//  master分支 已合并xyb2.1.8分支

#import <UIKit/UIKit.h>

#import "IntroduceViewController.h"
#import "WelcomeViewController.h"
#import "XYTabBarViewController.h"

/**
 * 描述：App 委托代理
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,
                                      UIAlertViewDelegate, IntroduceViewControllerDelegate,
                                      WelcomeViewControllerDelegate> {
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) WelcomeViewController *welcomeVC;

@property (strong, nonatomic) XYTabBarViewController *tabBarVC;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;

@end
