//
//  XYWebViewController.m
//  Ixyb
//
//  Created by wangjianimac on 16/11/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "RequestURL.h"
#import "Utility.h"
#import "XYWebViewController.h"


@interface XYWebViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate>

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
    _backBtn.hidden = YES;
    _backBtn.userInteractionEnabled = YES;
    [self.navBar addSubview:_backBtn];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(self.navBar.mas_left).offset(Margin_Left);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
    
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close_ed"] forState:UIControlStateHighlighted];
    [_closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.hidden = YES;
    _closeBtn.userInteractionEnabled = YES;
    [self.navBar addSubview:_closeBtn];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.left.equalTo(_backBtn.mas_right).offset(Margin_Left);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
}

- (void)clickBackBtn:(id)sender {
    
    if ([self.webView canGoBack]) {
        self.closeBtn.hidden = NO;
        [self.webView goBack];
        return;
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
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
    
    if (![self.webView canGoBack]) {
        _backBtn.hidden = YES;
    }else{
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
//        MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
//        moreProductVC.hidesBottomBarWhenPushed = YES;
//        moreProductVC.type = ClickTheDQB;
//        [self.navigationController pushViewController:moreProductVC animated:YES];
        return NO;
    }
    
    //跳转到信投宝列表页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/XtbProductView"])
    {
//        MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
//        moreProductVC.hidesBottomBarWhenPushed = YES;
//        moreProductVC.type = ClickTheXTB;
//        [self.navigationController pushViewController:moreProductVC animated:YES];
        return NO;
    }
    
    //跳转到债权转让列表页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/ZqzrProductView"])
    {
//        MoreProductViewController *moreProductVC = [[MoreProductViewController alloc] init];
//        moreProductVC.hidesBottomBarWhenPushed = YES;
//        moreProductVC.type = ClickTheZQZR;
//        [self.navigationController pushViewController:moreProductVC animated:YES];
        return NO;
    }
    
    
    //针对联盟用户的邀请好友活动:0.未加入，跳入联盟申请页； 1.审核中，跳转到邀请好友页面；2.已加入，跳转到我的联盟
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/UnionInviteFriendView"])
    {
        
        return NO;
    }
    
    //邀请好友
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/InviteFriendView"])
    {
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
        return NO;
    }
    
    //积分抽奖
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/LotteryView"])
    {
        if (![Utility shareInstance].isLogin) {
            return NO;
        }
        
        NSString *urlStr = [RequestURL getNodeJsH5URL:App_Score_Lottery_URL withIsSign:YES];
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&v=%@", [ToolUtil getAppVersion]]]; //增加版本号
        return NO;
    }
    
    //摇摇乐
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/ShakeView"])
    {
        if (![Utility shareInstance].isLogin) {

            return NO;
        }
        
        [UMengAnalyticsUtil event:EVENT_MY_YYL];
        
        return NO;
    }
    
    //存管落地页 成功按钮响应事件，返回到账户设置页面
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/sh_finish"])
    {
        NSArray *vcArr = self.navigationController.viewControllers;
        
        
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
            return NO;
        }

        
        return NO;
    }
    
    //跳转到注册页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/RegisterView"])
    {
        return NO;
    }
    
    //跳转到登录页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/LoginView"])
    {
        if (![Utility shareInstance].isLogin) {
        }
        
        return NO;
    }
    
    //跳转充值页
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/ChargeView"])
    {
        if (![Utility shareInstance].isLogin) {
            return NO;
        }
        return NO;
    }
    
    //关于我们
    else if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/AboutUs"])
    {
        if (![Utility shareInstance].isLogin) {

            return NO;
        }
        
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

/**
 *  重新加载 点击事件
 *
 *  @param sender Button
 */
- (void)reloadData:(id)sender {
    [self.webView reload];
}

@end
