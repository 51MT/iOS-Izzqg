//
//  ScoreStoreWebViewController.m
//  Ixyb
//
//  Created by 董镇华 on 16/7/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AddressViewController.h"
#import "ScoreStoreWebViewController.h"
#import "Utility.h"
#import "WebviewViewController.h"
#import "UMengAnalyticsUtil.h"

@interface ScoreStoreWebViewController () <AddressViewControllerDelegate> {
    MBProgressHUD *hud;
}

@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation ScoreStoreWebViewController

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

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)creatTheHud {

    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
    }
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1.5f];
    hud.labelText = XYBString(@"string_network_error", @"网络连接不可用，请检查");
    hud.square = NO;
    [hud show:YES];
    hud = nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //设置标题
    NSString *documentTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navItem.title = [NSString stringWithFormat:@"%@", documentTitle];
}

// 网页中的每一个请求都会被触发
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/receptionAddress"]) // 编辑收货地址
    {
        AddressViewController *address = [[AddressViewController alloc] init];
        address.hidesBottomBarWhenPushed = YES;
        address.delegate = self;
        [self.navigationController pushViewController:address animated:YES];
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error.code == -1009) {
        [self showPromptTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
    }
}

- (void)didFinishedUpdateAddressSuccess:(AddressViewController *)addressViewController {
    [self.webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
