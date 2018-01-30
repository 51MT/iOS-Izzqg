//
//  ServerErrorView.m
//  Ixyb
//
//  Created by wang on 2017/10/16.
//  Copyright © 2017年 xyb. All rights reserved.
//

#import "ServerErrorView.h"
#import "Utility.h"


@implementation ServerErrorView

- (id)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)show:(void (^)(int state))completion {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    for (UIView * view  in app.window.subviews) {
        if (![view isKindOfClass:[ServerErrorView class]]) {
            [app.window addSubview:self];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(app.window);
            }];
        }else
        {
            [self removeFromSuperview];
        }
    }
}

-(void)initUI
{
    self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
    
    UIView * contentView = [[UIView alloc] init];
    contentView.layer.cornerRadius = Corner_Radius;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.center.equalTo(@0);
        make.height.equalTo(@(323));

    }];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = COLOR_COMMON_WHITE;
    webView.opaque = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scalesPageToFit = NO;
    
    NSString * strURl = [NSString stringWithFormat:@"%@/%@",[Constant sharedConstant].baseUrl,@"error.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURl]];
    
    [webView loadRequest:request];
    [contentView addSubview:webView];
        
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(contentView);
        make.height.equalTo(@(277.5));
    }];
    
    
    UIView *split3View = [[UIView alloc] init];
    split3View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split3View];
    [split3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(webView.mas_bottom);
        make.height.equalTo(@(Line_Height));
        make.left.right.equalTo(contentView);
    }];
    
    UIButton *knowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [knowButton setTitle:XYBString(@"string_i_known", @"我知道了") forState:UIControlStateNormal];
    [knowButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    
    [knowButton addTarget:self action:@selector(clickKnowButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:knowButton];
    [knowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(contentView.mas_bottom);
    }];
}

-(void)clickKnowButton:(id)sender
{
    [self removeFromSuperview];
}

@end
