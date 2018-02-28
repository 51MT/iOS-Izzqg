//
//  UMessageUtil.m
//  Ixyb
//
//  Created by wangjianimac on 2017/5/8.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "UMessageUtil.h"
#import "UMNSAlertView.h"
#import "Utility.h"
//#import "LoginFlowViewController.h"

static UMessageUtil *shareUMessageUtil = nil;

@interface UMessageUtil () <UNUserNotificationCenterDelegate>

@end

@implementation UMessageUtil

//单例模式实现方法
+ (UMessageUtil *)shareUMessageUtil {
    @synchronized(self) {
        if (shareUMessageUtil == nil) {
            shareUMessageUtil = [[UMessageUtil alloc] init]; //写法意义相同:sharedConstant = [[self alloc] init];
        }
        return shareUMessageUtil;
    }
}


/**
 友盟消息推送 进行注册
 */
+ (void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions httpsenable:(BOOL)value {

    //设置 AppKey 及 LaunchOptions httpsenable是否开启HTTPS
    [UMessage startWithAppkey:appKey launchOptions:launchOptions httpsenable:YES];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = [UMessageUtil shareUMessageUtil];
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue] >= 10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    } else {
        [UMessage registerForRemoteNotifications:categories];
    }
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    [UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    //for log
    [UMessage setLogEnabled:YES];
}


/**
 收到了推送消息，解析消息并弹窗显示

 @param application UIApplication
 @param userInfo 收到的消息
 @param delegate AppDelegate单例
 */
+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo appDelegate:(AppDelegate *)delegate {
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //自定义弹窗，应用内收到消息弹窗
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        UMNSAlertView *alertView = [[UMNSAlertView alloc] init];
        alertView.userInfoDic = userInfo;
        NSDictionary *dict = @{ @"title" : [userInfo objectForKey:@"title"],
                                @"content" : [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] };
        alertView.dataSource = dict;
        
//        alertView.block = ^() {
//            if (![Utility shareInstance].isLogin) {
//                LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
//                [loginFlowViewController presentWith:delegate.window.rootViewController animated:NO completion:^(LoginFlowState state) {
//                    if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
//                        delegate.tabBarVC.selectedIndex = 0;
//                        MessageCategoryViewController *MessageCategoryVC = [[MessageCategoryViewController alloc] init];
//                        MessageCategoryVC.hidesBottomBarWhenPushed = YES;
//                        [delegate.tabBarVC.selectedViewController pushViewController:MessageCategoryVC
//                                                                        animated:YES];
//                    }
//                }];
//            } else {
//                delegate.tabBarVC.selectedIndex = 0;
//                MessageCategoryViewController *MessageCategoryVC = [[MessageCategoryViewController alloc] init];
//                MessageCategoryVC.hidesBottomBarWhenPushed = YES;
//                [delegate.tabBarVC.selectedViewController pushViewController:MessageCategoryVC
//                                                                animated:YES];
//            }
//        };
        [alertView show];
    }
}

/**
 iOS10新增：处理前台收到通知的代理方法

 @param center 用户通知中心
 @param response 收到的消息响应
 @param completionHandler 收到消息后的回调block
 @param delegate AppDelegate单例
 */
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler appDelegate:(AppDelegate *)delegate {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        UMNSAlertView *alertView = [[UMNSAlertView alloc] init];
        alertView.userInfoDic = userInfo;
        NSDictionary *dict = @{ @"title" : [userInfo objectForKey:@"title"],
                                @"content" : [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] };
        alertView.dataSource = dict;
        
//        alertView.block = ^() {
//            if (![Utility shareInstance].isLogin) {
//                LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
//                [loginFlowViewController presentWith:delegate.window.rootViewController animated:NO completion:^(LoginFlowState state) {
//                    if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
//                        delegate.tabBarVC.selectedIndex = 0;
//                        MessageCategoryViewController *MessageCategoryVC = [[MessageCategoryViewController alloc] init];
//                        MessageCategoryVC.hidesBottomBarWhenPushed = YES;
//                        [delegate.tabBarVC.selectedViewController pushViewController:MessageCategoryVC
//                                                                        animated:YES];
//                    }
//                }];
//            } else {
//                delegate.tabBarVC.selectedIndex = 0;
//                MessageCategoryViewController *MessageCategoryVC = [[MessageCategoryViewController alloc] init];
//                MessageCategoryVC.hidesBottomBarWhenPushed = YES;
//                [delegate.tabBarVC.selectedViewController pushViewController:MessageCategoryVC
//                                                                animated:YES];
//            }
//        };
        [alertView show];
        
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
}

/**
 iOS10新增：处理后台点击通知的代理方法

 @param center 用户通知中心
 @param response 收到的消息响应
 @param completionHandler 收到消息后的回调block
 @param delegate AppDelegate单例
 */
+ (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler appDelegate:(AppDelegate *)delegate {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //应用处于后台时的远程推送接受
//        if (![Utility shareInstance].isLogin) {
//            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
//            [loginFlowViewController presentWith:delegate.window.rootViewController animated:NO completion:^(LoginFlowState state) {
//                if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
//                    delegate.tabBarVC.selectedIndex = 0;
//                    MessageCategoryViewController *MessageCategoryVC = [[MessageCategoryViewController alloc] init];
//                    MessageCategoryVC.hidesBottomBarWhenPushed = YES;
//                    [delegate.tabBarVC.selectedViewController pushViewController:MessageCategoryVC
//                                                                    animated:YES];
//                }
//            }];
//        } else {
//            delegate.tabBarVC.selectedIndex = 0;
//            MessageCategoryViewController *MessageCategoryVC = [[MessageCategoryViewController alloc] init];
//            MessageCategoryVC.hidesBottomBarWhenPushed = YES;
//            [delegate.tabBarVC.selectedViewController pushViewController:MessageCategoryVC
//                                                            animated:YES];
//        }
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
//
//    }else{
        //应用处于后台时的本地推送接受
//    }
    
}

@end
