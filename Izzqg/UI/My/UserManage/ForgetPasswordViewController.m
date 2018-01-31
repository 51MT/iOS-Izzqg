//
//  ForgetPasswordViewController.m
//  Ixyb
//
//  Created by dengjian on 11/20/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LoginFlowViewController.h"
#import "LoginResponseModel.h"
#import "OpenUDID.h"
#import "RegisterProblemViewController.h"
#import "Utility.h"
#import "WebService.h"

#import "XiaoNengSdkUtil.h"

@interface ForgetPasswordViewController () <UITextFieldDelegate>
@property (nonatomic, strong) XYTextField *userNameTextField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) XYTextField *verifyCodeTextField;
@property (nonatomic, strong) ColorButton *commitButton;

@property (nonatomic, strong) UIButton *eyeButton;
@property (nonatomic, strong) XYTextField *passwordTextField;
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didTextChanged:(NSNotification *)notification {

    if (self.userNameTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.commitButton.isColorEnabled = YES;
    } else {
        self.commitButton.isColorEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    self.navItem.title = XYBString(@"string_forget_password", @"忘记密码");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    self.view.backgroundColor = COLOR_BG;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];

    UIView *vi = [[UIView alloc] init];
    [scrollView addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.width.equalTo(@(MainScreenWidth));
        make.height.equalTo(@1);
    }];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);

    }];

    UIView *inputBgView = [[UIView alloc] init];
    [scrollView addSubview:inputBgView];
    inputBgView.backgroundColor = COLOR_COMMON_WHITE;
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(vi);
        make.top.equalTo(@16);
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
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTextField.placeholder = XYBString(@"str_login_enterTelePhone", @"请输入手机号码");
    self.userNameTextField.font = TEXT_FONT_16;
    self.userNameTextField.delegate = self;
    [inputBgView addSubview:self.userNameTextField];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split1View.mas_bottom);
        make.left.equalTo(@(Margin_Length));
        make.height.equalTo(@53);
    }];

    NSString *lastUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"xyb_login_last_username"];
    if (lastUserName && lastUserName.length > 0) {
        self.userNameTextField.text = lastUserName;
    }

    self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeButton setTitle:XYBString(@"str_account_KqCharge_postMessageCode", @"获取验证码") forState:UIControlStateNormal];
    [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    self.codeButton.titleLabel.font = TEXT_FONT_16;
    [self.codeButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 20 forAxis:UILayoutConstraintAxisHorizontal];
    [self.codeButton setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.codeButton addTarget:self action:@selector(clickCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [inputBgView addSubview:self.codeButton];

    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.left.equalTo(self.userNameTextField.mas_right).offset(5);
        make.centerY.equalTo(self.userNameTextField.mas_centerY);
    }];

    UIView *split2View = [[UIView alloc] init];
    split2View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split2View];

    [split2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
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
        make.left.right.equalTo(inputBgView);
        make.top.equalTo(split3View.mas_bottom);
        make.height.equalTo(@(Cell_Height));
    }];

    UILabel *tip2Label = [[UILabel alloc] init];
    tip2Label.text = XYBString(@"str_login_setNewPassword", @"设置新密码");
    tip2Label.font = TEXT_FONT_12;
    tip2Label.textColor = COLOR_LIGHT_GREY;
    [inputBgView addSubview:tip2Label];

    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vi.mas_left).offset(Margin_Length);
        make.right.equalTo(vi.mas_right).offset(-Margin_Length);
        make.top.equalTo(split3View.mas_bottom);
        make.height.equalTo(@(Cell_Height));
    }];

    UIView *split4View = [[UIView alloc] init];
    split4View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split4View];

    [split4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(tip2Label.mas_bottom).offset(0);
    }];

    self.passwordTextField = [[XYTextField alloc] initWithIsEnabledNoPaste:YES];
    self.passwordTextField.placeholder = XYBString(@"str_login_password_setSixToTwenty", @"6-20位字符,可包含英文数字下划线");
    self.passwordTextField.font = TEXT_FONT_16;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.delegate = self;
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
    //    [self.eyeButton setImage:[UIImage imageNamed:@"show_pwd_hl"] forState:UIControlStateHighlighted];
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
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(self.passwordTextField.mas_bottom);
        make.bottom.equalTo(inputBgView.mas_bottom);
    }];

    self.commitButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"str_login_reset_and_login", @"重置密码并登录") ByGradientType:leftToRight];
    [self.commitButton addTarget:self action:@selector(clickResetPasswordLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.commitButton];

    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBgView.mas_left).offset(Margin_Length);
        make.right.equalTo(inputBgView.mas_right).offset(-Margin_Length);
        make.top.equalTo(inputBgView.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];

    UIButton *forgetQuestionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetQuestionButton setTitle:XYBString(@"str_login_forget_question", @"忘记密码遇到问题?") forState:UIControlStateNormal];
    [forgetQuestionButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    forgetQuestionButton.titleLabel.font = TEXT_FONT_14;
    [forgetQuestionButton addTarget:self action:@selector(clickForgetQuestionButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:forgetQuestionButton];

    [forgetQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commitButton.mas_right);
        make.top.equalTo(self.commitButton.mas_bottom).offset(10);
    }];

    if (self.userNameTextField.text.length > 0 && self.verifyCodeTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.commitButton.isColorEnabled = YES;
    } else {
        self.commitButton.isColorEnabled = NO;
    }
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

            [self.codeButton setTitle:XYBString(@"str_login_send_again", @"重新获取") forState:UIControlStateNormal];
            [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
            self.codeButton.titleLabel.font = TEXT_FONT_16;
            [self.codeButton setBackgroundColor:COLOR_COMMON_WHITE];
            self.codeButton.userInteractionEnabled = YES;

            [self hideLoading];
            [self showPromptTip:errorMessage];
        }

    ];
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

                [self.codeButton setTitle:XYBString(@"str_account_KqCharge_postMessageCode", @"获取验证码") forState:UIControlStateNormal];
                [self.codeButton setBackgroundColor:COLOR_COMMON_WHITE];
                [self.codeButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
                self.codeButton.titleLabel.font = TEXT_FONT_16;
                self.codeButton.userInteractionEnabled = YES;

            });
        } else {

            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.codeButton setTitle:[NSString stringWithFormat:XYBString(@"str_login_resend_some", @"重新获取(%@)"), strTime] forState:UIControlStateNormal];
                [self.codeButton setTitleColor:COLOR_AUXILIARY_GREY forState:UIControlStateNormal];
                self.codeButton.titleLabel.font = TEXT_FONT_16;
                self.codeButton.userInteractionEnabled = NO;

            });
            timeout--;
        }
    });
    dispatch_resume(timer);
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

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickResetPasswordLoginButton:(id)sender {
    [self.passwordTextField resignFirstResponder];

    NSString *errMsg = nil;
    if (errMsg == nil) {
        errMsg = [Utility checkUserName:self.userNameTextField.text];
    }
    if (errMsg == nil) {
        errMsg = [Utility checkPassword:self.passwordTextField.text];
    }
    if (errMsg == nil) {
        errMsg = [Utility checkVerifyCode:self.verifyCodeTextField.text];
    }
    if (errMsg != nil) {
        [self showPromptTip:errMsg];
        return;
    }

    NSDictionary *param = @{ @"mobilePhone" : self.userNameTextField.text,
                             @"password" : self.passwordTextField.text,
                             @"code" : self.verifyCodeTextField.text };

    [self resetPasswordLoginRequestWithparam:[NSMutableDictionary dictionaryWithDictionary:param]];
}

- (void)resetPasswordLoginRequestWithparam:(NSMutableDictionary *)params {

    [self showDataLoading];

    NSString *urlPath = [RequestURL getRequestURL:ResetPasswordRequestURL param:params];
    [WebService postRequest:urlPath param:params JSONModelClass:[LoginResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            LoginResponseModel *loginResponseModel = responseObject;
            User *user = [[User alloc] init];
            user.userId = loginResponseModel.user.id;
            user.tel = loginResponseModel.user.mobilePhone;
            user.isHaveAddr = [loginResponseModel.user.isHaveAddr boolValue];
            user.userName = loginResponseModel.user.username;
            user.isIdentityAuth = loginResponseModel.user.isIdentityAuth;
            user.isPhoneAuth = loginResponseModel.user.isPhoneAuth;
            user.isTradePassword = loginResponseModel.user.isTradePassword;
            user.url = loginResponseModel.user.url;
            user.recommendCode = loginResponseModel.user.recommendCode;
            user.isNewUser = loginResponseModel.user.isNewUser;
            user.bonusState = loginResponseModel.user.bonusState;
            user.loginToken = loginResponseModel.loginToken;
            [UserDefaultsUtil setUser:user];

            //手势密码
            NSString *userId = loginResponseModel.user.id;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if ([userDefaults objectForKey:userId]) {
                NSDictionary *gestureDic = [userDefaults objectForKey:userId];
                user.gestureUnlock = [gestureDic objectForKey:@"gestureUnlock"];
                user.gestureUnlockNumber = [gestureDic objectForKey:@"gestureUnlockNumber"];
            }
            [userDefaults setObject:[NSDate date] forKey:@"scoreDate"];
            [userDefaults synchronize];

            if ([Utility shareInstance].isGestureUnlock) {
                [Utility shareInstance].isGestureUnlock = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadLoginView" object:nil];
            }

            //用户名：手机号码缓存
            NSString *lastLoginName = [params objectForKey:@"mobilePhone"];
            if (lastLoginName && lastLoginName.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:lastLoginName forKey:@"xyb_login_last_username"];
            }

            //登录成功初始化小能 用户
            [XiaoNengSdkUtil initXNUser];

            //缓存是否测评字段
            [self synchronizeTheTestState:loginResponseModel.isEvaluation];
            //缓存是否强制测评字段
            [self synchronizeIsForceEvaluation:loginResponseModel.forceEvaluation];

            if (self.loginFlowDelegate && [self.loginFlowDelegate respondsToSelector:@selector(loginFlowDidFinish:)]) {
                if ([loginResponseModel.user.isIdentityAuth intValue] == 0) {
                    [self.loginFlowDelegate loginFlowDidFinish:LoginFlowStateDoneUnIdentityAuth];
                } else {
                    [self.loginFlowDelegate loginFlowDidFinish:LoginFlowStateDone];
                }
            }
        }

        fail:^(AFHTTPRequestOperation *operation, NSString *errorMessage) {
            [self hideLoading];
            [self showPromptTip:errorMessage];
        }];
}

- (void)clickEyeButton:(id)sender {
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    self.eyeButton.selected = !self.eyeButton.selected;
    //    if (self.eyeButton.selected) {
    //        [self.eyeButton setImage:[UIImage imageNamed:@"show_pwd_selected_hl"] forState:UIControlStateHighlighted];
    //    }else{
    //        [self.eyeButton setImage:[UIImage imageNamed:@"show_pwd_hl"] forState:UIControlStateHighlighted];
    //    }
}

- (void)clickForgetQuestionButton:(id)sender {
    RegisterProblemViewController *registerProblemViewController = [[RegisterProblemViewController alloc] init];
    [self.navigationController pushViewController:registerProblemViewController animated:YES];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.passwordTextField) {
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }

    } else if (textField == self.verifyCodeTextField) {
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }

    } else if (textField == self.userNameTextField) {
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }

    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
