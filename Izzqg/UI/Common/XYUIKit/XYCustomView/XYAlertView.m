//
//  XYAlertView.m
//  Ixyb
//
//  Created by wang on 16/3/28.
//  Copyright © 2016年 xyb. All rights reserved.
//

#import "CALayer+Anim.h"
#import "Utility.h"
#import "XYAlertView.h"

#define FIELDBACKVIEWTAG 1002
#define FIELDTAG 1003
#define BUTTONSURE 1004
#define ERRORLABTAG 1005

@implementation XYAlertView {
    XYButton *codeButton;
    CustomedAlertStyle alertStyle;
}

//定期宝赎回弹出框
- (id)initBackWithTitle:(NSString *)title
  isShowHyperlinkButton:(BOOL)show
                 IsEyes:(BOOL)eyes
     WithRedemptionInfo:(RedemptionInfo *)redemptionInfo {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [self setBackUIWithTitle:title
           isShowHyperlinkButton:show
                          IsEyes:eyes
              WithRedemptionInfo:redemptionInfo];
    }
    return self;
}

//定期宝赎回弹出框UI
- (void)setBackUIWithTitle:(NSString *)title
     isShowHyperlinkButton:(BOOL)show
                    IsEyes:(BOOL)eyes
        WithRedemptionInfo:(RedemptionInfo *)redemptionInfo {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =
    [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@270);
    }];
    
    UIButton *deldteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deldteButton setImage:[UIImage imageNamed:@"alret_close"]
                  forState:UIControlStateNormal];
    [deldteButton addTarget:self
                     action:@selector(clickTheDeleteBtn)
           forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:deldteButton];
    
    [deldteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.width.height.equalTo(@20);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@14);
        make.centerX.equalTo(contentView.mas_centerX);
        make.width.equalTo(@240);
        make.height.equalTo(@17);
    }];
    
    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(14);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];
    
    UILabel *principalLab = [[UILabel alloc] init];
    principalLab.font = TEXT_FONT_18;
    principalLab.textColor = COLOR_MAIN_GREY;
    principalLab.text = @"赎回本金";
    [contentView addSubview:principalLab];
    
    [principalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split2View.mas_bottom).offset(Text_Margin_Length);
        make.left.equalTo(@Margin_Length);
    }];
    
    UILabel *principalAmountLab = [[UILabel alloc] init];
    principalAmountLab.font = TEXT_FONT_18;
    principalAmountLab.textColor = COLOR_STRONG_RED;
    NSString *princepalAmountStr = [Utility
                                    replaceTheNumberForNSNumberFormatter:[NSString
                                                                          stringWithFormat:@"%.2f",
                                                                          redemptionInfo
                                                                          .amount]];
    principalAmountLab.text =
    [NSString stringWithFormat:@"%@元", princepalAmountStr];
    [contentView addSubview:principalAmountLab];
    
    [principalAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split2View.mas_bottom).offset(Text_Margin_Length);
        make.right.equalTo(@(-Margin_Length));
    }];
    
    UILabel *interestLab = [[UILabel alloc] init];
    interestLab.font = TEXT_FONT_16;
    interestLab.textColor = COLOR_AUXILIARY_GREY;
    interestLab.text = @"应计利息";
    [contentView addSubview:interestLab];
    
    [interestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(principalLab.mas_bottom).offset(Text_Margin_Middle);
        make.left.equalTo(@Margin_Length);
    }];
    
    UILabel *interestAmountLab = [[UILabel alloc] init];
    interestAmountLab.font = TEXT_FONT_16;
    interestAmountLab.textColor = COLOR_MAIN_GREY;
    NSString *interestAmountStr = [Utility
                                   replaceTheNumberForNSNumberFormatter:
                                   [NSString stringWithFormat:@"%.2f", redemptionInfo.interests]];
    interestAmountLab.text =
    [NSString stringWithFormat:@"%@元", interestAmountStr];
    [contentView addSubview:interestAmountLab];
    
    [interestAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(principalLab.mas_bottom).offset(Text_Margin_Middle);
        make.right.equalTo(@(-Margin_Length));
    }];
    
    UILabel *handlingChargeLab = [[UILabel alloc] init];
    handlingChargeLab.font = TEXT_FONT_16;
    handlingChargeLab.textColor = COLOR_AUXILIARY_GREY;
    handlingChargeLab.text = @"提前赎回手续费";
    [contentView addSubview:handlingChargeLab];
    
    [handlingChargeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(interestLab.mas_bottom).offset(Text_Margin_Middle);
        make.left.equalTo(@Margin_Length);
    }];
    
    UILabel *handlingChargeAmountLab = [[UILabel alloc] init];
    handlingChargeAmountLab.font = TEXT_FONT_16;
    handlingChargeAmountLab.textColor = COLOR_MAIN_GREY;
    NSString *handlingChargeStr = [Utility
                                   replaceTheNumberForNSNumberFormatter:[NSString
                                                                         stringWithFormat:@"%.2f",
                                                                         redemptionInfo
                                                                         .fee]];
    handlingChargeAmountLab.text =
    [NSString stringWithFormat:@"%@元", handlingChargeStr];
    [contentView addSubview:handlingChargeAmountLab];
    
    [handlingChargeAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(interestLab.mas_bottom).offset(Text_Margin_Middle);
        make.right.equalTo(@(-Margin_Length));
    }];
    
    UILabel *arriveAccountLab = [[UILabel alloc] init];
    arriveAccountLab.font = TEXT_FONT_16;
    arriveAccountLab.textColor = COLOR_AUXILIARY_GREY;
    arriveAccountLab.text = @"预计到账金额";
    [contentView addSubview:arriveAccountLab];
    
    [arriveAccountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(handlingChargeLab.mas_bottom).offset(Text_Margin_Middle);
        make.left.equalTo(@Margin_Length);
    }];
    
    UILabel *arriveAccountAmountLab = [[UILabel alloc] init];
    arriveAccountAmountLab.font = TEXT_FONT_16;
    arriveAccountAmountLab.textColor = COLOR_MAIN_GREY;
    NSString *arriveStr = [Utility
                           replaceTheNumberForNSNumberFormatter:
                           [NSString stringWithFormat:@"%.2f", redemptionInfo.arrivalAmount]];
    arriveAccountAmountLab.text = [NSString stringWithFormat:@"%@元", arriveStr];
    [contentView addSubview:arriveAccountAmountLab];
    
    [arriveAccountAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(handlingChargeLab.mas_bottom).offset(Text_Margin_Middle);
        make.right.equalTo(@(-Margin_Length));
    }];
    
    UILabel *arriveAccountTimeLab = [[UILabel alloc] init];
    arriveAccountTimeLab.font = TEXT_FONT_14;
    arriveAccountTimeLab.textColor = COLOR_ORANGE;
    arriveAccountTimeLab.text =
    [NSString stringWithFormat:@"( 预计%@到账 )", redemptionInfo.arrivalDate];
    [contentView addSubview:arriveAccountTimeLab];
    
    [arriveAccountTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(arriveAccountLab.mas_bottom).offset(Text_Margin_Middle);
        make.left.equalTo(@Margin_Length);
    }];
    
    UILabel *errorLab = [[UILabel alloc] init];
    errorLab.font = TEXT_FONT_14;
    errorLab.textColor = COLOR_STRONG_RED;
    errorLab.tag = ERRORLABTAG;
    [contentView addSubview:errorLab];
    
    [errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(arriveAccountTimeLab.mas_bottom)
        .offset(Text_Margin_Length);
        make.left.equalTo(@Margin_Length);
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
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(errorLab.mas_bottom).offset(Text_Margin_Middle);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@45);
    }];
    
    UITextField *contentField = [[UITextField alloc] init];
    contentField.placeholder = @"请输入交易密码";
    contentField.tag = FIELDTAG;
    contentField.delegate = self;
    contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldBackView addSubview:contentField];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(contentFieldChange)
     name:UITextFieldTextDidChangeNotification
     object:contentField];
    [contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        if (eyes) {
            make.right.equalTo(@(-45));
        } else {
            make.right.equalTo(@(-10));
        }
        
        make.centerY.equalTo(fieldBackView.mas_centerY);
    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(contentFieldChange)
     name:UITextFieldTextDidChangeNotification
     object:contentField];
    
    if (eyes) {
        contentField.secureTextEntry = YES;
        UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showBtn.selected = NO;
        [showBtn setImage:[UIImage imageNamed:@"show_pwd"]
                 forState:UIControlStateNormal];
        [showBtn setImage:[UIImage imageNamed:@"show_pwd_selected"]
                 forState:UIControlStateSelected];
        [showBtn addTarget:self
                    action:@selector(showPassWord:)
          forControlEvents:UIControlEventTouchUpInside];
        [fieldBackView addSubview:showBtn];
        
        [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(fieldBackView.mas_right).offset(-10);
            make.centerY.equalTo(contentField.mas_centerY);
        }];
    }
    
    ColorButton *sureBtn =
    [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, 270 - 30.f, Cell_Height) Title:XYBString(@"string_ok", @"确定") ByGradientType:leftToRight];
    
    [sureBtn addTarget:self
                action:@selector(clickTheSureBtn)
      forControlEvents:UIControlEventTouchUpInside];
    sureBtn.isColorEnabled = NO;
    sureBtn.tag = BUTTONSURE;
    [contentView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldBackView.mas_left);
        make.right.equalTo(fieldBackView.mas_right);
        make.top.equalTo(fieldBackView.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@45);
        if (!show) {
            make.bottom.equalTo(@(-20));
        }
    }];
    
    if (show) {
        XYButton *forgetButton = [[XYButton alloc]
                                  initWithSubordinationButtonTitle:XYBString(
                                                                             @"string_forget_tradePassword",
                                                                             @"忘记密码?")
                                  isUserInteractionEnabled:YES];
        [forgetButton addTarget:self
                         action:@selector(clickTheForgetBtn)
               forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:forgetButton];
        [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-Margin_Length));
            make.top.equalTo(sureBtn.mas_bottom).offset(13);
            make.bottom.equalTo(@(-20));
            
        }];
        
        XYButton *backRuleButton = [[XYButton alloc]
                                    initWithSubordinationButtonTitle:XYBString(@"string_back_rule",
                                                                               @"赎回规则")
                                    isUserInteractionEnabled:YES];
        [backRuleButton addTarget:self
                           action:@selector(clickTheUrlBtn)
                 forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:backRuleButton];
        [backRuleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Margin_Length));
            make.top.equalTo(sureBtn.mas_bottom).offset(13);
            make.bottom.equalTo(@(-20));
            
        }];
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(errorNotification:)
     name:@"DQB_REDEEM_ALERT"
     object:nil];
}

//输入密码弹出框
- (id)initWithTitle:(NSString *)title
isShowHyperlinkButton:(BOOL)show
             IsEyes:(BOOL)eyes {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [self setUIWithTitle:title isShowHyperlinkButton:show IsEyes:eyes];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title
 isShowHyperlinkButton:(BOOL)show
                IsEyes:(BOOL)eyes {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =
    [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        //        make.width.equalTo(@(MainScreenWidth - 40));
        make.width.equalTo(@270);
    }];
    
    UIButton *deldteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deldteButton.backgroundColor = COLOR_COMMON_RED;
    [deldteButton addTarget:self
                     action:@selector(clickTheDeleteBtn)
           forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:deldteButton];
    
    [deldteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.width.height.equalTo(@20);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@14);
        make.centerX.equalTo(contentView.mas_centerX);
        make.width.equalTo(@240);
        make.height.equalTo(@17);
    }];
    
    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(14);
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
        make.top.equalTo(split2View.mas_bottom).offset(20);
        make.left.equalTo(@Margin_Length);
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
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(errorLab.mas_bottom).offset(10);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@45);
    }];
    
    UITextField *contentField = [[UITextField alloc] init];
    contentField.placeholder = @"输入内容";
    contentField.tag = FIELDTAG;
    contentField.delegate = self;
    contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [fieldBackView addSubview:contentField];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(contentFieldChange)
     name:UITextFieldTextDidChangeNotification
     object:contentField];
    [contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        if (eyes) {
            make.right.equalTo(@(-45));
        } else {
            make.right.equalTo(@(-10));
        }
        
        make.centerY.equalTo(fieldBackView.mas_centerY);
    }];
    if (eyes) {
        contentField.secureTextEntry = YES;
        UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showBtn.selected = NO;
        [showBtn setImage:[UIImage imageNamed:@"show_pwd"]
                 forState:UIControlStateNormal];
        //        [showBtn setImage:[UIImage imageNamed:@"show_pwd_hl"]
        //        forState:UIControlStateHighlighted];
        [showBtn setImage:[UIImage imageNamed:@"show_pwd_selected"]
                 forState:UIControlStateSelected];
        [showBtn addTarget:self
                    action:@selector(showPassWord:)
          forControlEvents:UIControlEventTouchUpInside];
        [fieldBackView addSubview:showBtn];
        
        [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(fieldBackView.mas_right).offset(-10);
            make.centerY.equalTo(contentField.mas_centerY);
            //            make.left.equalTo(horlineImage.mas_right);
            //            make.height.equalTo(@30);
            //            make.width.equalTo(@60);
        }];
    }
    
    ColorButton *sureBtn =
    [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, 270.f-30.f, Cell_Height) Title:XYBString(@"string_ok", @"确定") ByGradientType:leftToRight];
    [sureBtn addTarget:self
                action:@selector(clickTheSureBtn)
      forControlEvents:UIControlEventTouchUpInside];
    sureBtn.isColorEnabled = NO;
    sureBtn.tag = BUTTONSURE;
    [contentView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldBackView.mas_left);
        make.right.equalTo(fieldBackView.mas_right);
        make.top.equalTo(fieldBackView.mas_bottom).offset(Margin_Length);
        make.height.equalTo(@45);
        if (!show) {
            make.bottom.equalTo(@(-20));
        }
    }];
    if (show) {
        XYButton *forgetButton = [[XYButton alloc]
                                  initWithSubordinationButtonTitle:XYBString(
                                                                             @"string_forget_tradePassword",
                                                                             @"忘记密码?")
                                  isUserInteractionEnabled:YES];
        [forgetButton addTarget:self
                         action:@selector(clickTheUrlBtn)
               forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:forgetButton];
        [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-Margin_Length));
            make.top.equalTo(sureBtn.mas_bottom).offset(13);
            make.bottom.equalTo(@(-20));
            
        }];
    }
}

#pragma mark - 通知中心响应事件

- (void)errorNotification:(NSNotification *)note {
    UILabel *errorLab = (UILabel *) [self viewWithTag:ERRORLABTAG];
    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    NSString *err = note.object;
    errorLab.text = err;
    vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
}

- (void)clickTheDeleteBtn {
    [self removeFromSuperview];
}

- (void)showPassWord:(id)sender {
    UIButton *showBtn = (UIButton *) sender;
    UITextField *filed = (UITextField *) [self viewWithTag:FIELDTAG];
    filed.secureTextEntry = !filed.secureTextEntry;
    showBtn.selected = !showBtn.selected;
}

- (void)clickTheSureBtn {
    UITextField *passwordTextField = (UITextField *) [self viewWithTag:FIELDTAG];
    UILabel *errorLab = (UILabel *) [self viewWithTag:ERRORLABTAG];
    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    
    if (passwordTextField.text.length == 0) {
        errorLab.text =
        XYBString(@"string_pleaseEnter_password", @"请输入交易密码");
        vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
        //添加一个shake动画
        [vi.layer shake];
        
        return;
    }
    
    if (![Utility isValidatePassword:passwordTextField.text]) {
        errorLab.text = XYBString(@"string_length_password",
                                  @"请输入6-20位字符的密码");
        vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
        [vi.layer shake];
        
        return;
    }
    
    if (![[UserDefaultsUtil getUser].isTradePassword boolValue]) {
        if (![Utility isValidateCharStr:passwordTextField.text]) {
            errorLab.text =
            XYBString(@"string_role_password",
                      @"密码由数字、英文字母或下划线组成");
            vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
            [vi.layer shake];
            
            return;
        }
    }
    
    if (self.clickSureButton) {
        self.clickSureButton(passwordTextField.text);
    }
    //    errorLab.text = @"错误错误";
    //    UIView *vi = (UIView *)[self viewWithTag:FIELDBACKVIEWTAG];
    //    vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
}

- (void)clickTheForgetBtn {
    if (self.clickHyperlinkButton) {
        self.clickHyperlinkButton();
    }
}

- (void)clickTheUrlBtn {
    if (self.clickUrlButton) {
        self.clickUrlButton();
    }
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
} // return NO to disallow editing.

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    vi.layer.borderColor = COLOR_LIGHTGRAY_BUTTONDISABLE.CGColor;
}

#pragma - mark
#pragma - mark RadioAlertView 单选视图

- (id)initWithRadioAlertViewClueImage:(UIImage *)image
                                title:(NSMutableAttributedString *)title
                             describe:(NSString *)describeStr
                          isHaveIamge:(BOOL)isHave {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        
        [self setUIWithclueImage:image
                           title:title
                        describe:describeStr
                     isHaveIamge:isHave];
    }
    return self;
}

- (void)setUIWithclueImage:(UIImage *)image
                     title:(NSMutableAttributedString *)title
                  describe:(NSString *)describestring
               isHaveIamge:(BOOL)isHave {
    
    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:@selector(clickTheDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =
    [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.userInteractionEnabled = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.mas_left).offset(Margin_Length);
        make.right.equalTo(self.mas_right).offset(-Margin_Length);
    }];
    
    UIView *customerView;
    if (isHave) {
        UIImageView *clueImageView = [[UIImageView alloc] init];
        clueImageView.image = image;
        [contentView addSubview:clueImageView];
        
        [clueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@37);
            make.centerX.equalTo(contentView.mas_centerX);
        }];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.attributedText = title;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(clueImageView.mas_bottom).offset(Margin_Length);
            make.centerX.equalTo(contentView.mas_centerX);
            make.width.equalTo(@220);
            make.height.equalTo(@17);
        }];
        
        UILabel *describeLab = [[UILabel alloc] init];
        describeLab.font = TEXT_FONT_14;
        describeLab.textColor = COLOR_LIGHT_GREY;
        describeLab.text = describestring;
        describeLab.textAlignment = NSTextAlignmentCenter;
        describeLab.numberOfLines = 0;
        [contentView addSubview:describeLab];
        
        [describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom).offset(12);
            make.centerX.equalTo(contentView.mas_centerX);
            make.left.equalTo(@20);
            make.right.equalTo(@(-20));
        }];
        customerView = describeLab;
    } else {
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.attributedText = title;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_top).offset(20);
            make.centerX.equalTo(contentView.mas_centerX);
            make.width.equalTo(@220);
            make.height.equalTo(@17);
        }];
        
        RTLabel *contentLab = [[RTLabel alloc] init];
        contentLab.font = TEXT_FONT_14;
        contentLab.textColor = COLOR_AUXILIARY_GREY;
        contentLab.text = describestring;
        contentLab.delegate = self;
        contentLab.textAlignment = RTTextAlignmentCenter;
        [contentView addSubview:contentLab];
        
        [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLab.mas_bottom).offset(17);
            make.centerX.equalTo(contentView.mas_centerX);
            if (IS_IPHONE_4_OR_LESS) {
                make.height.equalTo(@102);
            } else {
                make.height.equalTo(@100);
            }
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
        }];
        customerView = contentLab;
    }
    XYButton *sureBtn = [[XYButton alloc]
                         initWithLineButtonTitle:XYBString(@"string_i_know", @"我知道了")];
    [sureBtn addTarget:self
                action:@selector(clickTheRadioSureBtn)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    [sureBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [sureBtn setTitleColor:COLOR_MAIN_GREY forState:UIControlStateHighlighted];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(customerView.mas_bottom).offset(37);
        make.height.equalTo(@45);
        make.bottom.equalTo(@0);
    }];
}

- (void)clickTheRadioSureBtn {
    [self removeFromSuperview];
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url {
    [self removeFromSuperview];
    if ([url.description isEqualToString:@"pddh"]) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:@"tel://4000707663"]];
    }
}

#pragma
#pragma - mark MoreSelectAlertView 多选

- (id)initWithMoreSelectAlertViewTitle:(NSString *)title
                              describe:(NSString *)describeStr {
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        
        [self setUIWithTitle:title describe:describeStr];
    }
    return self;
}

- (void)setUIWithTitle:(NSString *)title describe:(NSString *)describeStr {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =
    [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(270));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_18;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@22);
        make.centerX.equalTo(contentView.mas_centerX);
        make.width.equalTo(@220);
        make.height.equalTo(@18);
    }];
    
    UILabel *describeLab = [[UILabel alloc] init];
    describeLab.font = TEXT_FONT_14;
    describeLab.textColor = COLOR_AUXILIARY_GREY;
    describeLab.text = describeStr;
    describeLab.numberOfLines = 0;
    [contentView addSubview:describeLab];
    
    [describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.centerX.equalTo(contentView.mas_centerX);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
    }];
    
    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(describeLab.mas_bottom).offset(20);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:XYBString(@"string_cancel", @"取消")
                  forState:UIControlStateNormal];
    [cancelButton setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    [cancelButton addTarget:self
                     action:@selector(clickMoreSelectViewCancelButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(split2View.mas_bottom);
        make.height.equalTo(@45);
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
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:XYBString(@"string_ok", @"确定")
                forState:UIControlStateNormal];
    [sureButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [sureButton addTarget:self
                   action:@selector(clickMoreSelectViewSureButton:)
         forControlEvents:UIControlEventTouchUpInside];
    sureButton.clipsToBounds = YES;
    [contentView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(split2View.mas_bottom);
        make.height.equalTo(@45);
        make.left.equalTo(split3View.mas_right);
        make.bottom.equalTo(contentView.mas_bottom);
    }];
}

- (void)clickMoreSelectViewCancelButton:(id)sender {
    [self removeFromSuperview];
    if (self.clickCancelButton) {
        self.clickCancelButton();
    }
}

- (void)clickMoreSelectViewSureButton:(id)sender {
    [self removeFromSuperview];
    if (self.clickSureButton) {
        self.clickSureButton(nil);
    }
}

//确定弹出框
- (id)initWithFrame:(CGRect)frame SureBorderDescription:(NSString *)descripe {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [self createMainUI:descripe];
    }
    return self;
}

- (void)createMainUI:(NSString *)descripe {
    UIView *contentView = [[UIView alloc] init]; //确定弹出框白色背景视图
    contentView.backgroundColor =
    [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius;
    contentView.layer.borderWidth = Border_Width;
    contentView.layer.borderColor = COLOR_LIGHT_GREY.CGColor;
    [self addSubview:contentView];
    
    //预付利息：受让人垫付给出让人的债权自上一还款日至转让生效日的应计利息，垫付的利息会在购买债权后的第一次回款时一并返还。
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(270));
    }];
    
    UILabel *descripeLab = [[UILabel alloc] init]; //确定弹出框中的内容
    descripeLab.font = TEXT_FONT_14;
    descripeLab.textColor = COLOR_AUXILIARY_GREY;
    descripeLab.text = descripe;
    descripeLab.numberOfLines = 0;
    [contentView addSubview:descripeLab];
    
    [descripeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(contentView.mas_right).offset(-Margin_Right);
        make.top.equalTo(contentView.mas_top).offset(Margin_Top);
    }];
    
    UIView *lineView = [[UIView alloc] init]; //确定框中按钮上面的横线
    lineView.backgroundColor = COLOR_LINE;
    [contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(descripeLab.mas_bottom).offset(Margin_Top);
        make.height.equalTo(@(Line_Height));
    }];
    
    XYButton *sureBtn = [[XYButton alloc] initWithSubordinationButtonTitle:@"确定" isUserInteractionEnabled:YES];
    [sureBtn addTarget:self action:@selector(clickTheDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(contentView.mas_bottom);
    }];
}

- (id)initWithFrame:(CGRect)frame presentTestWindowWithDescripe:(NSString *)descripe bottomButtonTitle:(NSString *)buttonTitle {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [self createMainUI:descripe bottomButton:buttonTitle];
    }
    return self;
}

- (void)createMainUI:(NSString *)descripe bottomButton:(NSString *)buttonTitle {
    UIView *contentView = [[UIView alloc] init]; //测评弹出框框白色背景视图
    contentView.backgroundColor =
    [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_4;
    contentView.layer.borderWidth = Border_Width;
    contentView.layer.borderColor = COLOR_LIGHT_GREY.CGColor;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(270));
    }];
    
    UIButton *deldteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deldteButton setImage:[UIImage imageNamed:@"alret_close"]
                  forState:UIControlStateNormal];
    [deldteButton addTarget:self
                     action:@selector(clickTheDeleteBtn)
           forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:deldteButton];
    
    [deldteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Margin_Length));
        make.left.equalTo(@(Margin_Length));
        make.width.height.equalTo(@20);
    }];
    
    UILabel *descripeLab = [[UILabel alloc] init]; //测评弹出框中的内容
    descripeLab.font = TEXT_FONT_14;
    descripeLab.textColor = COLOR_MAIN_GREY;
    descripeLab.text = descripe;
    descripeLab.numberOfLines = 0;
    [contentView addSubview:descripeLab];
    
    [descripeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(contentView.mas_right).offset(-Margin_Right);
        make.top.equalTo(contentView.mas_top).offset(Cell_Height);
    }];
    
    UIView *lineView = [[UIView alloc] init]; //测评弹出框框中按钮上面的横线
    lineView.backgroundColor = COLOR_LINE;
    [contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(descripeLab.mas_bottom).offset(Margin_Top);
        make.height.equalTo(@(Line_Height));
    }];
    
    XYButton *testBtn = [[XYButton alloc] initWithSubordinationButtonTitle:buttonTitle isUserInteractionEnabled:YES];
    [testBtn addTarget:self action:@selector(clickTheTestButton) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:testBtn];
    
    [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(contentView.mas_bottom);
    }];
}

- (id)initPaySureBorderWithFrame:(CGRect)frame title:(NSString *)title telephoneNo:(NSString *)telephoneNo alertStyle:(CustomedAlertStyle)style {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showErrorLab:) name:@"KQERRORNOTIFICATION" object:nil]; //接收快钱支付错误提示信息
        
        //        UIControl *deleteControl = [[UIControl alloc] init];//添加点击事件，点击就关闭弹窗
        //        [deleteControl addTarget:self action:@selector(clickTheDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:deleteControl];
        //
        //        [deleteControl mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.edges.equalTo(self);
        //        }];
        
        [self createPaySureView:title telephoneN0:telephoneNo alertStyle:style];
    }
    return self;
}

- (void)showErrorLab:(NSNotification *)notify {
    self.remaindLab.text = notify.object;
    if (self.remaindLab.hidden == YES) {
        self.remaindLab.hidden = NO;
        [self.remaindLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.telephoneLab.mas_bottom).offset(10);
            make.height.equalTo(@12);
        }];
    }
}

- (void)createPaySureView:(NSString *)title telephoneN0:(NSString *)telephoneNo alertStyle:(CustomedAlertStyle)style {
    
    alertStyle = style;
    UIView *backView = [[UIView alloc] init]; //付款确认支付弹出框的背景图
    backView.backgroundColor =
    [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(270));
    }];
    
    UIButton *deldteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deldteButton setImage:[UIImage imageNamed:@"alret_close"]
                  forState:UIControlStateNormal];
    [deldteButton addTarget:self
                     action:@selector(clickTheDeleteBtn)
           forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:deldteButton];
    
    [deldteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(Margin_Length));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init]; //付款确认标题
    titleLab.font = TEXT_FONT_16;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@14);
        make.centerX.equalTo(backView.mas_centerX);
        make.width.equalTo(@240);
        make.height.equalTo(@17);
    }];
    
    UIView *lineView = [[UIView alloc] init]; //画线
    lineView.backgroundColor = COLOR_LINE;
    [backView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(14);
        make.left.right.equalTo(backView);
        make.height.equalTo(@(Line_Height));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = TEXT_FONT_12;
    label.textColor = COLOR_AUXILIARY_GREY;
    label.text = @"本次交易需短信验证";
    [backView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.height.equalTo(@(12));
    }];
    
    _telephoneLab = [[UILabel alloc] init];
    _telephoneLab.font = TEXT_FONT_12;
    _telephoneLab.textColor = COLOR_AUXILIARY_GREY;
    _telephoneLab.numberOfLines = 0;
    NSString *telephoneStr = [Utility thePhoneReplaceTheStr:telephoneNo];
    _telephoneLab.text = [NSString stringWithFormat:@"验证码已发送至您的手机号：%@", telephoneStr];
    [backView addSubview:_telephoneLab];
    
    [_telephoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(label.mas_bottom).offset(8);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];
    
    _remaindLab = [[UILabel alloc] init]; //错误提示显示的label
    _remaindLab.font = TEXT_FONT_12;
    _remaindLab.textColor = COLOR_RED_LEVEL1;
    _remaindLab.numberOfLines = 0;
    _remaindLab.hidden = YES;
    [backView addSubview:_remaindLab];
    
    [_remaindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.top.equalTo(_telephoneLab.mas_bottom).offset(0);
        make.height.equalTo(@0);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
    }];
    
    UIView *codeBackView = [[UIView alloc] init];
    codeBackView.backgroundColor = COLOR_COMMON_WHITE;
    codeBackView.layer.borderWidth = Border_Width;
    codeBackView.layer.borderColor = COLOR_LINE.CGColor;
    codeBackView.layer.cornerRadius = Corner_Radius;
    codeBackView.layer.masksToBounds = YES;
    codeBackView.tag = FIELDBACKVIEWTAG;
    [backView addSubview:codeBackView];
    
    [codeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(Margin_Length);
        make.right.equalTo(backView.mas_right).offset(-Margin_Length);
        make.top.equalTo(_remaindLab.mas_bottom).offset(10);
        make.height.equalTo(@(Cell_Height));
    }];
    
    codeButton = [[XYButton alloc] initWithSubordinationButtonTitle:@"60秒" isUserInteractionEnabled:YES];
    [codeButton addTarget:self action:@selector(clcikTheCodeButton) forControlEvents:UIControlEventTouchUpInside];
    codeButton.titleLabel.font = TEXT_FONT_16;
    codeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:codeButton];
    
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeBackView.mas_right).offset(-Margin_Length);
        make.top.equalTo(codeBackView.mas_top).offset(Line_Height);
        make.centerY.equalTo(codeBackView.mas_centerY);
        make.width.equalTo(@(40));
    }];
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectZero];//验证码输入框
    _codeTextField.font = NORMAL_TEXT_FONT_15;
    _codeTextField.textColor = COLOR_MAIN_GREY;
    _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTextField.adjustsFontSizeToFitWidth = YES;
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextField.delegate = self;
    if (style == KQAlertStyleDefault) {
        _codeTextField.placeholder = @"6位短信验证码";
    }else if (style == TLAlertStyle) {
        _codeTextField.placeholder = @"4位短信验证码";
    }
    [codeBackView addSubview:_codeTextField];
    
    [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(codeBackView.mas_centerY);
        make.right.equalTo(codeButton.mas_left).offset(-5);
    }];
    
    UIView *lineView2 = [[UIView alloc] init]; //确定取消按钮上的横线
    lineView2.backgroundColor = COLOR_LINE;
    [backView addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(codeBackView.mas_bottom).offset(20);
        make.height.equalTo(@(Line_Height));
    }];
    
//    XYButton *cancelBtn = [[XYButton alloc] initWithGeneralBtnTitle:@"取消" titleColor:COLOR_MAIN isUserInteractionEnabled:YES];
//    cancelBtn.titleLabel.font = TEXT_FONT_18;
//    [cancelBtn addTarget:self action:@selector(clickTheDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:cancelBtn];
//    
//    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(0));
//        make.top.equalTo(lineView2.mas_bottom).offset(0);
//        make.width.equalTo(@((270 - Line_Height) / 2));
//        make.height.equalTo(@(Cell_Height));
//    }];
//    
//    UIView *lineView3 = [[UIView alloc] init];
//    lineView3.backgroundColor = COLOR_LINE;
//    [backView addSubview:lineView3];
//    
//    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView2.mas_bottom).offset(0);
//        make.left.equalTo(cancelBtn.mas_right).offset(0);
//        make.width.equalTo(@(Line_Height));
//        make.height.equalTo(@(Cell_Height));
//    }];
    
    XYButton *sureBtn = [[XYButton alloc] initWithGeneralBtnTitle:@"确定" titleColor:COLOR_MAIN isUserInteractionEnabled:YES];
    sureBtn.titleLabel.font = TEXT_FONT_18;
    [sureBtn addTarget:self action:@selector(clickPaySureBtn) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(lineView2.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(backView.mas_bottom).offset(0);
    }];
    
    [self timeGo];
}

- (void)timeGo {
    
    __block int timeout = 60;
    
    dispatch_queue_t queen = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queen);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [codeButton setTitle:XYBString(@"string_resend_varify_code", @"重新获取验证码") forState:UIControlStateNormal];
                [codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
                codeButton.titleLabel.font = NORMAL_TEXT_FONT_15;
                codeButton.userInteractionEnabled = YES;
                [codeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(110));
                }];
            });
        } else {
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [codeButton setTitle:[NSString stringWithFormat:@"%@秒", strTime] forState:UIControlStateNormal];
                [codeButton setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
                codeButton.titleLabel.font = TEXT_FONT_16;
                codeButton.userInteractionEnabled = NO;
                [codeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(40));
                }];
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (void)clcikTheCodeButton {
    //重新创建订单，并发送验证码
    [codeButton setTitle:@"60秒" forState:UIControlStateNormal];
    [self timeGo];
    self.clickCodeButton();
}

- (void)clickPaySureBtn {
    
    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    if (self.codeTextField.text.length == 0) {
        self.remaindLab.text = XYBString(@"string_pleaseEnter_emailCode", @"请输入短信验证码");
        vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
        //添加一个shake动画
        [vi.layer shake];
        
        if (self.remaindLab.hidden == YES) {
            self.remaindLab.hidden = NO;
            [self.remaindLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.telephoneLab.mas_bottom).offset(10);
                make.height.equalTo(@12);
            }];
        }
        
        return;
    }
    
    if (alertStyle == KQAlertStyleDefault) {
        if (![Utility isSixVerifyCode:self.codeTextField.text]) {
            self.remaindLab.text = XYBString(@"str_account_qsrsix", @"请输入6位字符的验证码");
            vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
            [vi.layer shake];
            
            if (self.remaindLab.hidden == YES) {
                self.remaindLab.hidden = NO;
                [self.remaindLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.telephoneLab.mas_bottom).offset(10);
                    make.height.equalTo(@12);
                }];
            }
            return;
        }
    }
    
    if (alertStyle == TLAlertStyle) {
        if (![Utility isFourVerifyCode:self.codeTextField.text]) {
            self.remaindLab.text = XYBString(@"str_account_qsrfour", @"请输入4位字符的验证码");
            vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
            [vi.layer shake];
            if (self.remaindLab.hidden == YES) {
                self.remaindLab.hidden = NO;
                [self.remaindLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.telephoneLab.mas_bottom).offset(10);
                    make.height.equalTo(@12);
                }];
            }
            
            return;
        }
    }
    
    if (self.clickSureButton) {
        self.clickSureButton(self.codeTextField.text);
    }
}

- (void)clickTheTestButton {
    self.clickUrlButton();
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//信闪贷 - 一键开启弹窗
- (id)initWithStartLocationAlertViewWithFrame:(CGRect)frame title:(NSString *)titleStr describe:(NSString *)describeStr bottomButtonTitle:(NSString *)buttonTitle {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [self createStartLocationAlertViewWithFrame:frame title:titleStr describe:describeStr bottomButtonTitle:buttonTitle];
    }
    return self;
    
}

- (void)createStartLocationAlertViewWithFrame:(CGRect)frame title:(NSString *)titleStr describe:(NSString *)describeStr bottomButtonTitle:(NSString *)buttonTitle {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(270));
    }];
    
    UIButton *deldteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deldteButton setImage:[UIImage imageNamed:@"alret_close"]
                  forState:UIControlStateNormal];
    [deldteButton addTarget:self
                     action:@selector(clickTheDeleteBtn)
           forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:deldteButton];
    
    [deldteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.width.height.equalTo(@(12));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_18;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = titleStr;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@22);
        make.centerX.equalTo(contentView.mas_centerX);
        make.width.equalTo(@220);
        make.height.equalTo(@18);
    }];
    
    UILabel *describeLab = [[UILabel alloc] init];
    describeLab.font = TEXT_FONT_14;
    describeLab.textColor = COLOR_AUXILIARY_GREY;
    describeLab.textAlignment = NSTextAlignmentCenter;
    describeLab.text = describeStr;
    describeLab.numberOfLines = 0;
    [contentView addSubview:describeLab];
    
    [describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.centerX.equalTo(contentView.mas_centerX);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
    }];
    
    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(describeLab.mas_bottom).offset(20);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];
    
    //XYButton *sureButton = [[XYButton alloc] initWithTitle:buttonTitle btnType:ImportanceButton];
    XYButton *testBtn = [[XYButton alloc] initWithSubordinationButtonTitle:buttonTitle isUserInteractionEnabled:YES];
    [testBtn addTarget:self action:@selector(clickStartLocationButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:testBtn];
    
    [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Left));
        make.right.equalTo(@(-Margin_Right));
        make.top.equalTo(split2View.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(contentView.mas_bottom);
    }];
}

-(void)clickStartLocationButton:(id)sender {
    if (self.clickStartLocationButton) {
        self.clickStartLocationButton(YES);
    }
}

#pragma mark - 功能上线通知 弹窗

- (id)initWithNewFunctionAlertViewWithFrame:(CGRect)frame title:(NSString *)titleStr describe:(NSString *)describeStr leftButtonTitle:(NSString *)leftBtnTitleStr rightButtonTitle:(NSString *)rightBtnTitleStr {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [self createNewFunctionAlertViewWithFrame:frame title:titleStr describe:describeStr leftButtonTitle:leftBtnTitleStr rightButtonTitle:rightBtnTitleStr];
    }
    
    return self;
}

- (void)createNewFunctionAlertViewWithFrame:(CGRect)frame title:(NSString *)titleStr describe:(NSString *)describeStr leftButtonTitle:(NSString *)leftBtnTitleStr rightButtonTitle:(NSString *)rightBtnTitleStr {
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(270));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = TEXT_FONT_18;
    titleLab.textColor = COLOR_MAIN_GREY;
    titleLab.text = titleStr;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@22);
        make.centerX.equalTo(contentView.mas_centerX);
        make.width.equalTo(@220);
        make.height.equalTo(@18);
    }];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.f; // 字体的行间距
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                 NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY,
                                 NSFontAttributeName : TEXT_FONT_14
                                 };
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:describeStr attributes:attributes];
    
    UILabel *describeLab = [[UILabel alloc] init];
    describeLab.attributedText = attrStr;
    describeLab.numberOfLines = 0;
    [contentView addSubview:describeLab];
    
    [describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(12);
        make.centerX.equalTo(contentView.mas_centerX);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
    }];
    
    UIView *splitView = [[UIView alloc] init];
    splitView.backgroundColor = COLOR_LINE;
    [contentView addSubview:splitView];
    
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(describeLab.mas_bottom).offset(20);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
    }];
    
    //XYButton *sureButton = [[XYButton alloc] initWithTitle:buttonTitle btnType:ImportanceButton];
    XYButton *leftBtn = [[XYButton alloc] initWithSubordinationButtonTitle:leftBtnTitleStr isUserInteractionEnabled:YES];
    [leftBtn setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickLetfBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:leftBtn];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(splitView.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height));
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
    verticalLine.backgroundColor = COLOR_LINE;
    [contentView addSubview:verticalLine];
    
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right);
        make.top.equalTo(splitView.mas_bottom);
        make.height.equalTo(@(Cell_Height));
        make.width.equalTo(@(Line_Height));
    }];
    
    XYButton *rightBtn = [[XYButton alloc] initWithSubordinationButtonTitle:rightBtnTitleStr isUserInteractionEnabled:YES];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:rightBtn];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(0);
        make.right.equalTo(@(0));
        make.top.equalTo(splitView.mas_bottom).offset(0);
        make.height.equalTo(@(Cell_Height));
        make.width.equalTo(leftBtn.mas_width);
    }];
}

- (void)clickLetfBtn:(id)sender {
    
    if (self.clickCancelButton) {
        self.clickCancelButton();
    }
    [self removeFromSuperview];
}

- (void)clickRightBtn:(id)sender {
    if (self.clickSureButton) {
        self.clickSureButton(nil);
    }
}

#pragma
#pragma - mark MoreSelectAlertView 购买VIP 弹出框
- (id)initWithRadioVipAlertView:(RechargeVipModel *)rechargeVip type:(NSInteger)type

{
    if (self = [super init]) {
        self.backgroundColor = COLOR_COMMON_BLACK_TRANS;
        [self setVipUIWithTitle:rechargeVip type:type];
    }
    return self;
}

- (void)setVipUIWithTitle:(RechargeVipModel *)rechargeVip type:(NSInteger)type {
    
    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:@selector(clickTheDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =
    [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(270));
    }];
    
    XYButton *topBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    topBtn.tag = 100;
    [topBtn addTarget:self action:@selector(clickTheSelectPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:topBtn];
    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@46.5);
        make.top.equalTo(contentView.mas_top);
        make.left.right.equalTo(contentView);
    }];
    
    XYButton *bttomBtn = [[XYButton alloc] initWithGeneralBtnTitle:nil titleColor:nil isUserInteractionEnabled:YES];
    bttomBtn.tag = 101;
    [bttomBtn addTarget:self action:@selector(clickTheSelectPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:bttomBtn];
    [bttomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@47);
        make.bottom.equalTo(contentView.mas_bottom);
        make.left.right.equalTo(contentView);
    }];
    
    UILabel *labelAccount = [[UILabel alloc] init];
    labelAccount.font = TEXT_FONT_14;
    labelAccount.textColor = COLOR_MAIN_GREY;
    labelAccount.text = @"账户余额(元)";
    [contentView addSubview:labelAccount];
    [labelAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.top.equalTo(@Margin_Top);
    }];
    
    UIImageView *imageTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_select"]];
    imageTop.tag = 88;
    [contentView addSubview:imageTop];
    [imageTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-Margin_Right);
        make.centerY.equalTo(labelAccount.mas_centerY);
    }];
    
    UILabel *labelMoneyAccount = [[UILabel alloc] init];
    labelMoneyAccount.font = TEXT_FONT_14;
    labelMoneyAccount.textColor = COLOR_ORANGE;
    labelMoneyAccount.tag = 1001;
    labelMoneyAccount.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [rechargeVip.vipCombo.usableAmount doubleValue]]];
    
    [contentView addSubview:labelMoneyAccount];
    [labelMoneyAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageTop.mas_left).offset(-Margin_Left);
        make.top.equalTo(@Margin_Top);
    }];
    
    UIView *split3View = [[UIView alloc] init];
    split3View.backgroundColor = COLOR_LINE;
    [contentView addSubview:split3View];
    [split3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelAccount.mas_bottom).offset(Margin_Top);
        make.left.equalTo(@Margin_Left);
        make.height.equalTo(@Line_Height);
        make.right.equalTo(@-Margin_Right);
    }];
    
    UILabel *labelAccountIntegration = [[UILabel alloc] init];
    labelAccountIntegration.font = TEXT_FONT_14;
    labelAccountIntegration.textColor = COLOR_MAIN_GREY;
    labelAccountIntegration.text = @"账户积分";
    [contentView addSubview:labelAccountIntegration];
    [labelAccountIntegration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Left);
        make.top.equalTo(split3View.mas_bottom).offset(Margin_Top);
        make.bottom.equalTo(@-Margin_Bottom);
    }];
    
    UIImageView *imageBttom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_noraml"]];
    imageBttom.tag = 89;
    [contentView addSubview:imageBttom];
    [imageBttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-Margin_Right);
        make.centerY.equalTo(labelAccountIntegration.mas_centerY);
    }];
    
    UILabel *labelIntegrationAccount = [[UILabel alloc] init];
    labelIntegrationAccount.font = TEXT_FONT_14;
    labelIntegrationAccount.textColor = COLOR_ORANGE;
    labelIntegrationAccount.tag = 1002;
    labelIntegrationAccount.text = [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [rechargeVip.vipCombo.score doubleValue]]];
    [contentView addSubview:labelIntegrationAccount];
    [labelIntegrationAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageBttom.mas_left).offset(-Margin_Left);
        make.centerY.equalTo(labelAccountIntegration.mas_centerY);
    }];
    if (type == 0) {
        imageTop.image = [UIImage imageNamed:@"vip_select"];
        imageBttom.image = [UIImage imageNamed:@"vip_noraml"];
    } else if (type == 1) {
        imageBttom.image = [UIImage imageNamed:@"vip_select"];
        imageTop.image = [UIImage imageNamed:@"vip_noraml"];
    }
}

- (void)clickTheSelectPayBtn:(id)sender {
    UIButton *but = (UIButton *) sender;
    UIImageView *imageTop = (UIImageView *) [self viewWithTag:88];
    UIImageView *imageBttom = (UIImageView *) [self viewWithTag:89];
    UILabel *labelTop = (UILabel *) [self viewWithTag:1001];
    UILabel *labelBttom = (UILabel *) [self viewWithTag:1002];
    
    if (but.tag == 100) {
        
        imageTop.image = [UIImage imageNamed:@"vip_select"];
        imageBttom.image = [UIImage imageNamed:@"vip_noraml"];
        self.clickSureVipButton(labelTop.text, 0);
        [self removeFromSuperview];
    } else if (but.tag == 101) {
        imageTop.image = [UIImage imageNamed:@"vip_noraml"];
        imageBttom.image = [UIImage imageNamed:@"vip_select"];
        self.clickSureVipButton(labelBttom.text, 1);
        [self removeFromSuperview];
    }
}

@end

@implementation XYAlertViewComponent

+ (XYAlertView *)initWithTheTitle:(NSString *)title
            isShowHyperlinkButton:(BOOL)show
                           IsEyes:(BOOL)eyes
                addViewController:(UIViewController *)viewController {
    XYAlertView *alertView = [[XYAlertView alloc] initWithTitle:title
                                          isShowHyperlinkButton:show
                                                         IsEyes:eyes];
    [viewController.view addSubview:alertView];
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view);
    }];
    return alertView;
}

+ (void)initWithRadioAlertViewClueImage:(UIImage *)image
                                  title:(NSMutableAttributedString *)title
                               describe:(NSString *)describe
                      addViewController:(UIViewController *)viewController
                            isHaveIamge:(BOOL)isHave {
    XYAlertView *alertView =
    [[XYAlertView alloc] initWithRadioAlertViewClueImage:image
                                                   title:title
                                                describe:describe
                                             isHaveIamge:isHave];
    [viewController.view addSubview:alertView];
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view);
    }];
}

+ (XYAlertView *)initWithMoreSelectAlertViewTitle:(NSString *)title
                                         describe:(NSString *)describeStr
                                addViewController:
(UIViewController *)viewController {
    XYAlertView *alertView =
    [[XYAlertView alloc] initWithMoreSelectAlertViewTitle:title
                                                 describe:describeStr];
    [viewController.view addSubview:alertView];
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view);
    }];
    return alertView;
}

//定期宝赎回
+ (XYAlertView *)initBackWithTheTitle:(NSString *)title
                isShowHyperlinkButton:(BOOL)show
                               IsEyes:(BOOL)eyes
                   WithRedemptionInfo:(RedemptionInfo *)redemptionInfo
                    addViewController:(UIViewController *)viewController {
    
    XYAlertView *alertView =
    [[XYAlertView alloc] initBackWithTitle:title
                     isShowHyperlinkButton:show
                                    IsEyes:eyes
                        WithRedemptionInfo:redemptionInfo];
    [viewController.view addSubview:alertView];
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view);
    }];
    
    return alertView;
}

#pragma - mark MoreSelectAlertView 购买VIP 弹出框
+ (void)initWithRadioVipAlertView:(RechargeVipModel *)RechargeVip type:(NSInteger)type addViewController:
(UIViewController *)viewController {
    XYAlertView *alertView =
    [[XYAlertView alloc] initWithRadioVipAlertView:RechargeVip type:type];
    [viewController.view addSubview:alertView];
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view);
    }];
}

@end
