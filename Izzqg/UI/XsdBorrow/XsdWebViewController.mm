//
//  XsdWebViewController.m
//  Ixyb
//
//  Created by dengjian on 16/12/22.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XsdWebViewController.h"
#import "Utility.h"

@interface XsdWebViewController () <UINavigationControllerDelegate>

@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation XsdWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
}

-(void)setNav {
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

#pragma mark - 导航栏点击事件

- (void)clickBackBtn:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        self.closeBtn.hidden = NO;
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCloseBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - webView Delegate

//网页中的每一个请求都会被触发
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //设置标题
    NSString *documentTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navItem.title = [NSString stringWithFormat:@"%@", documentTitle];
}

-(void)webViewReloadDataWithUrlStr:(NSString *)urlStr {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

@end
