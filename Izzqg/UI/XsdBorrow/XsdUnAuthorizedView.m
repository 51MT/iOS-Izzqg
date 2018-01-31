//
//  XsdUnAuthorizedView.m
//  Ixyb
//
//  Created by wang on 16/2/1.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "XsdUnAuthorizedView.h"

#import "ProductFeaturesView.h"

#import "Utility.h"

@implementation XsdUnAuthorizedView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_CLEAR;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    UIScrollView *mainScroll = [[UIScrollView alloc] init];
    mainScroll.backgroundColor = COLOR_COMMON_CLEAR;
    mainScroll.showsVerticalScrollIndicator = NO;
    [self addSubview:mainScroll];

    [mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(@(MainScreenWidth));
    }];

    UIView *unauthorizedView = [[UIView alloc] init];
    unauthorizedView.backgroundColor = COLOR_COMMON_WHITE;
    [mainScroll addSubview:unauthorizedView];

    [unauthorizedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(mainScroll);
        make.width.equalTo(@(MainScreenWidth));
    }];

    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = COLOR_XSD_UNAUTH;
    topView.layer.masksToBounds = YES;
    topView.layer.cornerRadius = 88;
    [unauthorizedView addSubview:topView];

    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.centerX.equalTo(unauthorizedView.mas_centerX);
        make.width.height.equalTo(@176);
    }];

    UILabel *borrowTitleLab = [[UILabel alloc] init];
    borrowTitleLab.text = XYBString(@"str_xsdborrow_INeedBorrow", @"我要借款");
    borrowTitleLab.textAlignment = NSTextAlignmentCenter;
    borrowTitleLab.textColor = COLOR_MAIN_GREY;
    borrowTitleLab.font = TEXT_FONT_16;
    [topView addSubview:borrowTitleLab];

    [borrowTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top).offset(25);
    }];

    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.textAlignment = NSTextAlignmentCenter;
    moneyLab.font = BORROW_TEXT_FONT_40;
    moneyLab.textColor = COLOR_LINE;
    moneyLab.text = XYBString(@"str_financing_zero", @"0.00");
    [topView addSubview:moneyLab];

    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(2);
        make.right.equalTo(topView.mas_right).offset(-2);
        make.top.equalTo(borrowTitleLab.mas_bottom).offset(1);
    }];

    UIImageView *verlineImage = [[UIImageView alloc] init];
    verlineImage.image = [UIImage imageNamed:@"onePoint"];
    [topView addSubview:verlineImage];

    [verlineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(30);
        make.right.equalTo(topView).offset(-30);
        make.centerY.equalTo(topView.mas_centerY).offset(10);
        make.height.equalTo(@1);
    }];

    UILabel *_returnLab = [[UILabel alloc] init];
    _returnLab.text = XYBString(@"str_financing_wsx", @"未授信");
    _returnLab.textAlignment = NSTextAlignmentCenter;
    _returnLab.textColor = COLOR_STRONG_RED;
    _returnLab.font = TEXT_FONT_18;
    _returnLab.adjustsFontSizeToFitWidth = YES;
    [topView addSubview:_returnLab];

    [_returnLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(verlineImage.mas_bottom).offset(8);
    }];
    //
    UILabel *returnTitleLab = [[UILabel alloc] init];
    returnTitleLab.text = XYBString(@"str_financing_canBorrowAmount", @"可借总额度(元)");
    returnTitleLab.textAlignment = NSTextAlignmentCenter;
    returnTitleLab.textColor = COLOR_LIGHT_GREY;
    returnTitleLab.font = TEXT_FONT_12;
    [topView addSubview:returnTitleLab];

    [returnTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_returnLab);
        make.top.equalTo(_returnLab.mas_bottom).offset(5);
    }];

    // 2.创建 TXHRrettyRuler 对象 并设置代理对象
    TXHRrettyRuler *ruler = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(20, 160, [UIScreen mainScreen].bounds.size.width - 20 * 2, 120)];
    ruler.rulerDeletate = self;
    ruler.userInteractionEnabled = NO;
    [ruler showRulerScrollViewWithCount:100 average:[NSNumber numberWithFloat:0.1] currentValue:0.f scaleValue:500 smallMode:YES];
    //    [ruler showRulerScrollViewWithCount:60 average:[NSNumber numberWithFloat:0.1] currentValue:2.f smallMode:YES];
    [unauthorizedView addSubview:ruler];
    [unauthorizedView sendSubviewToBack:ruler];

    [ruler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(-20);
        make.centerX.equalTo(unauthorizedView.mas_centerX);
        make.width.equalTo(@(MainScreenWidth - 20 * 2));
        make.height.equalTo(@120);
    }];

    UIView *processView = [[UIView alloc] init];
    [unauthorizedView addSubview:processView];

    [processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ruler.mas_bottom).offset(-20);
        make.left.right.equalTo(unauthorizedView);
        make.height.equalTo(@123);
        make.bottom.equalTo(unauthorizedView.mas_bottom);
    }];

    UILabel *processLab = [[UILabel alloc] init];
    processLab.textColor = COLOR_MAIN_GREY;
    processLab.font = TEXT_FONT_16;
    processLab.text = XYBString(@"str_financing_borrowProcess", @"借款流程");
    [processView addSubview:processLab];

    [processLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(processView.mas_centerX);
    }];

    UIImageView *processImage = [[UIImageView alloc] init];
    processImage.image = [UIImage imageNamed:@"processImage"];
    [processView addSubview:processImage];

    [processImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processLab.mas_bottom).offset(Margin_Length);
        make.centerX.equalTo(processView.mas_centerX);
    }];

    UIImageView *verline = [[UIImageView alloc] init];
    verline.image = [UIImage imageNamed:@"onePoint"];
    [processView addSubview:verline];

    [verline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(processView);
        make.top.equalTo(processView.mas_bottom).offset(0.5);
        make.height.equalTo(@1);
    }];

    UIView *authorizedBtnView = [[UIView alloc] init];
    authorizedBtnView.backgroundColor = COLOR_BG;
    [mainScroll addSubview:authorizedBtnView];

    [authorizedBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processView.mas_bottom).offset(20);
        make.left.right.equalTo(unauthorizedView);
        make.height.equalTo(@60);
        make.bottom.equalTo(mainScroll.mas_bottom).offset(-10);
    }];

    UIButton *authorizedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    authorizedBtn.backgroundColor = COLOR_MAIN;
    authorizedBtn.layer.cornerRadius = Corner_Radius;
    authorizedBtn.layer.masksToBounds = YES;
    [authorizedBtn setTitle:XYBString(@"str_financing_authorizedGetCredit", @"授权获取信用额度") forState:UIControlStateNormal];
    [authorizedBtn setTitleColor:COLOR_COMMON_WHITE forState:UIControlStateNormal];
    [authorizedBtn addTarget:self action:@selector(clickTheAuthorizedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [authorizedBtnView addSubview:authorizedBtn];

    [authorizedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processView.mas_bottom).offset(20);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@50);
    }];

    UILabel *introductionsLab = [[UILabel alloc] init];
    introductionsLab.textAlignment = NSTextAlignmentCenter;
    introductionsLab.textColor = COLOR_LIGHT_GREY;
    introductionsLab.font = TEXT_FONT_12;
    introductionsLab.text = XYBString(@"str_financing_serviceByXSD", @"本服务由“信用宝”旗下“信闪贷”提供");
    [authorizedBtnView addSubview:introductionsLab];

    [introductionsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(authorizedBtnView);
        make.top.equalTo(authorizedBtn.mas_bottom).offset(10);
    }];
}

- (void)clickTheAuthorizedBtn:(UIButton *)btn {

    [UMengAnalyticsUtil event:EVENT_XSDBORROW_MONEY];
    if (self.clickAuthorizedButton) {
        self.clickAuthorizedButton();
    }
}

#pragma
#pragma - mark TXHRulerScrollViewDelegate

- (void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView {
    int a = (int) rulerScrollView.rulerValue;
    if ((rulerScrollView.rulerValue - (int) rulerScrollView.rulerValue) > 0.4) {
        a = a + 1;
    }
    //    showLabel.text = [NSString stringWithFormat:@"当前刻度值: %.1d",a*500];
}

@end
