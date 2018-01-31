//
//  TradePasswordView.m
//  Ixyb
//
//  Created by wang on 15/11/18.
//  Copyright © 2015年 xyb. All rights reserved.
//

#import "AppDelegate.h"
#import "CALayer+Anim.h"
#import "TradePasswordView.h"
#import "User.h"
#import "Utility.h"
#import "VerificationTouch.h"

#define FIELDBACKVIEWTAG 1002
#define FIELDTAG 1003
#define BUTTONSURE 1004
#define ERRORLABTAG 1005
#define TOUIDTRANSACTIONt 1006
#define BUTTONFORGET 1007

@implementation TradePasswordView {
    ColorButton *sureBtn;
}

static TradePasswordView *_payView = nil;

+ (TradePasswordView *)shareInstancesaidView {

    if (_payView) {
        [_payView removeFromSuperview];
        _payView = [[TradePasswordView alloc] init];

        [_payView setUI];
        _payView.passwordTextField.text = nil;
        return _payView;

    } else {
        _payView = [[TradePasswordView alloc] init];

        [_payView setUI];
    }

    return _payView;
}

- (void)setUI {
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = COLOR_COMMON_BLACK_TRANS;
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
            make.width.equalTo(scrollView.mas_width);
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
            make.width.equalTo(@(MainScreenWidth - 40));
        }];

        UIButton *deldteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deldteButton setImage:[UIImage imageNamed:@"alret_close"] forState:UIControlStateNormal];
        [deldteButton addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:deldteButton];

        [deldteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(Margin_Length));
            make.left.equalTo(@(Margin_Length));
        }];

        User *user = [UserDefaultsUtil getUser];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = COLOR_MAIN_GREY;
        self.titleLabel.font = TEXT_FONT_16;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = XYBString(@"str_financing_tradePassword", @"交易密码");
        [contentView addSubview:self.titleLabel];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(Margin_Length));
            make.centerX.equalTo(contentView.mas_centerX);
            make.width.equalTo(@240);
        }];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_LINE;
        [contentView addSubview:lineView];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(Margin_Length);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@(Line_Height));
        }];

        UILabel *errorLab = [[UILabel alloc] init];
        errorLab.font = TEXT_FONT_14;
        errorLab.textColor = COLOR_STRONG_RED;
        errorLab.tag = ERRORLABTAG;
        [contentView addSubview:errorLab];

        [errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).offset(Text_Margin_Length);
            make.left.equalTo(@(Margin_Length));
        }];

        UIView *fieldBackView = [[UIView alloc] init];
        fieldBackView.backgroundColor = COLOR_COMMON_WHITE;
        fieldBackView.layer.masksToBounds = YES;
        fieldBackView.layer.cornerRadius = Corner_Radius;
        fieldBackView.layer.borderWidth = Border_Width;
        fieldBackView.layer.borderColor = COLOR_LIGHTGRAY_BUTTONDISABLE.CGColor;
        fieldBackView.tag = FIELDBACKVIEWTAG;
        [contentView addSubview:fieldBackView];

        [fieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Margin_Length));
            make.top.equalTo(errorLab.mas_bottom).offset(Text_Margin_Length);
            make.right.equalTo(@(-Margin_Length));
            make.height.equalTo(@(Button_Height));
        }];

        self.passwordTextField = [[UITextField alloc] init];
        self.passwordTextField.placeholder = XYBString(@"str_financing_pleEnterPasswort", @"请输入交易密码");
        self.passwordTextField.tag = FIELDTAG;
        self.passwordTextField.delegate = self;
        self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordTextField.secureTextEntry = YES;
        [fieldBackView addSubview:self.passwordTextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentFieldChange) name:UITextFieldTextDidChangeNotification object:self.passwordTextField];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(AlertTip_Margin_Left));
            make.right.equalTo(@(-45));
            make.centerY.equalTo(fieldBackView.mas_centerY);
        }];

        UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showBtn.selected = NO;
        [showBtn setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
        //        [showBtn setImage:[UIImage imageNamed:@"show_pwd_hl"] forState:UIControlStateHighlighted];
        [showBtn setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
        [showBtn addTarget:self action:@selector(clickShowPassWord:) forControlEvents:UIControlEventTouchUpInside];
        [fieldBackView addSubview:showBtn];

        [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(fieldBackView.mas_right).offset(-10);
            make.centerY.equalTo(self.passwordTextField.mas_centerY);
        }];
        
        sureBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 40, Button_Height) Title:XYBString(@"str_financing_ok", @"确定") ByGradientType:leftToRight];
        [sureBtn addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.isColorEnabled = NO;
        sureBtn.tag = BUTTONSURE;
        [contentView addSubview:sureBtn];

        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fieldBackView.mas_left);
            make.right.equalTo(fieldBackView.mas_right);
            make.top.equalTo(fieldBackView.mas_bottom).offset(Text_Margin_Length);
            make.height.equalTo(@(Button_Height));
        }];

        UILabel *labelFingerprint = [[UILabel alloc] init];
        if (IS_IPHONE_5) {
            labelFingerprint.font = SMALL_TEXT_FONT_13;
        } else {
            labelFingerprint.font = TEXT_FONT_14;
        }
        labelFingerprint.textColor = COLOR_LIGHT_GREY;
        labelFingerprint.text = XYBString(@"str_financing_thumbTrade_dzhaqsz", @"指纹交易: 到“账户安全设置”里开启此功能");
        [contentView addSubview:labelFingerprint];
        [labelFingerprint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fieldBackView.mas_left);
            make.right.equalTo(fieldBackView.mas_right);
            make.top.equalTo(sureBtn.mas_bottom).offset(Text_Margin_Length);
            make.bottom.equalTo(@(-AlertError_Margin_Bottom));

        }];

        XYButton *forgetButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"str_financing_forgetTradePassword", @"忘记密码?") isUserInteractionEnabled:YES];
        [forgetButton addTarget:self action:@selector(clickTheForgetBtn) forControlEvents:UIControlEventTouchUpInside];
        forgetButton.titleLabel.font = TEXT_FONT_14;
        [contentView addSubview:forgetButton];
        [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-Margin_Length));
            make.top.equalTo(sureBtn.mas_bottom).offset(Text_Margin_Length);
            make.bottom.equalTo(@(-AlertError_Margin_Bottom));

        }];

        if ([user.isTradePassword boolValue]) {
            self.titleLabel.text = XYBString(@"str_financing_tradePassword", @"交易密码");
            forgetButton.hidden = NO;

        } else {
            self.titleLabel.text = XYBString(@"str_financing_setAndSureTradePassword", @"设置并确认交易密码");
            forgetButton.hidden = YES;
        }

        //根据当前登录用户ID  查询私钥 是否开始指纹交易
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *firstBool = [defaults objectForKey:@"firstBool"];
        //验证是否支持TouID
        if (IS_iOS8TouID) {
            [[VerificationTouch shared] isSupportTouch:^(XybTouIDVerification touchType) {

                if (touchType == NotSupportedTouID) {
                    labelFingerprint.hidden = YES;
                } else if (touchType == YesSupportedTouID) {
                    //    第一次则进入
                    if (firstBool == nil) {

                        [defaults setObject:@"ture" forKey:@"firstBool"];
                        NSString *encryption = [UserDefaultsUtil getEncryptionData:[UserDefaultsUtil getUser].userId];
                        if (encryption > 0) {
                            labelFingerprint.hidden = YES;
                        } else {
                            labelFingerprint.hidden = NO;
                            forgetButton.hidden = YES;
                        }
                    } else if ([firstBool isEqualToString:@"ture"]) {
                        labelFingerprint.hidden = YES;
                        if ([user.isTradePassword boolValue]) {
                            self.titleLabel.text = XYBString(@"str_financing_tradePassword", @"交易密码");
                            forgetButton.hidden = NO;

                        } else {
                            self.titleLabel.text = XYBString(@"str_financing_setAndSureTradePassword", @"设置并确认交易密码");
                            forgetButton.hidden = YES;
                        }
                    }
                } else if (touchType == UserNotInputTouID) {
                    //    第一次则进入
                    if (firstBool == nil) {

                        [defaults setObject:@"ture" forKey:@"firstBool"];
                        labelFingerprint.hidden = NO;
                        forgetButton.hidden = YES;

                    } else if ([firstBool isEqualToString:@"ture"]) {
                        labelFingerprint.hidden = YES;
                    }
                }
            }];
        } else {
            labelFingerprint.hidden = YES;
            if ([user.isTradePassword boolValue]) {
                self.titleLabel.text = XYBString(@"str_financing_tradePassword", @"交易密码");
                forgetButton.hidden = NO;

            } else {
                self.titleLabel.text = XYBString(@"str_financing_setAndSureTradePassword", @"设置并确认交易密码");
                forgetButton.hidden = YES;
            }
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorNotification:) name:@"ERRORNOTIFICATION" object:nil];
}

- (void)clickTheForgetBtn {
    if (self.clickForgetButton) {
        self.clickForgetButton();
    }
    [self removeFromSuperview];
}

- (void)clickSubmitButton:(ColorButton *)button {
    UILabel *errorLab = (UILabel *) [self viewWithTag:ERRORLABTAG];
    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    button.isColorEnabled = NO;

    if (self.passwordTextField.text.length == 0) {
        errorLab.text = XYBString(@"str_financing_pleEnterPasswort", @"请输入交易密码");
        vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
        //添加一个shake动画
        [vi.layer shake];
        button.isColorEnabled = YES;
        //        [HUD showPromptViewWithToShowStr:XYBString(@"string_pleaseEnter_password",@"请输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidatePassword:self.passwordTextField.text]) {
        errorLab.text = XYBString(@"str_financing_enter6_20lengthPassword", @"请输入6-20位字符的密码");
        vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
        [vi.layer shake];
        button.isColorEnabled = YES;
        //        [HUD showPromptViewWithToShowStr:XYBString(@"string_length_password",@"请输入6-20位字符的密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![[UserDefaultsUtil getUser].isTradePassword boolValue]) {
        if (![Utility isValidateCharStr:self.passwordTextField.text]) {
            errorLab.text = XYBString(@"str_financing_passwordConsistWithNumEngUnderline", @"密码由数字、英文字母或下划线组成");
            vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
            [vi.layer shake];
            button.isColorEnabled = YES;
            //            [HUD showPromptViewWithToShowStr:XYBString(@"string_role_password",@"密码由数字、英文字母或下划线组成") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return;
        }
    }

    if (self.clickSureButton) {
        self.clickSureButton(self.passwordTextField.text);
    }
}

- (void)clickBackBtn {
    [self removeFromSuperview];
}

- (void)clickShowPassWord:(id)sender {
    UIButton *showBtn = (UIButton *) sender;
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    showBtn.selected = !showBtn.selected;
}

- (void)contentFieldChange {

    ColorButton *btn = (ColorButton *) [self viewWithTag:BUTTONSURE];
    UILabel *errorLab = (UILabel *) [self viewWithTag:ERRORLABTAG];
    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    UITextField *filed = (UITextField *) [self viewWithTag:FIELDTAG];
    if (filed.text.length > 0) {
        btn.isColorEnabled = YES;

    } else {
        btn.isColorEnabled = NO;
        if (filed.editing) {
            vi.layer.borderColor = COLOR_MAIN.CGColor;
        } else {
            vi.layer.borderColor = COLOR_LIGHTGRAY_BUTTONDISABLE.CGColor;
        }
        errorLab.text = @"";
    }
}

#pragma - mark
#pragma - mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    vi.layer.borderColor = COLOR_MAIN.CGColor;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    vi.layer.borderColor = COLOR_LIGHTGRAY_BUTTONDISABLE.CGColor;
}

- (void)errorNotification:(NSNotification *)note {
    UILabel *errorLab = (UILabel *) [self viewWithTag:ERRORLABTAG];
    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    NSString *err = note.object;
    errorLab.text = err;
    vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
    sureBtn.isColorEnabled = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ERRORNOTIFICATION" object:nil];
}

@end
