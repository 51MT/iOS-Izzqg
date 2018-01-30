//
//  WebviewViewController.m
//  Ixyb
//
//  Created by wang on 15/8/31.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "WebviewViewController.h"

#import "AddressViewController.h"
#import "AllianceApplyViewController.h"
#import "AllianceViewController.h"
#import "ChargeViewController.h"
#import "EarnBonusCodeViewController.h"
#import "LoginFlowViewController.h"
#import "MoreProductViewController.h"
#import "MyAlertView.h"
#import "RequestURL.h"
#import "SafeWebViewController.h"
#import "UserDetailRealNamesViewController.h"
#import "Utility.h"
#import "UMengAnalyticsUtil.h"
#import "ScoreStoreWebViewController.h"
#import "DrawWebViewController.h"
#import "ShakeGameViewController.h"
#import "AboutUsViewController.h"

@interface WebviewViewController () {
    MBProgressHUD *hud;
}
@property (nonatomic, copy) NSString *strURL;
@property(nonatomic,strong)NSString * titleStr;
@end

@implementation WebviewViewController

- (id)initWithTitle:(NSString *)title webUrlString:(NSString *)webUrlString {
    self = [super init];
    if (self) {
        self.navItem.title = title;
        self.URL = [NSURL URLWithString:webUrlString];
        self.strURL = webUrlString;
        self.titleStr = title;
        //加载本地文件
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"localWeb" ofType:@"html"];
        //self.URL = [NSURL fileURLWithPath:path];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BG;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccessNotification" object:nil];
}
- (void)chargeSuccess {
    [self showPromptTip:@"充值成功"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //设置标题
    NSString *documentTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navItem.title = [NSString stringWithFormat:@"%@", documentTitle];
}

// 网页中的每一个请求都会被触发
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    //跳转到首页
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/HomeView"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    
    //跳转到定期宝列表页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/DqbProductView"]) {
        MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
        moreProductVC.hidesBottomBarWhenPushed = YES;
        moreProductVC.type = ClickTheDQB;
        [self.navigationController pushViewController:moreProductVC animated:YES];
        return NO;
    }
    
    //跳转到信投宝列表页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/XtbProductView"]) {
        MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
        moreProductVC.hidesBottomBarWhenPushed = YES;
        moreProductVC.type = ClickTheXTB;
        [self.navigationController pushViewController:moreProductVC animated:YES];
        return NO;
    }
    
    //跳转到债权转让列表页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/ZqzrProductView"]) {
        MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
        moreProductVC.hidesBottomBarWhenPushed = YES;
        moreProductVC.type = ClickTheZQZR;
        [self.navigationController pushViewController:moreProductVC animated:YES];
        return NO;
    }
    
    //信用宝联盟申请页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/UnionApplyView"]) {
        
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:nil];
            return NO;
        }
        
        if ([UserDefaultsUtil getUser].bonusState) {
            if ([[UserDefaultsUtil getUser].bonusState intValue] != 2) {
                AllianceApplyViewController *allianceApplyVC = [[AllianceApplyViewController alloc] init];
                allianceApplyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:allianceApplyVC animated:YES];
            } else {
                AllianceViewController *allianceVC = [[AllianceViewController alloc] init];
                allianceVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:allianceVC animated:YES];
            }
        }
        
        return NO;
    }
    
    //针对联盟用户的邀请好友活动:0.未加入，跳入联盟申请页； 1.审核中，跳转到邀请好友页面；2.已加入，跳转到我的联盟
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/UnionInviteFriendView"]){
        
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:nil];
            return NO;
        }
        
        if ([UserDefaultsUtil getUser].bonusState) {
            if ([[UserDefaultsUtil getUser].bonusState intValue] == 0) {       //未加入
                AllianceApplyViewController *allianceApplyVC = [[AllianceApplyViewController alloc] init];
                allianceApplyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:allianceApplyVC animated:YES];
                return NO;
            }else if ([[UserDefaultsUtil getUser].bonusState intValue] == 1) { //审核中
                EarnBonusCodeViewController *earnBonusCodeViewController = [[EarnBonusCodeViewController alloc] init];
                earnBonusCodeViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:earnBonusCodeViewController animated:YES];
                return NO;
            } else if([[UserDefaultsUtil getUser].bonusState intValue] == 2) { //已加入
                AllianceViewController *allianceVC = [[AllianceViewController alloc] init];
                allianceVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:allianceVC animated:YES];
                return NO;
            }
        }
        return YES;
    }
    
    //邀请好友
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/InviteFriendView"]){
        
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
                if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                    if (state == LoginFlowStateDoneAndRechare) {
                        
                    } else {
                        [self loadReauestPage];
                    }
                }
            }];
            return NO;
        }
        EarnBonusCodeViewController *earnBonusCodeViewController = [[EarnBonusCodeViewController alloc] init];
        earnBonusCodeViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:earnBonusCodeViewController animated:YES];
        return NO;
    }
    
    //借款首页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/BorrowView"]){
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:nil];
            return NO;
        }
        
        self.tabBarController.selectedIndex = 1;
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        return NO;
    }
    
    //积分商城
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/MallView"]){
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:nil];
            return NO;
        }
        
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Score_Mall_URL withIsSign:YES];
        ScoreStoreWebViewController *scoreStoreWebVC = [[ScoreStoreWebViewController alloc] initWithTitle:XYBString(@"str_jfsc",@"积分商城") webUrlString:urlStr];
        scoreStoreWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scoreStoreWebVC animated:YES];
        return NO;
    }
    
    //积分抽奖
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/LotteryView"]){
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:nil];
            return NO;
        }
        
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Score_Lottery_URL withIsSign:YES];
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&v=%@", [ToolUtil getAppVersion]]]; //增加版本号
        DrawWebViewController *drawWebVC = [[DrawWebViewController alloc] initWithTitle:XYBString(@"str_jfcj",@"积分抽奖") webUrlString:urlStr];
        drawWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:drawWebVC animated:YES];
        return NO;
    }
    
    //摇摇乐
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/ShakeView"]){
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:nil];
            return NO;
        }
        
        [UMengAnalyticsUtil event:EVENT_MY_YYL];
        ShakeGameViewController *shakeGameViewController = [[ShakeGameViewController alloc] init];
        shakeGameViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shakeGameViewController animated:YES];
        return NO;
    }
    
    /*上半部分为王智要求的跳转，下面的跳转为老版本的，暂时未做改动*/
    
    //跳转到活期宝详情页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/HqbProductDetailView"]) {
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:nil];
            return NO;
        }
    
        return NO;
    }
    
    //跳转到注册页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/RegisterView"]) {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentRegisterWith:self.navigationController animated:NO completion:nil];
        return NO;
    }
    
    //跳转到登录页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/LoginView"]) {
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
                
                if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                    if (state == LoginFlowStateDoneAndRechare) {
                        
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }];
        }
    }
    
    //跳转充值页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/ChargeView"]) {
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:^(LoginFlowState state) {
                if (state != LoginFlowStateCancel) { //不是取消登录（注册并充值、登录完成、注册完成、重置密码完成）
                    if (state == LoginFlowStateDoneAndRechare) {
                        
                    } else {
                        [self loadReauestPage];
                    }
                }
            }];
            return NO;
        }
        ChargeViewController *chargeViewController = [[ChargeViewController alloc] initWithIdetifer:NO];
        chargeViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chargeViewController animated:YES];
        return NO;
    }
    
    //关于我们
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/AboutUs"]) {
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:nil];
            return NO;
        }
        AboutUsViewController *about = [[AboutUsViewController alloc] init];
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
        return NO;
    }
    
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/chooseContacts"]) {
        //                XsdContactHelper *peoplePicker = [[XsdContactHelper alloc] init];
        //                [peoplePicker showInController:self];
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setEmergContact(%@)", @"1842301123"]];
        return NO;
    }
    
    // 分享
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/SHARE_BAR"]) {
        
        //调用share()方法获取到shareStr;shareStr的参数形式：分享路径;标题;图片url（;符号是为了区分分享路径、分享标题、分享图片）
        NSString *shareStr = [webView stringByEvaluatingJavaScriptFromString:@"share()"];
        NSArray *strArray = [shareStr componentsSeparatedByString:@";"];
        
        //分享路径
        NSString *shareUrl = [strArray objectAtIndex:0];
        //分享标题
        NSString *shareTitle = [strArray objectAtIndex:1];
        //分享内容
        NSString *contentStr = [strArray objectAtIndex:2];
        //分享图片的url
        NSString *shareImgUrl = [strArray objectAtIndex:3];
        UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgUrl]]];
        
        //调用分享方法
        [UMShareUtil shareUrl:shareUrl title:shareTitle content:contentStr image:shareImage controller:self];
        return NO;
    }
    
    return YES;
}

//如果是新手任务页面 从新加载URL
-(void)loadReauestPage {
    if ([self.titleStr isEqualToString:XYBString(@"str_home_sign", @"签到")]) {
        NSString *requestURL = [RequestURL getNodeJsH5URL:HomePageTaskRequestURL withIsSign:YES];
        NSURLRequest * quest =[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]] ;
        [self.webView loadRequest:quest];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error.code == -1009) {
        [self showPromptTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
    }
}

@end
