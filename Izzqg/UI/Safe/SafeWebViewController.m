//
//  SafeWebViewController.m
//  Ixyb
//
//  Created by wang on 15/8/31.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "SafeWebViewController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "UMengAnalyticsUtil.h"

@interface SafeWebViewController () {
    MBProgressHUD *hud;
}
@property (nonatomic, copy) NSString *strURL;
@property (nonatomic, copy) NSString *strTitle;
@property (nonatomic, assign) BOOL firstCome;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation SafeWebViewController

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
        self.strTitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    self.view.backgroundColor = COLOR_COMMON_WHITE;
}

- (void)setNavRight {
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -4; //这个数值可以根据情况自由变化

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"share_ed"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0.0f, 0.0f, 22.0f, 22.0f);
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
}

- (void)setNavRightTitle {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"披露说明" forState:UIControlStateNormal];
    button.titleLabel.font = TEXT_FONT_14;
    [button setTitleColor:COLOR_COMMON_GRAY forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];
    
}


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
}
- (void)clickTheBackBtn:(id)sender {
    if (self.firstCome == YES) {
        if ([self.strTitle isEqualToString:XYBString(@"str_H5_beoverdue_publicity", @"网贷逾期信息公示")]) {
            self.strTitle = XYBString(@"str_H5_beoverdue_publicity", @"网贷逾期信息公示");
        } else {
            self.strTitle =  XYBString(@"str_H5_monthly_report", @"平台运营月度报告");
        }
        self.firstCome = NO;
    }
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        self.closeBtn.hidden = NO;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickTitleBtn:(id)sender 
{
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Safe_Important_URL withIsSign:NO];
    WebviewViewController * webview = [[WebviewViewController alloc] initWithTitle:@"披露说明" webUrlString:urlStr];
    [self.navigationController pushViewController:webview animated:YES];
}

- (void)clickCloseBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn:(id)sender {
    NSString *documentConent;
    if ([self.strTitle isEqualToString:XYBString(@"str_H5_monthly_report", @"平台运营月度报告")] || [self.strTitle isEqualToString:XYBString(@"str_H5_xyb_yb", @"信用宝月报")]) {
        self.strTitle = XYBString(@"str_H5_xyb_yb", @"信用宝月报");  
        documentConent = XYBString(@"str_H5_title", @"快来看看吧，刚出锅的信用宝月度经营数据报告，放心出借请选信用宝。");
    } else {
        documentConent = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    [UMShareUtil shareUrl:self.strURL title:self.strTitle content:documentConent image:[UIImage imageNamed:@"barcode_logo"] controller:self];
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
    NSString *documentURL = [self.webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    self.strURL = documentURL;
    self.navItem.title = [NSString stringWithFormat:@"%@", documentTitle];
    
    if ([self.strTitle isEqualToString:@"重大事项"]) {
        [self setNavRightTitle];
    }
    
    if ([self.strTitle isEqualToString:XYBString(@"str_H5_monthly_report", @"平台运营月度报告")] || [self.strTitle isEqualToString: XYBString(@"str_H5_beoverdue_publicity", @"网贷逾期信息公示")]) {
        if (![self.strTitle isEqualToString:documentTitle]) {
            self.firstCome = YES;
        }
    }
    if (self.firstCome) {
        [self setNavRight];
    } else {
        self.navItem.rightBarButtonItems = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error.code == -1009) {
        [self showPromptTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
