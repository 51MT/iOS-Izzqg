//
//  EmailInputAlertView.m
//  Ixyb
//
//  Created by dengjian on 1/5/16.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "EmailInputAlertView.h"

#import "AppDelegate.h"
#import "Utility.h"

@interface EmailInputAlertView ()
@property (nonatomic, strong) void (^completion)(EmailInputAlertViewAction action, NSString *email);
@property (nonatomic, strong) UITextField *emailTextField;
@end

@implementation EmailInputAlertView
- (id)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)show:(void (^)(EmailInputAlertViewAction action, NSString *email))completion {
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
        self.completion(EmailInputAlertViewActionCancel, nil);
        self.completion = nil;
    }
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithRed:0 / 255.f green:0 / 255.f blue:0 / 255.f alpha:0.6f];

    UIView *vi = [[UIView alloc] init];
    [self addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@20);
        make.right.equalTo(@(-20));
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
    contentView.backgroundColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [scrollView addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(scrollView.mas_centerY);
        make.centerX.equalTo(scrollView.mas_centerX);
        make.width.equalTo(vi.mas_width);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TEXT_FONT_18;
    titleLabel.textColor = COLOR_MAIN_GREY;
    [contentView addSubview:titleLabel];
    titleLabel.text = XYBString(@"string_input_email", @"填写邮箱地址");
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@20);
    }];

    UIView *textFieldView = [[UIView alloc] init];
    textFieldView.backgroundColor = COLOR_COMMON_WHITE;
    textFieldView.layer.masksToBounds = YES;
    textFieldView.layer.cornerRadius = Corner_Radius_3;
    textFieldView.layer.borderWidth = Border_Width;
    textFieldView.layer.borderColor = COLOR_LIGHTGRAY_BUTTONDISABLE.CGColor;
    [contentView addSubview:textFieldView];
    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@(-20));
        make.height.equalTo(@50);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    }];

    self.emailTextField = [[UITextField alloc] init];
    [textFieldView addSubview:self.emailTextField];
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailTextField.placeholder = XYBString(@"string_input_email", @"填写邮箱地址");
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.right.equalTo(@(-5));
        make.centerY.equalTo(textFieldView.mas_centerY);
    }];

    UIImageView *infoIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_info_gray"]];
    [contentView addSubview:infoIconView];
    [infoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textFieldView.mas_left);
        make.top.equalTo(textFieldView.mas_bottom).offset(10);
    }];

    UILabel *tip1Label = [[UILabel alloc] init];
    [contentView addSubview:tip1Label];
    tip1Label.textColor = COLOR_LIGHT_GREY;
    if (IS_IPHONE_5_OR_LESS) {
         tip1Label.font = TEXT_FONT_12;
    }else
    {
         tip1Label.font = TEXT_FONT_14;
    }
    tip1Label.text = XYBString(@"str_alert_email_tip", @"产品合同将发送到此邮箱,并与账户绑定。");
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoIconView.mas_right).offset(2);
        make.centerY.equalTo(infoIconView.mas_centerY);
    }];

    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip1Label.mas_bottom).offset(Margin_Length);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];

    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:XYBString(@"string_ok", @"确定") forState:UIControlStateNormal];
    [submitButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [submitButton setBackgroundColor:COLOR_COMMON_CLEAR];
    submitButton.titleLabel.font = TEXT_FONT_18;
    [submitButton addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.clipsToBounds = YES;
    [contentView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(split2View.mas_bottom);
        make.height.equalTo(@50);
        make.left.equalTo(@0);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
}

- (void)clickCancelButton:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(EmailInputAlertViewActionCancel, nil);
        self.completion = nil;
    }
}

- (void)clickSubmitButton:(id)sender {

    if (![Utility isValidateEmail:self.emailTextField.text]) {
        [HUD showPromptViewWithToShowStr:XYBString(@"string_email_error_email", @"请输入正确的Email") autoHide:YES afterDelay:3 userInteractionEnabled:YES];
        return;
    }

    [self removeFromSuperview];
    if (self.completion) {
        self.completion(EmailInputAlertViewActionEmail, self.emailTextField.text);
        self.completion = nil;
    }
}

@end
