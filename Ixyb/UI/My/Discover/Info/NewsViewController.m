//
//  NewsViewController.m
//  Ixyb
//
//  Created by dengjian on 16/8/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "NewsViewController.h"

#import "AddressViewController.h"
#import "Utility.h"
#import "UMengAnalyticsUtil.h"

@interface NewsViewController () <AddressViewControllerDelegate> {
    MBProgressHUD *hud;
}

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) BOOL firstCome;
@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSString *strURL;
@end

@implementation NewsViewController

//导航栏
- (void)setNav {

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

- (void)setNavRight {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -4; //这个数值可以根据情况自由变化

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"share_ed"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0.0f, 0.0f, 22.0f, 22.0f);
    [button addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navItem.rightBarButtonItems = @[ negativeSpacer, rightButtonItem ];
}

- (void)clickRightBtn:(id)sender {
    NSString *documentConent = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [UMShareUtil shareUrl:self.strURL title:@"信用宝新闻" content:documentConent image:[UIImage imageNamed:@"barcode_logo"] controller:self];
}

- (void)clickTheBackBtn:(id)sender {

    if ([self.webView canGoBack]) {
        self.closeBtn.hidden = NO;
        [self.webView goBack];
        self.closeBtn.hidden = NO;
        _firstCome = NO;

        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCloseBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        self.string = title;
        self.navItem.title = title;
        self.URL = [NSURL URLWithString:webUrlString];
        self.strURL = webUrlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *documentTitle;
    NSString *documentURL = [self.webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    if (_firstCome) {
        //设置标题
        _firstCome = NO;
        documentTitle = @"新闻详情";
        [self setNavRight];
        self.strURL = documentURL;
    } else {
        _firstCome = YES;
        if ([self.string isEqualToString:@"新闻详情"]) {
            documentTitle = self.string;
            self.strURL = documentURL;
            [self setNavRight];
        } else {
            documentTitle = @"新闻动态";
            self.navigationItem.rightBarButtonItems = nil;
        }
    }
    //设置标题
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
