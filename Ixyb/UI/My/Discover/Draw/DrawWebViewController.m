//
//  DrawWebViewController.m
//  Ixyb
//
//  Created by dengjian on 16/8/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "AddressViewController.h"
#import "DrawWebViewController.h"
#import "PrizeAddressController.h"
#import "Utility.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "UMengAnalyticsUtil.h"

@interface DrawWebViewController () <AddressViewControllerDelegate, PrizeAddressViewControllerDelegate> {
    MBProgressHUD *hud;
}

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *explainBtn;

@end

@implementation DrawWebViewController

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
    [self setRight];
}
- (void)setRight {
    

    _explainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_explainBtn setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
    [_explainBtn setImage:[UIImage imageNamed:@"question_mark_ed"] forState:UIControlStateHighlighted];
    [_explainBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _explainBtn.titleLabel.font = TEXT_FONT_14;
    [_explainBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:_explainBtn];
    
    [_explainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.right.equalTo(self.navBar.mas_right).offset(-Margin_Right);
        make.centerY.equalTo(self.navBar.mas_centerY);
    }];
}

/**
 *  积分抽奖说明
 *
 *  @param sender
 */
- (void)clickRightBtn:(id)sender {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Lottery_Explain_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"string_xyb_jfcj_sm", @"积分抽奖说明");
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


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //设置标题
    NSString *documentTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navItem.title = [NSString stringWithFormat:@"%@", documentTitle];

    if ([documentTitle isEqualToString:@"积分抽奖"]) {
        _explainBtn.hidden = NO;
    } else {
        _explainBtn.hidden = YES;
    }
}

// 网页中的每一个请求都会被触发
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
 
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/receptionAddress"]) { // 编辑收货地址
        PrizeAddressController *addressVC = [[PrizeAddressController alloc] init];
        addressVC.hidesBottomBarWhenPushed = YES;
        addressVC.delegate = self;
        [self.navigationController pushViewController:addressVC animated:YES];
        return NO;
    }
    
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/skipView/SHARE_BAR"]) { // 分享
        
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    if (error.code == -1009) {
        [self showPromptTip:XYBString(@"string_network_error", @"网络连接不可用，请检查")];
    }
}

- (void)didFinishedUpdateAddressSuccess:(PrizeAddressController *)addressViewController {
    [self.webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
