//
//  VipPrivilegeNoteWebViewController.m
//  Ixyb
//
//  Created by wang on 16/8/4.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AddressViewController.h"
#import "Utility.h"
#import "VipPrivilegeNoteWebViewController.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "UMengAnalyticsUtil.h"

@interface VipPrivilegeNoteWebViewController () {
    MBProgressHUD *hud;
}
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation VipPrivilegeNoteWebViewController

- (void)setNav {

    self.navItem.title = XYBString(@"str_init_H5_title", @"");

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
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15; //这个数值可以根据情况自由变化

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 60.0f, 40.0f);
    [button setTitle:XYBString(@"str_notes", @"备注") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = TEXT_FONT_14;
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

/**
 *  备注
 *
 *  @param sender
 */
- (void)clickRightBtn:(id)sender {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Vip_Remark_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"str_notes", @"备注");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
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

- (id)initWithTitle:(NSString *)title webUrlString:(NSString *)webUrlString {
    self = [super init];
    if (self) {
        self.navItem.title = title;
        self.URL = [NSURL URLWithString:webUrlString];
    }
    return self;
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

    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error.code == -1009) {
        [self showPromptTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
    }
}

@end
