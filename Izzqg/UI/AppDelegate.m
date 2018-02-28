//
//  AppDelegate.m
//  Ixyb
//
//  Created by wangjianimac on 15/4/7.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AppDelegate.h"

#import "RequestURL.h"
#import "Utility.h"

#import "VersionUpdateHttpRequest.h"
#import "XYNavigationController.h"

#import <UserNotifications/UserNotifications.h>
#import <notify.h>

//键盘管理工具初始化
#import "IQKeyboardManagerUtil.h"

//小能sdk
#import "XiaoNengSdkUtil.h"

//友盟分享
#import <UMSocialCore/UMSocialCore.h>

//友盟应用统计
#import "UMengAnalyticsUtil.h"

//友盟消息推送
#import "UMessageUtil.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //加载widow、加载启动页面welcomeVC
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = COLOR_COMMON_WHITE;
    self.welcomeVC = [[WelcomeViewController alloc] init];
    self.welcomeVC.delegate = self;
    [self windowAddRootViewController:self.welcomeVC];

    [self.window.rootViewController.view setNeedsDisplay];
    [self.window makeKeyAndVisible];

    [Utility isExistenceNetwork];

    //键盘管理
    [IQKeyboardManagerUtil initIQKeyboardManager];

    //友盟分享
    [UMShareUtil setUmSocialAppkey:UMENG_APPKEY];

    //友盟推送
    [UMessageUtil startWithAppkey:UMENG_APPKEY launchOptions:launchOptions httpsenable:YES];

    //友盟统计
    [UMengAnalyticsUtil startWithAppkey:UMENG_APPKEY];

    //小能sdk 即时通讯工具（客服聊天）
    [XiaoNengSdkUtil initXN];

    return YES;
}

/******************************* application *****************************/
- (void)applicationWillResignActive:(UIApplication *)application {
    if ([UserDefaultsUtil getUser].gestureUnlock.length > 3) {
        [UserDefaultsUtil writeCurrentDate];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([UserDefaultsUtil getUser].gestureUnlock.length > 3) {
        [UserDefaultsUtil writeCurrentDate];
    }
}

- (void)beingBackgroundUpdateTask {
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask {
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}

- (void)checkTheGesure {
//    GestureLoginViewController *gestureLoginVC = [[GestureLoginViewController alloc] init];
//    XYNavigationController *navigationC = [[XYNavigationController alloc] initWithRootViewController:gestureLoginVC];
//    [navigationC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [navigationC.navigationItem setHidesBackButton:YES];
//    [self.window.rootViewController presentViewController:navigationC
//                                                 animated:YES
//                                               completion:^{
//                                               }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    [self creatTheUpdateHttpRequest];

    if ([DateTimeUtil compareCurrentTime:[UserDefaultsUtil readCurrentDate]]) {
        if ([UserDefaultsUtil getUser].gestureUnlock.length > 3) {
            [self checkTheGesure];
        }
    }
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //    [UMSocialSnsService applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

/******************************* delegate *****************************/
//加载完欢迎页后加载ICSDrawerController（左边导航leftBarView和中间UITabBarView）
- (void)didFinishedLoadWelcomeViewController:(WelcomeViewController *)welcomeVC {

    NSString *everyLaunchKey = [NSString stringWithFormat:@"everyLaunch%@", [ToolUtil getAppVersion]];

    //增加标识，用于判断是否是第一次启动应用
    //返回一个和defaultName关联的bool值，如果不存在defaultName的话返回NO
    if (![UserDefaultsUtil readEveryLaunchValue:everyLaunchKey]) {

        [UserDefaultsUtil writeEveryLaunchWithKey:everyLaunchKey];

        [UserDefaultsUtil writeFirstLaunchValue:YES];
    }

    //第一次启动则加载前导页
    if ([UserDefaultsUtil readFirstLaunchValue]) {

        [UserDefaultsUtil writeFirstLaunchValue:NO];

        IntroduceViewController *introduceVC = [[IntroduceViewController alloc] init];
        introduceVC.delegate = self;
        [self windowAddRootViewController:introduceVC];

    } else {
        [self windowAddTabBarViewController];
    }
}

//加载完前导页后加载open页
- (void)didFinishedLoadIntroduceViewController:(IntroduceViewController *)introduceVC {
    // TabBarViewController
    [self windowAddTabBarViewController];
}

// Window到TabBarViewContorller
- (void)windowAddTabBarViewController {
    _tabBarVC = [[XYTabBarViewController alloc] init];
    _tabBarVC.delegate = self;
    [self windowAddRootViewController:_tabBarVC];
    [self creatTheUpdateHttpRequest];
}

// Window到RootViewController
- (void)windowAddRootViewController:(UIViewController *)viewController {

    self.window.rootViewController = viewController;

    if ([UserDefaultsUtil getUser].gestureUnlock.length > 3) {
        [self checkTheGesure];
    }
}

#pragma mark-- UITabBarControllerDelegate delegate method

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
        [UMengAnalyticsUtil event:EVENT_FINANCE];
    } else if (tabBarController.selectedIndex == 1) {
        [UMengAnalyticsUtil event:EVENT_SAFE_SAFE];
    } else if (tabBarController.selectedIndex == 2) {
        [UMengAnalyticsUtil event:EVENT_MY];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    return YES;
}

#pragma mark -  友盟社会化分享

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    return YES;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

//信闪贷回调xyb schem
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {

    if (!url) {
        return NO;
    }

    if ([url.scheme isEqualToString:@"xyb"]) {
        NSString *urlStr = [url absoluteString]; //获取参数
    }
    return YES;
}

#pragma mark - 当前版本

- (void)creatTheUpdateHttpRequest {
    [VersionUpdateHttpRequest getRequest];
}

#pragma mark - 打印deviceToken

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册

    NSString *deviceTokenStr = [[[[deviceToken description]
        stringByReplacingOccurrencesOfString:@"<"
                                  withString:@""]
        stringByReplacingOccurrencesOfString:@">"
                                  withString:@""]
        stringByReplacingOccurrencesOfString:@" "
                                  withString:@""];

    NSString *deviceTokenStr2 = [StrUtil stringByReplacingOccurrencesOfString:[deviceToken description]];
    NSLog(@"[deviceToken description] = %@", [deviceToken description]);
    NSLog(@"deviceTokenStr2 = %@", deviceTokenStr2);


    [UserDefaultsUtil writeDeviceTokenValue:deviceTokenStr];
}

#pragma mark - 友盟消息推送

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessageUtil application:application didReceiveRemoteNotification:userInfo appDelegate:self];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Regist fail%@", error);
}

//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [UMessageUtil userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler appDelegate:self];
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [UMessageUtil userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler appDelegate:self];
}


@end
