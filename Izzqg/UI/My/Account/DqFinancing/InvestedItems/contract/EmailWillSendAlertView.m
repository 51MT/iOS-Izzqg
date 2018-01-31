//
//  EmailWillSendAlertView.m
//  Ixyb
//
//  Created by dengjian on 1/5/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "EmailWillSendAlertView.h"

#import "AppDelegate.h"
#import "Utility.h"

@interface EmailWillSendAlertView ()

@property (nonatomic, strong) void (^completion)(EmailWillSendAlertViewAction action);

@end

@implementation EmailWillSendAlertView

- (id)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)show:(void (^)(EmailWillSendAlertViewAction action))completion {
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
        self.completion(EmailWillSendAlertViewActionCancel);
        self.completion = nil;
    }
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.6f];

    UIView *vi = [[UIView alloc] init];
    [self addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@270);
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
    titleLabel.text = XYBString(@"string_alert_title_will_send", @"产品合同将发送到您的邮箱");
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

    UIButton *modifyEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:modifyEmailButton];
    //    [modifyEmailButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    //    modifyEmailButton.titleLabel.font = TEXT_FONT_16;
    [modifyEmailButton addTarget:self action:@selector(clickModifyEmailButton:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:XYBString(@"string_alert_title", @"修改邮箱地址")];
    NSRange strRange = {0, [str length]};
      [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN range:strRange];
    [str addAttribute:NSFontAttributeName value:TEXT_FONT_16 range:strRange];
    [modifyEmailButton setAttributedTitle:str forState:UIControlStateNormal];
    [modifyEmailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(emailLabel.mas_bottom).offset(10);
    }];

    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(modifyEmailButton.mas_bottom).offset(Margin_Length);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:XYBString(@"string_cancel", @"取消") forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:COLOR_COMMON_WHITE];
    [cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.equalTo(cancelButton.mas_right);
        make.centerX.equalTo(@0);
    }];

    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:XYBString(@"string_ok", @"确定") forState:UIControlStateNormal];
    [submitButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [submitButton setBackgroundColor:COLOR_COMMON_WHITE];
    [submitButton addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.clipsToBounds = YES;
    [contentView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(split2View.mas_bottom);
        make.height.equalTo(@50);
        make.left.equalTo(split3View.mas_right);
        make.bottom.equalTo(contentView.mas_bottom);
        make.width.equalTo(cancelButton.mas_width);
    }];
}

- (void)clickCancelButton:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(EmailWillSendAlertViewActionCancel);
        self.completion = nil;
    }
}

- (void)clickModifyEmailButton:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(EmailWillSendAlertViewActionModify);
        self.completion = nil;
    }
}

- (void)clickSubmitButton:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(EmailWillSendAlertViewActionSend);
        self.completion = nil;
    }
}

@end
