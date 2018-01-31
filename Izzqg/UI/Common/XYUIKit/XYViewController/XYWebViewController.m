//
//  XYWebViewController.m
//  Ixyb
//
//  Created by wangjianimac on 16/11/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AllianceApplyViewController.h"
#import "AllianceViewController.h"
#import "ChargeViewController.h"
#import "CGAccountViewController.h"
#import "EarnBonusCodeViewController.h"
#import "LoginFlowViewController.h"
#import "MoreProductViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "RequestURL.h"
#import "SafeWebViewController.h"
#import "Utility.h"
#import "AddressViewController.h"
#import "XYWebViewController.h"
#import "ScoreStoreWebViewController.h"
#import "DrawWebViewController.h"
#import "ShakeGameViewController.h"
#import "AboutUsViewController.h"

@interface XYWebViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate,AddressViewControllerDelegate>

@property (nonatomic, strong) NJKWebViewProgress *progress;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) NSString * titleStr;

@end

@implementation XYWebViewController

- (id)initWithTitle:(NSString *)title webUrlString:(NSString *)webUrlString {
    self = [super init];
    if (self) {
        self.navItem.title = title;
        self.urlStr = webUrlString;
        self.titleStr = title;
    }
    return self;
}

-(void)setNav {
    
     _backBtn = [[UIButton alloc] init];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"back_ed"] forState:UIControlStateHighlighted];
    [_backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.userInteractionEnabled = YES;
    [self.navBar addSubview:_backBtn];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(self.navBar.mas_left).offset(Margin_Left);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
    
    self.closeBtn = [[UIButton alloc] init];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"close_ed"] forState:UIControlStateHighlighted];
    [self.closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn.hidden = YES;
    self.closeBtn.userInteractionEnabled = YES;
    [self.navBar addSubview:self.closeBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(_backBtn.mas_right).offset(Margin_Left);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
}

- (void)clickBackBtn:(id)sender {
    if ([self.titleStr isEqualToString:XYBString(@"str_home_sign", @"签到")]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        if ([self.webView canGoBack]) {
            self.closeBtn.hidden = NO;
            [self.webView goBack];
            return;
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)clickCloseBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    self.view.backgroundColor = COLOR_BG;
    self.view.userInteractionEnabled = YES;
    [self createTheWebView];
    //    [self createNoDataView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccessNotification" object:nil];
}


- (void)createTheWebView {
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = COLOR_COMMON_WHITE;
    self.webView.opaque = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scalesPageToFit = NO;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    _progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progress;
    _progress.webViewProxyDelegate = self;
    _progress.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.backgroundColor = COLOR_COMMON_CLEAR;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navBar addSubview:_progressView];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //设置标题
    NSString *documentTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titleStr = documentTitle;
    
    if ([self.titleStr isEqualToString:@"处理结果"]) {
        _backBtn.hidden = YES;
    }else
    {
        _backBtn.hidden = NO;
    }
    
    self.navItem.title = [NSString stringWithFormat:@"%@", documentTitle];
}

//网页中的每一个请求都会被触发
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    //跳转到首页
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/HomeView"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    
    //跳转到定期宝列表页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/DqbProductView"])
    {
        MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
        moreProductVC.hidesBottomBarWhenPushed = YES;
        moreProductVC.type = ClickTheDQB;
        [self.navigationController pushViewController:moreProductVC animated:YES];
        return NO;
    }
    
    //跳转到信投宝列表页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/XtbProductView"])
    {
        MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
        moreProductVC.hidesBottomBarWhenPushed = YES;
        moreProductVC.type = ClickTheXTB;
        [self.navigationController pushViewController:moreProductVC animated:YES];
        return NO;
    }
    
    //跳转到债权转让列表页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/ZqzrProductView"])
    {
        MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
        moreProductVC.hidesBottomBarWhenPushed = YES;
        moreProductVC.type = ClickTheZQZR;
        [self.navigationController pushViewController:moreProductVC animated:YES];
        return NO;
    }
    
    //信用宝联盟申请页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/UnionApplyView"])
    {
        
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
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/UnionInviteFriendView"])
    {
        
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
                
            }else if ([[UserDefaultsUtil getUser].bonusState intValue] == 1) { //审核中
                EarnBonusCodeViewController *earnBonusCodeViewController = [[EarnBonusCodeViewController alloc] init];
                earnBonusCodeViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:earnBonusCodeViewController animated:YES];
                
            } else if([[UserDefaultsUtil getUser].bonusState intValue] == 2) { //已加入
                AllianceViewController *allianceVC = [[AllianceViewController alloc] init];
                allianceVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:allianceVC animated:YES];
            }
        }
        
        return NO;
    }
    
    //邀请好友
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/InviteFriendView"])
    {
        
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
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/BorrowView"])
    {
        
        self.tabBarController.selectedIndex = 1;
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        return NO;
    }
    
    //积分商城
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/MallView"])
    {
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
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/LotteryView"])
    {
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
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/ShakeView"])
    {
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
    
    //存管落地页 成功按钮响应事件，返回到账户设置页面
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/sh_finish"])
    {
        NSArray *vcArr = self.navigationController.viewControllers;
        
        //照华需要传值说明是存管账户还是借款账户进来的，拿到响应字段后发通知到setviewcontroller页面刷新UI
        
        //通知设置页面，刷新UI
        if (_openType == 1) {
            NSDictionary *dic = @{@"FinanceAccount":@YES};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUI" object:dic userInfo:nil];
        }
        
        if (_openType == 2) {
            NSDictionary *dic = @{@"BorrowAccount":@YES};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUI" object:dic userInfo:nil];
        }
        
        BaseViewController *vc = [vcArr objectAtIndex:vcArr.count - 3];
        [self.navigationController popToViewController:vc animated:YES];
        
        return NO;
    }
    
    //存管落地页 返回按钮响应事件,跳转到输入“姓名”和“身份证”页面
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/sh_fail"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    /*上半部分为王智要求的跳转，下面的跳转为老版本的，暂时未做改动*/
    
    //跳转到活期宝详情页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/HqbProductDetailView"])
    {
        if (![Utility shareInstance].isLogin) {
            LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
            [loginFlowViewController presentWith:self animated:NO completion:nil];
            return NO;
        }

        
        return NO;
    }
    
    //跳转到注册页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/RegisterView"])
    {
        LoginFlowViewController *loginFlowViewController = [[LoginFlowViewController alloc] init];
        [loginFlowViewController presentRegisterWith:self.navigationController animated:NO completion:nil];
        
        return NO;
    }
    
    //跳转到登录页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/LoginView"])
    {
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
        
        return NO;
    }
    
    //跳转充值页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/ChargeView"])
    {
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
        if ([self.titleStr isEqualToString:XYBString(@"str_home_sign", @"签到")]) {
            chargeViewController.fromType =  FromTypeTheHome;
        }
        chargeViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chargeViewController animated:YES];
        
        return NO;
    }
    
    //关于我们
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/AboutUs"])
    {
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
    
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/chooseContacts"])
    {
        //                XsdContactHelper *peoplePicker = [[XsdContactHelper alloc] init];
        //                [peoplePicker showInController:self];
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setEmergContact(%@)", @"1842301123"]];
        return NO;
    }
    
    // 分享
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/SHARE_BAR"])
    {
        
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
    
    // 编辑收货地址
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/receptionAddress"])
    {
        AddressViewController *address = [[AddressViewController alloc] init];
        address.hidesBottomBarWhenPushed = YES;
        address.delegate = self;
        [self.navigationController pushViewController:address animated:YES];
        return NO;
    }
    
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSString *url = [request.URL absoluteString];
        //只是出借合同页面不弹打电话
         if ([self.titleStr isEqualToString:@"出借人服务协议"])
         {
             //拦截链接跳转到货源圈的动态详情
             if ([url rangeOfString:@"tel:"].location != NSNotFound)
             {
                 //跳转到你想跳转的页面
                 return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
            }
        }
    }
    
    return YES;
}

- (void)didFinishedUpdateAddressSuccess:(AddressViewController *)addressViewController {
    [self.webView reload];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code == -1009) {
        [self showPromptTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
    }
}

- (void)chargeSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView reload];
    });
    [self showPromptTip:@"充值成功"];
}

//如果是新手任务页面 从新加载URL
-(void)loadReauestPage
{
    if ([self.titleStr isEqualToString:XYBString(@"str_home_sign", @"签到")]) {
        NSString *requestURL = [RequestURL getNodeJsH5URL:HomePageTaskRequestURL withIsSign:YES];
        NSURLRequest * quest =[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]] ;
        [self.webView loadRequest:quest];
    }
}

/**
 *  重新加载 点击事件
 *
 *  @param sender Button
 */
- (void)reloadData:(id)sender {
    [self.webView reload];
}

@end
