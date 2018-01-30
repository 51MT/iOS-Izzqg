//
//  VideoSafeViewController.m
//  Ixyb
//
//  Created by wang on 16/10/26.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "VideoSafeViewController.h"

#import "Utility.h"
#import "UMengAnalyticsUtil.h"

@interface VideoSafeViewController () {
    MBProgressHUD *hud;
}
@property (nonatomic, copy) NSString *strURL;

@end

@implementation VideoSafeViewController

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
        self.strURL = webUrlString;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavRight];
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

- (void)clickRightBtn:(id)sender {
    NSString *documentTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *documentContent = @"本期视频内容，银行信用评级专家、“千人计划”国家特聘专家、信用宝创始人涂志云博士不久前受邀出席“网贷神州行”南昌站大型行业交流活动并发表“大数据征信与风险管理”的精彩演讲之后接受专访的精彩视频。";
    [UMShareUtil shareUrl:self.strURL title:documentTitle content:documentContent image:[UIImage imageNamed:@"barcode_logo"] controller:self];
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
    self.navItem.title = documentTitle;
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
