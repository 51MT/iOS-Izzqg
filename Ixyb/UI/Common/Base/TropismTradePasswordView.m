//
//  TropismTradePasswordView.m
//  Ixyb
//
//  Created by qiushuitian on 6/1/2016.
//  Copyright © 2016 xyb. All rights reserved.
//

#import "AppDelegate.h"
#import "CALayer+Anim.h"
#import "TropismTradePasswordView.h"
#import "User.h"
#import "Utility.h"
#import "WebService.h"
#import "WithdrawalsCounterFeeModel.h"

#define FIELDBACKVIEWTAG 1002
#define FIELDTAG 1003
#define BUTTONSURE 1004
#define ERRORLABTAG 1005

@interface TropismTradePasswordView () <UITextFieldDelegate>

@property (nonatomic, strong) TropismTradePasswordViewCompletion completion;
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *feeLabel;

@end

@implementation TropismTradePasswordView

- (id)init {
    if (self = [super init]) {
        if (self.amount == nil) {
            self.amount = @"0.00";
        }
        [self initUI];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorNotification:) name:@"TROPISM_ERRORNOTIFICATION" object:nil];
    }
    return self;
}

- (void)show:(TropismTradePasswordViewCompletion)completion {
    self.completion = completion;
    if (self.amount == nil) {
        self.amount = @"0.00";
    }
    if ([self.amount doubleValue] == 0) {
        self.amountLabel.text = XYBString(@"string_tropism_amount_zero", @"0.00元");
    } else {
        self.amountLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", [self.amount doubleValue]]]];
    }

    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app.window);
    }];

    //手续费
    [self updateFee];
}

- (void)clickBackBtn {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(TropismTradePasswordViewActionCancel, nil);
        self.completion = nil;
    }
}

- (void)updateFee {
    NSDictionary *param = @{ @"userId" : [UserDefaultsUtil getUser].userId,
                             @"amount" : self.amount };
    NSString *urlPath = [RequestURL getRequestURL:AccountDrawMoneyFeeURL param:param];
    [WebService postRequest:urlPath param:param JSONModelClass:[WithdrawalsCounterFeeModel class] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WithdrawalsCounterFeeModel *withdrawalsCounterFee = responseObject;
        if (withdrawalsCounterFee.resultCode == 1) {
            double fee = [withdrawalsCounterFee.drawMoneyFee doubleValue];
            if (fee == 0) {
                self.feeLabel.text = XYBString(@"string_fee_zero", @"0.00元");
            } else {
                self.feeLabel.text = [NSString stringWithFormat:@"%@元", [Utility replaceTheNumberForNSNumberFormatter:[NSString stringWithFormat:@"%.2f", fee]]];
            }
        }
    }
        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self showPromptTip:errorMessage];
        }];
}

- (void)initUI {
    self.backgroundColor = COLOR_COMMON_BLACK_TRANS;

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.height.equalTo(@(MainScreenHeight - 40));
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [COLOR_COMMON_WHITE colorWithAlphaComponent:0.95f];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = Corner_Radius_3;
    [self addSubview:contentView];

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(MainScreenWidth - 40));
    }];

    UIButton *deldteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deldteButton setImage:[UIImage imageNamed:@"alret_close"] forState:UIControlStateNormal];
    [deldteButton addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:deldteButton];

    [deldteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Margin_Length));
        make.left.equalTo(@(Margin_Length));
        //        make.width.height.equalTo(@20);
    }];

    User *user = [UserDefaultsUtil getUser];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = COLOR_MAIN_GREY;
    self.titleLabel.font = TEXT_FONT_16;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
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

    //    UILabel *amountTitleLabel = [[UILabel alloc] init];
    //    amountTitleLabel.font = TEXT_FONT_14;
    //    amountTitleLabel.textColor = COLOR_AUXILIARY_GREY;
    //    amountTitleLabel.text = XYBString(@"string_tropism_amount_some", @"提现金额");
    //    [contentView addSubview:amountTitleLabel];
    //
    //    [amountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(@(Margin_Length));
    //        make.top.equalTo(lineView.mas_bottom).offset(Text_Margin_Length);
    //    }];

    //    self.amountLabel = [[UILabel alloc] init];
    //    self.amountLabel.font = TEXT_FONT_14;
    //    self.amountLabel.textColor = COLOR_MAIN_GREY;
    //    self.amountLabel.text = [NSString stringWithFormat:@"%@元", self.amount];
    //    [contentView addSubview:self.amountLabel];
    //
    //    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(amountTitleLabel.mas_centerY);
    //        make.right.equalTo(@(-Margin_Length));
    //    }];

    //    UILabel *feeTitleLabel = [[UILabel alloc] init];
    //    feeTitleLabel.font = TEXT_FONT_14;
    //    feeTitleLabel.textColor = COLOR_AUXILIARY_GREY;
    //    feeTitleLabel.text = XYBString(@"string_fee_zero_d", @"手续费");
    //    [contentView addSubview:feeTitleLabel];
    //
    //    [feeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(@(Margin_Length));
    //        make.top.equalTo(amountTitleLabel.mas_bottom).offset(Text_Margin_Length);
    //    }];
    //
    //    self.feeLabel = [[UILabel alloc] init];
    //    self.feeLabel.font = TEXT_FONT_14;
    //    self.feeLabel.textColor = COLOR_MAIN_GREY;
    //    self.feeLabel.text = @"0.00元";
    //    [contentView addSubview:self.feeLabel];
    //
    //    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(feeTitleLabel.mas_centerY);
    //        make.right.equalTo(@(-Margin_Length));
    //    }];

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
    self.passwordTextField.placeholder = @"请输入交易密码";
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
    //    [showBtn setImage:[UIImage imageNamed:@"show_pwd_hl"] forState:UIControlStateHighlighted];
    [showBtn setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [showBtn addTarget:self action:@selector(clickShowPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [fieldBackView addSubview:showBtn];

    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(fieldBackView.mas_right).offset(-10);
        make.centerY.equalTo(self.passwordTextField.mas_centerY);
    }];

    self.sureBtn = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Button_Height) Title:XYBString(@"string_ok", @"确定") ByGradientType:leftToRight];
    [self.sureBtn addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.isColorEnabled = NO;
    self.sureBtn.tag = BUTTONSURE;
    [contentView addSubview:self.sureBtn];

    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldBackView.mas_left);
        make.right.equalTo(fieldBackView.mas_right);
        make.top.equalTo(fieldBackView.mas_bottom).offset(Text_Margin_Length);
        make.height.equalTo(@(Button_Height));
    }];

    XYButton *forgetButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"string_forget_tradePassword", @"忘记密码?") isUserInteractionEnabled:YES];
    [forgetButton addTarget:self action:@selector(clickTheForgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.titleLabel.font = TEXT_FONT_14;
    [contentView addSubview:forgetButton];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Margin_Length));
        make.top.equalTo(self.sureBtn.mas_bottom).offset(Text_Margin_Length);
        make.bottom.equalTo(@(-AlertError_Margin_Bottom));

    }];

    if ([user.isTradePassword boolValue]) {
        self.titleLabel.text = XYBString(@"string_tradePassword", @"交易密码");
        forgetButton.hidden = NO;

    } else {
        self.titleLabel.text = XYBString(@"string_setAndenter_password", @"设置并确认交易密码");
        forgetButton.hidden = YES;
    }
}

- (void)clickCancelButton:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(TropismTradePasswordViewActionCancel, nil);
        self.completion = nil;
    }
}

- (void)clickTheForgetBtn:(id)sender {
    [self removeFromSuperview];
    if (self.completion) {
        self.completion(TropismTradePasswordViewActionForgetPassword, nil);
        self.completion = nil;
    }
}

- (void)clickSubmitButton:(id)sender {

    UILabel *errorLab = (UILabel *) [self viewWithTag:ERRORLABTAG];
    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];

    if (self.passwordTextField.text.length == 0) {
        errorLab.text = XYBString(@"string_pleaseEnter_password", @"请输入交易密码");
        vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
        //添加一个shake动画
        [vi.layer shake];
        //        [HUD showPromptViewWithToShowStr:XYBString(@"string_pleaseEnter_password",@"请输入交易密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![Utility isValidatePassword:self.passwordTextField.text]) {
        errorLab.text = XYBString(@"string_length_password", @"请输入6-20位字符的密码");
        vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
        [vi.layer shake];
        //        [HUD showPromptViewWithToShowStr:XYBString(@"string_length_password",@"请输入6-20位字符的密码") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
        return;
    }

    if (![[UserDefaultsUtil getUser].isTradePassword boolValue]) {
        if (![Utility isValidateCharStr:self.passwordTextField.text]) {
            errorLab.text = XYBString(@"string_role_password", @"密码由数字、英文字母或下划线组成");
            vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
            [vi.layer shake];
            //            [HUD showPromptViewWithToShowStr:XYBString(@"string_role_password",@"密码由数字、英文字母或下划线组成") autoHide:YES afterDelay:1.0 userInteractionEnabled:YES];
            return;
        }
    }

    //    [self removeFromSuperview];
    if (self.completion) {
        self.completion(TropismTradePasswordViewActionOK, self.passwordTextField.text);
        //        self.completion = nil;
    }
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

    if (IS_IPHONE_4_OR_LESS) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(-55));
                make.bottom.equalTo(@(-55));
            }];
        }
                         completion:nil];
    }

    return YES;
} // return NO to disallow editing.

- (void)textFieldDidEndEditing:(UITextField *)textField {

    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    vi.layer.borderColor = COLOR_LIGHTGRAY_BUTTONDISABLE.CGColor;

    if (IS_IPHONE_4_OR_LESS) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(0));
                make.bottom.equalTo(@(0));
            }];
        }
                         completion:nil];
    }
}

- (void)errorNotification:(NSNotification *)note {
    UILabel *errorLab = (UILabel *) [self viewWithTag:ERRORLABTAG];
    UIView *vi = (UIView *) [self viewWithTag:FIELDBACKVIEWTAG];
    if ([note.object isKindOfClass:[NSString class]]) {
        NSString *err = note.object;
        errorLab.text = err;
    }

    vi.layer.borderColor = COLOR_STRONG_RED.CGColor;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
