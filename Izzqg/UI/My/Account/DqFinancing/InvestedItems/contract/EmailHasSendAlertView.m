//
//  EmailHasSendAlertView.m
//  Ixyb
//
//  Created by dengjian on 1/12/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "EmailHasSendAlertView.h"

#import "AppDelegate.h"
#import "Utility.h"

@interface EmailHasSendAlertView ()
@property (nonatomic, strong) void (^completion)(EmailHasSendAlertViewAction action);

@end

@implementation EmailHasSendAlertView

- (id)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)show:(void (^)(EmailHasSendAlertViewAction action))completion {
    self.completion = completion;

    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];
}

- (void)clickBackBtn {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(EmailHasSendAlertViewActionCancel);
        self.completion = nil;
    }
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.6f];

    UIView *vi = [[UIView alloc] init];
    [self addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@1);
    }];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    [self addSubview:scrollView];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:backBtn];

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(MainScreenHeight - 40));
        make.centerY.equalTo(scrollView.mas_centerY);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.width.equalTo(vi.mas_width);
        make.bottom.equalTo(scrollView.mas_bottom).offset(-20);
    }];

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = COLOR_COMMON_WHITE;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [scrollView addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(scrollView.mas_centerY);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.width.equalTo(vi.mas_width);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    [contentView addSubview:titleLabel];
    titleLabel.font = TEXT_FONT_18;
    titleLabel.textColor = COLOR_MAIN_GREY;
    titleLabel.text = XYBString(@"string_alert_title_sended", @"合同已发送到您的邮箱");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@40);
    }];

    UILabel *emailLabel = [[UILabel alloc] init];
    [contentView addSubview:emailLabel];
    emailLabel.font = TEXT_FONT_16;
    emailLabel.textColor = COLOR_LIGHT_GREEN;
    emailLabel.text = [UserDefaultsUtil getUser].email;
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    }];

    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailLabel.mas_bottom).offset(25);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];

    UIButton *goToEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goToEmailButton setTitle:XYBString(@"string_to_see", @"去邮箱查看") forState:UIControlStateNormal];
    [goToEmailButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [goToEmailButton setBackgroundColor:COLOR_COMMON_WHITE];
    [goToEmailButton addTarget:self action:@selector(clickGoToEmailButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:goToEmailButton];
    [goToEmailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(split2View.mas_bottom);
        make.height.equalTo(@50);
    }];

    UIView *split3View = [[UIView alloc] init];
    split3View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split3View];
    [split3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split2View.mas_bottom);
        make.bottom.equalTo(contentView.mas_bottom);
        make.width.equalTo(@(Line_Height));
        make.left.equalTo(goToEmailButton.mas_right);
        make.centerX.equalTo(@0);
    }];

    UIButton *knowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [knowButton setTitle:XYBString(@"string_i_known", @"我知道了") forState:UIControlStateNormal];
    [knowButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [knowButton setBackgroundColor:COLOR_COMMON_WHITE];
    [knowButton addTarget:self action:@selector(clickKnowButton:) forControlEvents:UIControlEventTouchUpInside];
    knowButton.clipsToBounds = YES;
    [contentView addSubview:knowButton];
    [knowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(split2View.mas_bottom);
        make.height.equalTo(@50);
        make.left.equalTo(split3View.mas_right);
        make.bottom.equalTo(contentView.mas_bottom);
        make.width.equalTo(goToEmailButton.mas_width);
    }];
}

- (void)clickCancelButton:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(EmailHasSendAlertViewActionCancel);
        self.completion = nil;
    }
}

- (void)clickGoToEmailButton:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(EmailHasSendAlertViewActionGoToEmail);
        self.completion = nil;
    }
}

- (void)clickKnowButton:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(EmailHasSendAlertViewActionKnow);
        self.completion = nil;
    }
}

@end
