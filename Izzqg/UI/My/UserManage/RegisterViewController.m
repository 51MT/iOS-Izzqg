//
//  RegisterViewController.m
//  Ixyb
//
//  Created by dengjian on 11/18/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "OpenUDID.h"
#import "OpenUDID.h"
#import "RegisterViewController.h"
#import "Utility.h"

#import "LoginFlowViewController.h"
#import "LoginResponseModel.h"
#import "RTLabel.h"
#import "RegisterProblemViewController.h"
#import "ResponseModel.h"
#import "WebService.h"
#import "WebviewViewController.h"
#import "XYCellLine.h"

#import "XiaoNengSdkUtil.h"

@interface RegisterViewController () <RTLabelDelegate, UITextFieldDelegate>

@property (nonatomic, strong) XYTextField *userNameTextField;
@property (nonatomic, strong) XYTextField *verifyCodeTextField;

@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) XYTextField *passwordTextField;
@property (nonatomic, strong) UIButton *eyeButton;
@property (nonatomic, strong) ColorButton *registerButton;

//@property (nonatomic, strong) UIView *recomendView;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) XYTextField *recomendCodeTextField;
@property (nonatomic, strong) UILabel *tipCheckLabel;

@property (nonatomic, strong) MASConstraint *bottomConstraint;

@end

@implementation RegisterViewController {
    UIView *inputBgView;
    UIView *backView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didTextChanged:(NSNotification *)notification {

    if (self.passwordTextField.text.length > 0 && self.userNameTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0) {
        self.registerButton.isColorEnabled = YES;
    } else {
        self.registerButton.isColorEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initNav {
    self.navItem.title = XYBString(@"string_register", @"注册");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];
    self.view.backgroundColor = COLOR_BG;
}

- (void)initUI {

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];

    UIView *vi = [[UIView alloc] init];
    [scrollView addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@1);
    }];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);

    }];

    UIView *tipView = [[UIView alloc] init];
    [scrollView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(vi.mas_left);
        make.right.equalTo(vi.mas_right);
        make.height.equalTo(@(Cell_Height));
    }];

    UILabel *tipLabel1 = [[UILabel alloc] init];
    tipLabel1.text = XYBString(@"financingWithAgree", @"我已阅读并同意");
    tipLabel1.font = TEXT_FONT_12;
    tipLabel1.textColor = COLOR_MAIN_GREY;
    [tipView addSubview:tipLabel1];
    [tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.centerY.equalTo(tipView.mas_centerY);
    }];

    UIButton *sytkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sytkButton.titleLabel.font = TEXT_FONT_12;
    [sytkButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    [sytkButton setTitle:XYBString(@"string_xyb_service_protocol_beautify", @"《信用宝服务协议》") forState:UIControlStateNormal];
    [sytkButton addTarget:self action:@selector(clickXybfwtkButton:) forControlEvents:UIControlEventTouchUpInside];
    [tipView addSubview:sytkButton];
    [sytkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLabel1.mas_right);
        make.centerY.equalTo(tipView.mas_centerY);
    }];

    inputBgView = [[UIView alloc] init];
    [scrollView addSubview:inputBgView];
    inputBgView.backgroundColor = COLOR_COMMON_WHITE;
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vi);
        make.top.equalTo(tipView.mas_bottom);
    }];

    UIView *split1View = [[UIView alloc] init];
    split1View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split1View];
    [split1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];

    self.userNameTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.placeholder = XYBString(@"str_login_enterTelePhone", @"请输入手机号码");
    self.userNameTextField.font = TEXT_FONT_16;
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTextField.delegate = self;
    [inputBgView addSubview:self.userNameTextField];

    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split1View.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.height.equalTo(@(Cell_Height));
    }];

    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton setTitle:XYBString(@"string_send_varify_code", @"获取验证码") forState:UIControlStateNormal];
    [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    self.codeButton.titleLabel.font = TEXT_FONT_16;
    [self.codeButton addTarget:self action:@selector(clickCodeButton:) forControlEvents:UIControlEventTouchUpInside];

    [inputBgView addSubview:self.codeButton];
    [self.codeButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 20 forAxis:UILayoutConstraintAxisHorizontal];
    [self.codeButton setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-Margin_Length);
        make.centerY.equalTo(self.userNameTextField.mas_centerY);
        make.left.equalTo(self.userNameTextField.mas_right).offset(5);
    }];

    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split2View];
    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(self.userNameTextField.mas_bottom);
    }];

    self.verifyCodeTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    self.verifyCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyCodeTextField.placeholder = XYBString(@"str_login_pleaseEnterEmailCode", @"请输入短信验证码");
    self.verifyCodeTextField.font = TEXT_FONT_16;
    self.verifyCodeTextField.delegate = self;
    [inputBgView addSubview:self.verifyCodeTextField];

    [self.verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split2View.mas_bottom);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(Cell_Height));
    }];

    UIView *split3View = [[UIView alloc] init];
    split3View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split3View];
    [split3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputBgView);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(self.verifyCodeTextField.mas_bottom);
    }];

    UIView *tip2BackView = [[UIView alloc] initWithFrame:CGRectZero];
    tip2BackView.backgroundColor = COLOR_BG;
    [inputBgView addSubview:tip2BackView];

    [tip2BackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vi);
        make.top.equalTo(split3View.mas_bottom);
        make.height.equalTo(@(Cell_Height));
    }];

    UILabel *tip2Label = [[UILabel alloc] init];
    tip2Label.text = XYBString(@"string_set_login_password", @"设置登录密码");
    tip2Label.font = TEXT_FONT_12;
    tip2Label.textColor = COLOR_MAIN_GREY;
    [tip2BackView addSubview:tip2Label];

    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip2BackView.mas_left).offset(Margin_Length);
        make.right.equalTo(tip2BackView.mas_right).offset(-Margin_Length);
        make.top.equalTo(tip2BackView.mas_top);
        make.bottom.equalTo(tip2BackView.mas_bottom);
    }];

    UIView *split4View = [[UIView alloc] init];
    split4View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split4View];

    [split4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(tip2BackView.mas_bottom).offset(0);
    }];

    self.passwordTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.placeholder = XYBString(@"string_pwd_rule", @"6-20位字符,可包含英文数字下划线");
    self.passwordTextField.font = TEXT_FONT_16;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    //self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    [inputBgView addSubview:self.passwordTextField];

    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split4View.mas_bottom);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-60));
        make.height.equalTo(@(Cell_Height));
    }];

    self.eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.eyeButton.selected = NO;
    [self.eyeButton setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    [self.eyeButton setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [self.eyeButton addTarget:self action:@selector(clickEyeButton:) forControlEvents:UIControlEventTouchUpInside];
    [inputBgView addSubview:self.eyeButton];
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.passwordTextField);
    }];

    UIView *split5View = [[UIView alloc] init];
    split5View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split5View];
    [split5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(self.passwordTextField.mas_bottom);
    }];

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = COLOR_BG;
    [inputBgView addSubview:backgroundView];

    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split5View.mas_bottom);
        make.left.right.equalTo(vi);
        make.height.equalTo(@(Cell_Height));
    }];

    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton setBackgroundImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateNormal];
    [self.checkButton addTarget:self action:@selector(clickCheckButton:) forControlEvents:UIControlEventTouchUpInside];
    self.checkButton.selected = NO;
    [self.checkButton setImage:[UIImage imageNamed:@"checkbox_unselected"] forState:UIControlStateNormal];
    [self.checkButton setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
    [backgroundView addSubview:self.checkButton];

    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@Margin_Length);
        make.top.equalTo(@Margin_Length);
    }];

    self.tipCheckLabel = [[UILabel alloc] init];
    self.tipCheckLabel.font = TEXT_FONT_16;
    NSString *text = XYBString(@"string_has_recommend_person", @"我有推荐人(选填)");
    NSMutableAttributedString *detailStr = [[NSMutableAttributedString alloc] initWithString:text];
    [detailStr addAttributes:@{ NSForegroundColorAttributeName : COLOR_AUXILIARY_GREY } range:NSMakeRange(5, [text length] - 5)];
    self.tipCheckLabel.attributedText = detailStr;
    self.tipCheckLabel.userInteractionEnabled = YES;
    [inputBgView addSubview:self.tipCheckLabel];

    [self.tipCheckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkButton.mas_right).offset(5);
        make.centerY.equalTo(self.checkButton.mas_centerY);
        make.bottom.equalTo(backgroundView.mas_bottom);
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCheckButton:)];
    [self.tipCheckLabel addGestureRecognizer:tap];

    backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = COLOR_COMMON_WHITE;
    backView.hidden = YES;
    [inputBgView addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView.mas_bottom);
        make.left.right.equalTo(vi);
        make.height.equalTo(@0);
    }];

    [XYCellLine initWithTopLineAtSuperView:backView];
    [XYCellLine initWithBottomLineAtSuperView:backView];

    self.recomendCodeTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    self.recomendCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.recomendCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.recomendCodeTextField.placeholder = XYBString(@"string_recommend_code", @"推荐码/推荐人手机号码");
    self.recomendCodeTextField.font = TEXT_FONT_16;
    self.recomendCodeTextField.hidden = YES;
    self.recomendCodeTextField.userInteractionEnabled = NO;
    self.recomendCodeTextField.delegate = self;
    [inputBgView addSubview:self.recomendCodeTextField];

    [self.recomendCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView.mas_bottom).offset(0);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@(-Margin_Length));
        make.height.equalTo(@(0));
        make.bottom.equalTo(inputBgView.mas_bottom);
    }];

 
    self.registerButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30.f, Button_Height) Title:XYBString(@"string_register", @"注册")  ByGradientType:leftToRight];
    [self.registerButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.registerButton];

    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vi.mas_left).offset(Margin_Length);
        make.right.equalTo(vi.mas_right).offset(-Margin_Length);
        make.top.equalTo(inputBgView.mas_bottom).offset(20);
        make.height.equalTo(@(Cell_Height));
    }];

    XYButton *hotLineBtn = [[XYButton alloc] initWithSubordinationButtonTitle:@"400-070-7663" isUserInteractionEnabled:YES];
    hotLineBtn.titleLabel.font = TEXT_FONT_14;
    [hotLineBtn addTarget:self action:@selector(clickHotLineButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:hotLineBtn];

    [hotLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.registerButton.mas_right).offset(0);
        make.top.equalTo(self.registerButton.mas_bottom).offset(10);
    }];

    UILabel *problemLab = [[UILabel alloc] initWithFrame:CGRectZero];
    problemLab.font = TEXT_FONT_14;
    problemLab.textColor = COLOR_LIGHT_GREY;
    problemLab.text = XYBString(@"str_register_question", @"注册遇到问题?请联系客服");
    [scrollView addSubview:problemLab];

    [problemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hotLineBtn.mas_left).offset(-3);
        make.centerY.equalTo(hotLineBtn.mas_centerY);
    }];

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.hidden = YES;
    [loginButton setTitle:XYBString(@"string_login", @"登录") forState:UIControlStateNormal];
    loginButton.titleLabel.font = TEXT_FONT_16;
    [loginButton setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    loginButton.backgroundColor = COLOR_COMMON_WHITE;
    [loginButton.layer setMasksToBounds:YES];
    [loginButton.layer setCornerRadius:4.0];
    loginButton.layer.borderColor = [COLOR_LINE CGColor];
    loginButton.layer.borderWidth = Border_Width;
    [scrollView addSubview:loginButton];

    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vi.mas_centerX);
        make.width.equalTo(@85);
        make.height.equalTo(@40);
        make.bottom.equalTo(scrollView.mas_bottom).offset(-35);
        make.top.equalTo(tipView.mas_top).offset(MainScreenHeight - 35 - 40 - 66).priority(MASLayoutPriorityDefaultHigh);
    }];

    [loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.registerButton.mas_bottom).offset(25);
    }];

    if (self.passwordTextField.text.length > 0 && self.userNameTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0) {
        self.registerButton.isColorEnabled = YES;
    } else {
        self.registerButton.isColorEnabled = NO;
    }
}

- (void)clickXybfwtkButton:(id)sender {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Protocol_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"string_xyb_service_protocol", @"信用宝服务协议");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickEyeButton:(id)sender {
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    self.eyeButton.selected = !self.eyeButton.selected;
}

- (void)clickLoginButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRegisterButton:(id)sender {
    [self hideKeyBorad];
    [self reqRegister];
}

- (void)clickCheckButton:(id)sender {
    self.checkButton.selected = !self.checkButton.selected;

    if (self.checkButton.selected) {
        self.recomendCodeTextField.hidden = NO;
        self.recomendCodeTextField.userInteractionEnabled = YES;
        [self.recomendCodeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(Cell_Height));
        }];

        backView.hidden = NO;
        [backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(Cell_Height));
        }];

    } else {
        self.recomendCodeTextField.hidden = YES;
        self.recomendCodeTextField.userInteractionEnabled = NO;
        [self.recomendCodeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];

        backView.hidden = YES;
        [backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}

- (void)hideKeyBorad {
    if (self.userNameTextField) {
        [self.userNameTextField resignFirstResponder];
    }
    if (self.verifyCodeTextField) {
        [self.verifyCodeTextField resignFirstResponder];
    }
}

- (void)clickBackBtn:(id)sender {
    [self hideKeyBorad];

    if (self.loginFlowDelegate && [self.loginFlowDelegate flowType]) {
        NSInteger flowType = [self.loginFlowDelegate flowType];
        if (flowType == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (flowType == 2) {
            if (self.loginFlowDelegate && [self.loginFlowDelegate respondsToSelector:@selector(loginFlowDidFinish:)]) {
                [self.loginFlowDelegate loginFlowDidFinish:LoginFlowStateCancel];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)countDownTheButton {

    __block int timeout = 60;

    dispatch_queue_t queen = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queen);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);

    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.codeButton setTitle:XYBString(@"string_send_varify_code", @"获取验证码") forState:UIControlStateNormal];
                [self.codeButton setBackgroundColor:COLOR_COMMON_WHITE];
                [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
                self.codeButton.titleLabel.font = TEXT_FONT_16;
                self.codeButton.userInteractionEnabled = YES;

            });
        } else {

            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.codeButton setTitle:[NSString stringWithFormat:XYBString(@"string_resend_some", @"重新获取(%@)"), strTime] forState:UIControlStateNormal];
                [self.codeButton setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
                self.codeButton.titleLabel.font = TEXT_FONT_16;
                self.codeButton.userInteractionEnabled = NO;

            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (void)clickCodeButton:(id)sender {
    [self hideKeyBorad];
    [self reqVerifyCode];
}

- (void)reqVerifyCode {

    NSString *errMsg = [Utility checkUserName:self.userNameTextField.text];
    if (errMsg != nil) {
        [self showDelayTip:errMsg];
        return;
    }

    NSDictionary *param = @{
        @"mobilePhone" : self.userNameTextField.text,
        @"businessType" : [NSNumber numberWithInt:1] //1 注册，2 重置密码，3 提现，4 修改交易密码，5 验证原手机 6 绑定新手机
    };

    [self requestGetVerifyCodeWithDictionary:[NSMutableDictionary dictionaryWithDictionary:param]];
}

- (void)requestGetVerifyCodeWithDictionary:(NSMutableDictionary *)param {

    NSString *requestURL = [RequestURL getRequestURL:UserPhoneVerifyCodeRequestURL param:param];

    [self showDataLoading];

    [WebService postRequest:requestURL param:param JSONModelClass:[ResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            [self countDownTheButton];
        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self.codeButton setTitle:XYBString(@"string_send_again", @"重新获取") forState:UIControlStateNormal];
            [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
            self.codeButton.titleLabel.font = TEXT_FONT_16;
            [self.codeButton setBackgroundColor:COLOR_COMMON_WHITE];
            self.codeButton.userInteractionEnabled = YES;

            [self showDelayTip:errorMessage];
        }

    ];
}

- (void)reqRegister {

    NSString *errMsg = nil;

    if (errMsg == nil) {
        errMsg = [Utility checkUserName:self.userNameTextField.text];
    }

    if (errMsg == nil) {
        errMsg = [Utility checkVerifyCode:self.verifyCodeTextField.text];
    }

    if (errMsg == nil) {
        errMsg = [Utility checkPassword:self.passwordTextField.text];
    }

    if (errMsg != nil) {
        [self showPromptTip:errMsg];
        return;
    }

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];

    //设备ID
    [param setObject:[OpenUDID value] forKey:@"deviceId"];

    if (self.userNameTextField.text) {
        [param setObject:self.userNameTextField.text forKey:@"mobilePhone"];
    }

    if (self.passwordTextField.text) {
        [param setObject:self.passwordTextField.text forKey:@"password"];
    }

    if (self.verifyCodeTextField.text) {
        [param setObject:self.verifyCodeTextField.text forKey:@"code"];
    }

    if (self.recomendCodeTextField.text) {
        [param setObject:self.recomendCodeTextField.text forKey:@"referrer"];
    }

    [param setObject:@"App Store" forKey:@"channelType"];

    [self requestRegisterWithDic:param];
}

- (void)requestRegisterWithDic:(NSMutableDictionary *)param {

    NSString *requestURL = [RequestURL getRequestURL:UserRegisterRequestURL param:param];
    [self showDataLoading];
    [WebService postRequest:requestURL param:param JSONModelClass:[LoginResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self hideLoading];

            LoginResponseModel *userModel = responseObject;

            User *user = [[User alloc] init];
            user.tel = userModel.user.mobilePhone;
            user.userId = userModel.user.id;
            user.isHaveAddr = userModel.user.isHaveAddr;
            user.isIdentityAuth = userModel.user.isIdentityAuth;
            user.isPhoneAuth = userModel.user.isPhoneAuth;
            user.isTradePassword = userModel.user.isTradePassword;
            user.recommendCode = userModel.user.recommendCode;
            user.isNewUser = userModel.user.isNewUser;
            user.bonusState = userModel.user.bonusState;
            user.loginToken = userModel.loginToken;
            user.email = userModel.user.email;
            [UserDefaultsUtil setUser:user];

            NSString *lastLoginName = [param objectForKey:@"mobilePhone"];
            if (lastLoginName && lastLoginName.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:lastLoginName forKey:@"xyb_login_last_username"];
            }

            //登录成功初始化小能 用户
            [XiaoNengSdkUtil initXNUser];

            //缓存是否测评字段
            [self synchronizeTheTestState:userModel.isEvaluation];
            //缓存是否强制测评字段，后台可控
            [self synchronizeIsForceEvaluation:userModel.forceEvaluation];

            //现删掉注册成功页面，注册成功toast提示，然后跳转到相应页面 去掉新手弹窗页面 2.0
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"REGISTERSUCESS" object:nil];

            if (self.loginFlowDelegate && [self.loginFlowDelegate respondsToSelector:@selector(loginFlowDidFinish:)]) {
                if ([userModel.user.isIdentityAuth intValue] == 0) {
                    [self.loginFlowDelegate loginFlowDidFinish:LoginFlowStateDoneUnIdentityAuth];
                } else {
                    [self.loginFlowDelegate loginFlowDidFinish:LoginFlowStateDone];
                }
            }
        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {

            [self hideLoading];
            [self.codeButton setTitle:XYBString(@"string_send_again", @"重新获取") forState:UIControlStateNormal];
            [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
            self.codeButton.titleLabel.font = TEXT_FONT_16;
            [self.codeButton setBackgroundColor:COLOR_COMMON_WHITE];
            self.codeButton.userInteractionEnabled = YES;
            [self showDelayTip:errorMessage];

        }];
}

#pragma mark - RTLabelDelegate

- (void)clickHotLineButton:(id)sender {

    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:XYBString(@"str_xyb_lc_tellphone", @"拨打电话") message:@"400-070-7663" delegate:self cancelButtonTitle:XYBString(@"str_common_cancel", @"取消") otherButtonTitles:XYBString(@"str_financing_ok", @"确定"), nil];
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {

        NSURL *hotLineURL = [NSURL URLWithString:@"tel://4000707663"];
        if ([[UIApplication sharedApplication] canOpenURL:hotLineURL]) {
            [[UIApplication sharedApplication] openURL:hotLineURL];
        }
    }
}

#pragma mark - textField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.recomendCodeTextField || textField == self.userNameTextField) {
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }

    if (textField == self.verifyCodeTextField) {
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }

    if (textField == self.passwordTextField) {
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }

    return YES;
}


/**
 *  缓存是否测评的字段
 *
 *  @param isEvaluation 是否测评
 */
- (void)synchronizeTheTestState:(BOOL)isEvaluation {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:isEvaluation forKey:@"isEvaluation"];
    [userDefault synchronize];
}

/**
 *  缓存是否是否强制测评的字段，开关：控制测评弹出框
 *
 *  @param isEvaluation 是否强制测评
 */
- (void)synchronizeIsForceEvaluation:(BOOL)forceEvaluation {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:forceEvaluation forKey:@"forceEvaluation"];
    [userDefault synchronize];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
