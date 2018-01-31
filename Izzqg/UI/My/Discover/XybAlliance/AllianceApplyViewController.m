//
//  AllianceApplyViewController.m
//  Ixyb
//
//  Created by wang on 15/8/29.
//  Copyright (c) 2015年 xyb. All rights reserved.
//

#import "AllianceApplyViewController.h"

#import "RequestURL.h"
#import "SubmitApplyViewController.h"
#import "Utility.h"
#import "UMengAnalyticsUtil.h"

@interface AllianceApplyViewController () {
    UIButton *applyBtn;
}
@end

@implementation AllianceApplyViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (applyBtn) {
        [self refreshBtnState];
    }
    [UMengAnalyticsUtil beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UMengAnalyticsUtil endLogPageView:NSStringFromClass([self class])];
}

- (void)setNav {

    self.navItem.title = XYBString(@"str_xyb_union", @"信用宝联盟");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
}

- (void)clickBackBtn:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];

    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = NO;
    webView.backgroundColor = COLOR_COMMON_WHITE;
    webView.opaque = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:webView];

    NSString *urlStr = [RequestURL getNodeJsH5URL:App_AllianceRules_URL withIsSign:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];

    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
    }];

    [self creatFooterView];
}

- (void)creatFooterView {

    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    btnView.backgroundColor = COLOR_COMMON_WHITE;
    [self.view addSubview:btnView];

    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@70);
    }];

    applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyBtn addTarget:self action:@selector(clickTheUnionButton:) forControlEvents:UIControlEventTouchUpInside];
    [applyBtn setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    applyBtn.backgroundColor = COLOR_MAIN;
    [applyBtn setBackgroundImage:[ColorUtil imageWithColor:COLOR_HIGHTBULE_BUTTON] forState:UIControlStateHighlighted];
    [applyBtn.layer setMasksToBounds:YES];
    [applyBtn.layer setCornerRadius:4.0];
    [btnView addSubview:applyBtn];

    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnView.mas_left).offset(10);
        make.top.equalTo(@10);
        make.height.equalTo(@50);
        make.width.equalTo(@(MainScreenWidth - 20));
    }];

    UIImageView *verlineImage = [[UIImageView alloc] init];
    verlineImage.image = [UIImage imageNamed:@"onePoint"];

    [btnView addSubview:verlineImage];
    [verlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(btnView);
        make.top.equalTo(btnView.mas_top).offset(0);
        make.height.equalTo(@1);
    }];

    [self refreshBtnState];
}

- (void)refreshBtnState {
    
    if ([UserDefaultsUtil getUser].bonusState) {
        
        if ([[UserDefaultsUtil getUser].bonusState intValue] == 0) {
            
            [applyBtn setTitle:XYBString(@"str_union_state", @"申请加入联盟") forState:UIControlStateNormal];

        } else if ([[UserDefaultsUtil getUser].bonusState intValue] == 1) {
            
            [applyBtn setTitle:XYBString(@"str_bonus_state", @"审核中") forState:UIControlStateNormal];
            applyBtn.userInteractionEnabled = NO;
            applyBtn.backgroundColor = COLOR_MYUNION_APPLY;
            
        } else if ([[UserDefaultsUtil getUser].bonusState intValue] == 2) {
            
            [applyBtn setTitle:XYBString(@"str_bonus_sucess", @"审核已通过") forState:UIControlStateNormal];
            applyBtn.backgroundColor = COLOR_MYUNION_APPLY;
            applyBtn.userInteractionEnabled = NO;
        }
    }
}

- (void)clickTheUnionButton:(UIButton *)btn {

    SubmitApplyViewController *submitApplyViewController = [[SubmitApplyViewController alloc] init];
    [self.navigationController pushViewController:submitApplyViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
