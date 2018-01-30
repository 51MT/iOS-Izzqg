//
//  ActivityWebViewController.m
//  Ixyb
//
//  Created by wang on 16/10/24.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ActivityWebViewController.h"
#import "AddressViewController.h"
#import "AllianceApplyViewController.h"
#import "AllianceViewController.h"
#import "ChargeViewController.h"
#import "EarnBonusCodeViewController.h"
#import "LoginFlowViewController.h"
#import "MoreProductViewController.h"
#import "MyAlertView.h"
#import "RequestURL.h"
#import "UserDetailRealNamesViewController.h"
#import "Utility.h"
#import "UMengAnalyticsUtil.h"
#import "XsdViewController.h"
#import "ScoreStoreWebViewController.h"
#import "DrawWebViewController.h"
#import "ShakeGameViewController.h"


@interface ActivityWebViewController () {
    MBProgressHUD *hud;
}
@property (nonatomic, strong) UIButton *closeBtn;
@property(nonatomic,strong)NSString * titleStr;
@end

@implementation ActivityWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeSuccess) name:@"chargeSuccessNotification" object:nil];
}
- (void)setNav {

    self.title = XYBString(@"str_init_H5_title", @"");

    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_ed"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(clickTheBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.userInteractionEnabled = YES;
    [self.navBar addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.equalTo(backBtn.mas_right).offset(Margin_Left);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
}

- (void)clickTheBackBtn:(id)sender {

    if ([self.webView canGoBack]) {
        [self.webView goBack];
        self.closeBtn.hidden = NO;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCloseBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
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
    //根据标题设置通知
    if ([documentTitle isEqualToString:@"APP分享"]) {
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(clickInvestmentRefreshButton)
                   name:@"reloadData"
                 object:nil]; //成功出借后刷新页面
    }
}

- (void)clickInvestmentRefreshButton {
    [self.webView reload];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error.code == -1009) {
        [self showPromptTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
    }
}

@end
