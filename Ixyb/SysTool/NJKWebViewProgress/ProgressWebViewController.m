//
//  ProgressWebViewController.m
//  Ixyb
//
//  Created by wang on 15/8/31.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "ProgressWebViewController.h"

#import "Utility.h"
#import "RequestURL.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

CGFloat const HZProgressBarHeight = 2.5;
NSInteger const HZProgresstagId = 222122323;

@interface ProgressWebViewController () <UIPopoverControllerDelegate, UIActionSheetDelegate, NJKWebViewProgressDelegate> {
    NJKWebViewProgressView *_progressView;
}

@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@end

@implementation ProgressWebViewController

-(instancetype)init {
    self = [super init];
    if (self) {
     
    }
    return self;
}

- (void)setNav {
    
    [self.view bringSubviewToFront:self.navBar];
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)load {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    [self.webView loadRequest:request];
}

- (void)reload {
    [self load];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];

    self.view.backgroundColor = COLOR_COMMON_WHITE;
    self.view.userInteractionEnabled = YES;

    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = NO;
    self.webView.delegate = self;
    self.webView.backgroundColor = COLOR_COMMON_WHITE;
    self.webView.opaque = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.webView];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];


    [self initProgressView];
    [self load];
}


-(void)initProgressView {
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.backgroundColor = COLOR_COMMON_CLEAR;
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
