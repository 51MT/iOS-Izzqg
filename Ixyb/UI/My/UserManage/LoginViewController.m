//
//  LoginViewController.m
//  Ixyb
//
//  Created by dengjian on 11/18/15.
//  Copyright © 2015 xyb. All rights reserved.
//

#import "LoginViewController.h"

#import "ForgetPasswordViewController.h"
#import "LoginFlowViewController.h"
#import "OpenUDID.h"
#import "PhoneLoginViewController.h"
#import "RegisterViewController.h"
#import "Utility.h"
#import "WebviewViewController.h"

#import "XYUIKit.h"

#import "LoginResponseModel.h"
#import "WebService.h"

#import "XiaoNengSdkUtil.h"

#define VIEW_TAG_SCROLL_VIEW 101001

@interface LoginViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) XYTextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *eyeButton;
@property (nonatomic, strong) ColorButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [UMengAnalyticsUtil event:EVENT_MY_LOGIN_REGISTER];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didTextChanged:(NSNotification *)notification {

    if (self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.loginButton.isColorEnabled = YES;
    } else {
        self.loginButton.isColorEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    self.navItem.title = XYBString(@"string_login", @"登录");
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickBackBtn:)];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"question_mark"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"question_mark_ed"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [button addTarget:self action:@selector(clickTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBar);
        make.right.equalTo(@(-Margin_Right));
    }];

    self.view.backgroundColor = COLOR_BG;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.tag = VIEW_TAG_SCROLL_VIEW;
    scrollView.scrollEnabled = NO;
    [self.view addSubview:scrollView];

    UIView *vi = [[UIView alloc] init];
    [scrollView addSubview:vi];

    [vi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    UIView *headView = [[UIView alloc] init];
    [scrollView addSubview:headView];

    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.width.equalTo(vi.mas_width);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(158));
    }];

    UIView *viewC = [[UIView alloc] init];
    viewC.backgroundColor = COLOR_BG;
    [viewC setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [viewC setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [headView addSubview:viewC];
    [viewC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.centerY.equalTo(headView.mas_centerY);
    }];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_big"]];
    [viewC addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.centerX.equalTo(viewC.mas_centerX);
    }];

    UILabel *logoLabel = [[UILabel alloc] init];
    logoLabel.text = XYBString(@"string_make_chinese_creditable", @"让中国人更有信用");
    logoLabel.textColor = RGBACOLOR(200.0f, 200.0f, 200.0f, 1.0);
    logoLabel.font = [UIFont systemFontOfSize:14.f];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [viewC addSubview:logoLabel];

    [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewC.mas_centerX);
        make.top.equalTo(logoImageView.mas_bottom).offset(Margin_Length);
        make.width.equalTo(@200);
        make.bottom.equalTo(viewC.mas_bottom);
    }];

    UIView *inputBgView = [[UIView alloc] init];
    [scrollView addSubview:inputBgView];
    inputBgView.backgroundColor = COLOR_COMMON_WHITE;
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headView);
        make.top.equalTo(headView.mas_bottom);
    }];

    UIView *split1View = [[UIView alloc] init];
    split1View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split1View];
    [split1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@(0));
        make.height.equalTo(@(Line_Height));
    }];

    self.userNameTextField = [[XYTextField alloc] init];
    self.userNameTextField.placeholder = XYBString(@"str_login_enterTelePhone", @"请输入手机号");
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTextField.font = TEXT_FONT_16;
    self.userNameTextField.isEnabledNoPaste = YES;
    self.userNameTextField.delegate = self;
    NSString *lastUserName = [[NSUserDefaults standardUserDefaults] objectForKey:@"xyb_login_last_username"];
    if (lastUserName && lastUserName.length > 0) {
        self.userNameTextField.text = lastUserName;
    }

    [inputBgView addSubview:self.userNameTextField];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split1View.mas_bottom);
        make.left.equalTo(@Margin_Length);
        make.right.equalTo(@-Margin_Length);
        make.height.equalTo(@(Cell_Height));
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

    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.placeholder = XYBString(@"str_login_enterPassword", @"请输入密码");
    self.passwordTextField.font = TEXT_FONT_16;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    [inputBgView addSubview:self.passwordTextField];

    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(split2View.mas_bottom);
        make.left.equalTo(@(Margin_Length));
        make.right.equalTo(@(-45));
        make.height.equalTo(@(Cell_Height));
    }];

    self.eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.eyeButton.selected = NO;
    [self.eyeButton setImage:[UIImage imageNamed:@"show_pwd"] forState:UIControlStateNormal];
    [self.eyeButton setImage:[UIImage imageNamed:@"show_pwd_selected"] forState:UIControlStateSelected];
    [self.eyeButton addTarget:self action:@selector(clickEyeButton:) forControlEvents:UIControlEventTouchUpInside];
    [inputBgView addSubview:self.eyeButton];
    [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-Margin_Length);
        make.centerY.equalTo(self.passwordTextField);
    }];

    UIView *split3View = [[UIView alloc] init];
    split3View.backgroundColor = COLOR_LINE;
    [inputBgView addSubview:split3View];
    [split3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputBgView);
        make.height.equalTo(@(Line_Height));
        make.top.equalTo(self.passwordTextField.mas_bottom);
        make.bottom.equalTo(inputBgView.mas_bottom);
    }];

    self.loginButton = [[ColorButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30, Cell_Height) Title:XYBString(@"string_login", @"登录") ByGradientType:leftToRight];
    [self.loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.loginButton];

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBgView.mas_left).offset(Margin_Length);
        make.right.equalTo(inputBgView.mas_right).offset(-Margin_Length);
        make.top.equalTo(inputBgView.mas_bottom).offset(20);
        make.height.equalTo(@(Cell_Height));
    }];

    XYButton *forgetPwdButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"string_forget_tradePassword", @"忘记密码?") isUserInteractionEnabled:YES];
    forgetPwdButton.titleLabel.font = TEXT_FONT_14;
    [forgetPwdButton addTarget:self action:@selector(clickForgetPwdButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:forgetPwdButton];

    [forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginButton.mas_left);
        make.top.equalTo(self.loginButton.mas_bottom).offset(10);
    }];

    XYButton *quickLoginButton = [[XYButton alloc] initWithSubordinationButtonTitle:XYBString(@"string_phone_login", @"手机快捷登录") isUserInteractionEnabled:YES];
    quickLoginButton.titleLabel.font = TEXT_FONT_14;
    [quickLoginButton addTarget:self action:@selector(clickPhoneLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:quickLoginButton];

    [quickLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginButton.mas_right);
        make.top.equalTo(self.loginButton.mas_bottom).offset(10);
    }];

    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:XYBString(@"string_register", @"注册") forState:UIControlStateNormal];
    registerButton.titleLabel.font = TEXT_FONT_16;
    [registerButton setTitleColor:COLOR_MAIN_GREY forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(clickRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.backgroundColor = COLOR_COMMON_CLEAR;
    [registerButton.layer setMasksToBounds:YES];
    [registerButton.layer setCornerRadius:6.0f];
    registerButton.layer.borderColor = [COLOR_COMMON_CLEAR CGColor];
    registerButton.layer.borderWidth = Border_Width;
    [scrollView addSubview:registerButton];

    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView.mas_centerX);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];

    [registerButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.loginButton.mas_bottom).offset(25);
    }];

    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = COLOR_LINE;
    [scrollView addSubview:leftLine];

    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(registerButton.mas_centerY);
        make.right.equalTo(registerButton.mas_left).offset(-8);
        make.width.equalTo(@(50));
        make.height.equalTo(@(Line_Height));
    }];

    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = COLOR_LINE;
    [scrollView addSubview:rightLine];

    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(registerButton.mas_centerY);
        make.left.equalTo(registerButton.mas_right).offset(8);
        make.width.equalTo(@(50));
        make.height.equalTo(@(Line_Height));
    }];

    if (self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        self.loginButton.isColorEnabled = YES;
    } else {
        self.loginButton.isColorEnabled = NO;
    }
}

- (void)clickTheRightBtn {
    NSString *urlStr = [RequestURL getNodeJsH5URL:App_Login_Explain_URL withIsSign:NO];
    NSString *titleStr = XYBString(@"string_login_description", @"登录说明");
    WebviewViewController *webView = [[WebviewViewController alloc] initWithTitle:titleStr webUrlString:urlStr];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)clickLoginButton:(id)sender {
    [self hideKeyBorad];
    [self reqLogin];
}

- (void)clickEyeButton:(id)sender {
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    self.eyeButton.selected = !self.eyeButton.selected;
}

- (void)clickRegisterButton:(id)sender {

    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.loginFlowDelegate = self.loginFlowDelegate;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)clickForgetPwdButton:(id)sender {
    ForgetPasswordViewController *forgetPasswordViewController = [[ForgetPasswordViewController alloc] init];
    forgetPasswordViewController.loginFlowDelegate = self.loginFlowDelegate;
    [self.navigationController pushViewController:forgetPasswordViewController animated:YES];
}

- (void)clickPhoneLoginButton:(id)sender {

    PhoneLoginViewController *phoneLoginViewController = [[PhoneLoginViewController alloc] init];
    phoneLoginViewController.loginFlowDelegate = self.loginFlowDelegate;
    [self.navigationController pushViewController:phoneLoginViewController animated:YES];
}

- (void)hideKeyBorad {
    if (self.userNameTextField) {
        [self.userNameTextField resignFirstResponder];
    }
    if (self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
    }
}

- (void)clickBackBtn:(id)sender {

    [self hideKeyBorad];

    if ([Utility shareInstance].isGestureUnlock) {
        [Utility shareInstance].isGestureUnlock = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadLoginView" object:nil];
    }

    if (self.loginFlowDelegate && [self.loginFlowDelegate respondsToSelector:@selector(loginFlowDidFinish:)]) {
        [self.loginFlowDelegate loginFlowDidFinish:LoginFlowStateCancel];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

- (void)reqLogin {

    //页面校验
    NSString *errMsg = nil;

    if (errMsg == nil) {
        errMsg = [Utility checkUserName:self.userNameTextField.text];
    }
    if (errMsg == nil) {
        if (self.passwordTextField.text == nil || self.passwordTextField.text.length <= 0) {
            errMsg = XYBString(@"string_enter_ps", @"请输入密码");
        }
    }
    if (errMsg != nil) {
        [self showPromptTip:errMsg];
        return;
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.userNameTextField.text) {
        [params setObject:self.userNameTextField.text forKey:@"mobilePhone"];
    }

    if (self.passwordTextField.text) {
        [params setObject:self.passwordTextField.text forKey:@"password"];
    }

    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if (deviceToken) {
        [params setObject:deviceToken forKey:@"deviceToken"];
    }

    [self userLoginRequestWebServiceWithParam:params];
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

    if (textField == self.userNameTextField) {
        if (string.length == 0) return YES;

        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
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

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  用户登录接口
 *
 *  @param paramsDic 参数
 */
- (void)userLoginRequestWebServiceWithParam:(NSMutableDictionary *)paramsDic {

    [self showDataLoading];

    NSString *urlPath = [RequestURL getRequestURL:UserLoginRequestURL param:paramsDic];

    [WebService postRequest:urlPath param:paramsDic JSONModelClass:[LoginResponseModel class]

        Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideLoading];
            LoginResponseModel *loginResponseModel = responseObject;

            User *user = [[User alloc] init];
            user.userId = loginResponseModel.user.id;
            user.tel = loginResponseModel.user.mobilePhone;
            user.isHaveAddr = [loginResponseModel.user.isHaveAddr boolValue];
            user.idNumbers = loginResponseModel.user.idNumber;
            user.userName = loginResponseModel.user.username;
            user.isIdentityAuth = loginResponseModel.user.isIdentityAuth;
            user.isPhoneAuth = loginResponseModel.user.isPhoneAuth;
            user.isTradePassword = loginResponseModel.user.isTradePassword;
            user.url = loginResponseModel.user.url;
            user.email = loginResponseModel.user.email;
            user.recommendCode = loginResponseModel.user.recommendCode;
            user.isNewUser = loginResponseModel.user.isNewUser;
            user.loginToken = loginResponseModel.loginToken;
            user.bonusState = loginResponseModel.user.bonusState;
            user.realName = loginResponseModel.user.realName;
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

            NSString *strIdNumber = loginResponseModel.user.idNumber;
            //身份证号缓存
            if (strIdNumber.length > 0 && strIdNumber) {
                [[NSUserDefaults standardUserDefaults] setObject:strIdNumber forKey:@"xsd_idNumber"];
            }

            //用户名：手机号码缓存
            NSString *lastLoginName = [paramsDic objectForKey:@"mobilePhone"];
            if (lastLoginName && lastLoginName.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:lastLoginName forKey:@"xyb_login_last_username"];
            }

            //登录成功初始化小能 用户
            [XiaoNengSdkUtil initXNUser];


            //缓存是否测评字段
            [self synchronizeTheTestState:loginResponseModel.isEvaluation];
            //缓存是否强制测评字段，后台可控
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
        }

    ];
}

@end
