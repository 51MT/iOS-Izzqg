//
//  LoginFlowViewController.h
//  Ixyb
//
//  Created by dengjian on 11/18/15.
//  Copyright © 2015 xyb. All rights reserved.
//

//其他要交接的技术

/*
 
 1. 所有viewcontroller的实现,我一般都采用先布局UI,然后刷新UI的方式. 诸如在viewDidLoad中实现initUI, 把各种view添加到view上. 之后在网络数据回来之后,更新view
 2. 公共部分的UI, SelectItemAlertView, XYBKit,common 中的东西,设计的思路是想在业务层提取出一些公共的UI部分.修改的时候注意适应业务.新页面有这个设计的,可以直接使用.
 3. Utiliy 中新增了部分工具函数,用于处理常用的UI修改.
 4. 字符串处理的技术,用了一个python脚本,把.m文件中的字符串提取出来,检测错误.再手动更新到plist字符串文件中.
 5. 登录流的东西 LoinFlow, 基本设计思路是把整个登录过程相关的文件统一到LoginFlowViewController这一个出入口来管理.每个被管理的页面都挂上了LoginFlowDelegate

 */

// 登录流程vc
// 可以呼出登录,呼出注册 flowType 做区分
// 完成/取消后从completion出, 根据LoginFlowState状态做相应的操作.
//

#import "HiddenNavBarBaseViewController.h"
#import "XYNavigationController.h"

typedef enum {
    LoginFlowStateDone,
    LoginFlowStateDoneUnIdentityAuth,
    LoginFlowStateCancel,
    LoginFlowStateDoneAndRechare,
} LoginFlowState;

typedef void (^LoginFlowCompletion)(LoginFlowState state);

@protocol LoginFlowDelegate <NSObject>

- (void)loginFlowDidFinish:(LoginFlowState)state;
- (NSInteger)flowType;

@end

@interface LoginFlowViewController : XYNavigationController

- (void)presentWith:(UIViewController *)viewController animated:(BOOL)animated completion:(LoginFlowCompletion)completion;
- (void)presentRegisterWith:(UIViewController *)viewController animated:(BOOL)animated completion:(LoginFlowCompletion)completion;

@end
